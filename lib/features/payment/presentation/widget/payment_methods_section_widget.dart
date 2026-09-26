import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/state/check_state_in_get_api_data_widget.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/auto_size_text_widget.dart';
import '../../data/model/payment_methods_model.dart';
import '../riverpod/payment_riverpod.dart';
import 'list_of_pay_method_widget.dart';

class PaymentMethodsSectionWidget extends ConsumerStatefulWidget {
  final String title;
  final ValueChanged<PaymentMethodsModel>? onMethodSelected;
  final bool excludeCashOnDelivery;
  final VoidCallback? onPaymentMethodCleared;

  const PaymentMethodsSectionWidget({
    super.key,
    required this.title,
    this.onMethodSelected,
    this.excludeCashOnDelivery = false,
    this.onPaymentMethodCleared,
  });

  @override
  ConsumerState<PaymentMethodsSectionWidget> createState() =>
      _PaymentMethodsSectionWidgetState();
}

class _PaymentMethodsSectionWidgetState
    extends ConsumerState<PaymentMethodsSectionWidget> {
  static const _cashOnDeliveryMethodName = 'cash_on_delivery';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _clearCashOnDeliverySelectionIfNeeded();
    });
  }

  @override
  void didUpdateWidget(covariant PaymentMethodsSectionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.excludeCashOnDelivery != oldWidget.excludeCashOnDelivery) {
      _clearCashOnDeliverySelectionIfNeeded();
    }
  }

  void _clearCashOnDeliverySelectionIfNeeded() {
    if (!widget.excludeCashOnDelivery) return;

    final selectedMethod = ref.read(selectedPayMethodProvider);
    if (selectedMethod?.name != _cashOnDeliveryMethodName) return;

    ref.read(selectedPayMethodProvider.notifier).state = null;
    ref.read(selectedPayMethodErrorProvider.notifier).state = null;
    widget.onPaymentMethodCleared?.call();
  }

  List<PaymentMethodsModel> _visiblePaymentMethods(
    List<PaymentMethodsModel> paymentMethods,
  ) {
    if (!widget.excludeCashOnDelivery) return paymentMethods;

    return paymentMethods
        .where((method) => method.name != _cashOnDeliveryMethodName)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final payState = ref.watch(getAllPaymentMethodsProvider);
    final errorMessage = ref.watch(selectedPayMethodErrorProvider);
    final visiblePaymentMethods = _visiblePaymentMethods(payState.data);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header with Icon and Trust Badge
        Padding(
          padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.account_balance_wallet_rounded,
                      size: 16.sp,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  8.w.horizontalSpace,
                  AutoSizeTextWidget(
                    text: widget.title,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    colorText: AppColors.mainColorFont,
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(color: Colors.green.shade100),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.shield_outlined,
                      size: 11.sp,
                      color: Colors.green.shade700,
                    ),
                    4.w.horizontalSpace,
                    AutoSizeTextWidget(
                      text: 'دفع آمن ومحمي',
                      fontSize: 8.5.sp,
                      fontWeight: FontWeight.bold,
                      colorText: Colors.green.shade800,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Outer Card Container
        CheckStateInGetApiDataWidget(
          state: payState,
          refresh: () {
            ref.invalidate(getAllPaymentMethodsProvider);
          },
          widgetOfData: Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: const Color(0xFFE5E9F0),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (errorMessage != null)
                  Container(
                    margin: EdgeInsets.only(bottom: 10.h),
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          size: 14.sp,
                          color: AppColors.dangerColor,
                        ),
                        6.w.horizontalSpace,
                        Expanded(
                          child: AutoSizeTextWidget(
                            text: errorMessage,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            colorText: AppColors.dangerColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Inner payment methods list (kept as is)
                ListOfPaymentMethodWidget(
                  paymentData: visiblePaymentMethods,
                  onMethodSelected: widget.onMethodSelected,
                ),
              ],
            ),
          ),
          widgetOfLoading: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 24.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: const Color(0xFFE5E9F0)),
            ),
            child: Center(
              child: SizedBox(
                width: 24.w,
                height: 24.w,
                child: const CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
