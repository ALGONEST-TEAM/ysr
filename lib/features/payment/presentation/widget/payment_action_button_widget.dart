import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/state/check_state_in_post_api_data_widget.dart';
import '../../../../core/state/state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/auto_size_text_widget.dart';
import '../../../../core/widgets/buttons/default_button.dart';
import '../../../../core/widgets/price_and_currency_widget.dart';
import '../../../../core/widgets/show_modal_bottom_sheet_widget.dart';
import '../../../../generated/l10n.dart';
import '../../data/model/pay_spec.dart';
import '../../data/model/payment_request_context_model.dart';
import '../riverpod/payment_riverpod.dart';
import 'pay_method_widget.dart';

class PaymentActionButtonWidget extends ConsumerWidget {
  final PaymentRequestContextModel? paymentRequest;
  final PaymentRequestContextModel Function(
    BuildContext context,
    WidgetRef ref,
  )? paymentRequestBuilder;
  final dynamic totalAmount;
  final String buttonText;
  final bool Function(BuildContext context, WidgetRef ref)? onBeforeOpen;
  final void Function(BuildContext context, WidgetRef ref, String? purchaseId)?
  onPaymentSuccess;

  const PaymentActionButtonWidget({
    super.key,
    this.paymentRequest,
    this.paymentRequestBuilder,
    this.totalAmount,
    required this.buttonText,
    this.onBeforeOpen,
    this.onPaymentSuccess,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(confirmPaymentProvider);
    final effectiveTotal = totalAmount ?? paymentRequest?.depositAmount;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (effectiveTotal != null) ...[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AutoSizeTextWidget(
                  text: S.of(context).total,
                  colorText: AppColors.fontColor2,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
                4.h.verticalSpace,
                PriceAndCurrencyWidget(
                  price: effectiveTotal.toString(),
                  fontSize1: 16.sp,
                  fontSize2: 11.sp,
                  textWeight1: FontWeight.bold,
                  textWeight2: FontWeight.bold,
                ),
              ],
            ),
          ),
          12.w.horizontalSpace,
        ],
        CheckStateInPostApiDataWidget(
          state: state,
          functionSuccess: () {
            onPaymentSuccess?.call(context, ref, '00000');
          },
          bottonWidget: DefaultButtonWidget(
            text: buttonText,
            width: 180.w,
            textSize: 13.sp,
            borderRadius: 30.r,
            gradientColors: [
              AppColors.primarySwatch.shade400,
              AppColors.primarySwatch.shade700,
            ],
            gradientBegin: Alignment.centerLeft,
            gradientEnd: Alignment.centerRight,
            withIcon: true,
            iconData:  Icons.check_circle_outline_rounded,
            iconHeight: 18.sp,
            isLoading: state.stateData == States.loading,
            onPressed: () {
              if (onBeforeOpen?.call(context, ref) == false) {
                return;
              }

              final selectedPayMethod = ref.read(selectedPayMethodProvider);
              final paySpec = paySpecForPaymentMethod(selectedPayMethod);

              if (selectedPayMethod == null) {
                ref.read(selectedPayMethodErrorProvider.notifier).state = S
                    .of(context)
                    .pleaseChoseAPaymentMethod;
                return;
              }

              ref.read(selectedPayMethodErrorProvider.notifier).state = null;

              final request =
                  paymentRequest ?? paymentRequestBuilder?.call(context, ref);
              if (request == null) {
                return;
              }

              if (selectedPayMethod.name == 'cash_on_delivery') {
                ref
                    .read(confirmPaymentProvider.notifier)
                    .confirmPayment(
                      paymentRequest: request,
                      payMethodName: selectedPayMethod.name,
                      voucher: '',
                      amount: 0,
                      phoneNumber: '',
                      purchaseId: '00000',
                    );
              } else {
                showTitledBottomSheet(
                  context: context,
                  title: paySpec?.requiresCodeField == false
                      ? selectedPayMethod.title
                      : (paySpec?.codeLabel.isNotEmpty == true
                            ? paySpec!.codeLabel
                            : selectedPayMethod.title),
                  page: PayMethodWidget(
                    paymentRequest: request,
                    onPaymentSuccess: onPaymentSuccess,
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
