import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/widgets/buttons/default_button.dart';
import '../../../../../../core/helpers/flash_bar_helper.dart';
import '../../../../../../core/helpers/navigateTo.dart';
import '../../../../../../core/state/check_state_in_post_api_data_widget.dart';
import '../../../../../../core/state/state.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/widgets/auto_size_text_widget.dart';
import '../../../../../../core/widgets/price_and_currency_widget.dart';
import '../../../../../../generated/l10n.dart';
import '../../../../../payment/presentation/riverpod/payment_riverpod.dart';
import '../../../confirmOrder/presentation/pages/confirm_order_page.dart';
import '../../../confirmOrder/presentation/riverpod/confirm_order_riverpod.dart';

import '../../data/model/cart_model.dart';
import '../riverpod/cart_riverpod.dart';

class CartBottomBarWidget extends ConsumerWidget {
  const CartBottomBarWidget({super.key, required this.items});

  final List<CartModel> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider.notifier);
    ref.watch(cartProvider);

    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(16.r),
            topLeft: Radius.circular(16.r),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.secondarySwatch.shade50,
              blurRadius: 10.r,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AutoSizeTextWidget(
                  text: S.of(context).theTotal,
                  colorText: AppColors.fontColor2,
                  fontSize: 11.5.sp,
                  fontWeight: FontWeight.w500,
                ),
                4.h.verticalSpace,
                PriceAndCurrencyWidget(
                  price: cart.calculateSelectedTotalPrice().toString(),

                  fontSize1: 16.sp,
                  fontSize2: 11.sp,
                  textWeight1: FontWeight.w700,
                  textWeight2: FontWeight.w600,
                ),
              ],
            ),
            Consumer(
              builder: (context, ref, child) {
                final state = ref.watch(fetchOrderConfirmationDataProvider);
                final ctrl = ref.read(
                  fetchOrderConfirmationDataProvider.notifier,
                );

                final isConfirmLoading =
                    state.stateData == States.loading &&
                    ctrl.lastMode == FetchMode.confirm;

                return CheckStateInPostApiDataWidget(
                  state: state,
                  hasMessageSuccess: false,
                  functionSuccess: () {
                    if (ctrl.lastMode != FetchMode.confirm) return;

                    resetPaymentSelectionState(ref);
                    refreshPaymentExecutionState(ref);
                    navigateTo(
                      context,
                      ConfirmOrderPage(
                        products: cart.selectedProducts,
                        vendor: cart.selectedProducts.isNotEmpty
                            ? cart.selectedProducts.first.vendor
                            : null,
                      ),
                    );
                  },
                  bottonWidget: DefaultButtonWidget(
                    text: "شراء الان",
                    width: 160.w,
                    height: 40.h,
                    textSize: 13.4.sp,
                    fontWeight: FontWeight.w700,
                    borderRadius: 30.r,
                    gradientColors: [
                      AppColors.primarySwatch.shade400,
                      AppColors.primarySwatch.shade700,
                    ],
                    gradientBegin: Alignment.centerLeft,
                    gradientEnd: Alignment.centerRight,
                    withIcon: true,
                    iconData: Icons.shopping_bag_outlined,
                    iconHeight: 21.sp,
                    isLoading: isConfirmLoading,
                    onPressed: () {
                      if (cart.selectedProducts.isEmpty) {
                        showFlashBarWarring(
                          context: context,
                          message: S
                              .of(context)
                              .pleaseSelectTheProductsYouWishToPayFor,
                        );
                      } else if (!cart.isSingleVendorSelected) {
                        showFlashBarWarring(
                          message:
                              "يرجى اختيار منتجات مورد واحد فقط لإتمام الطلب",
                          context: context,
                        );
                      } else {
                        ctrl.getData(
                          products: cart.selectedProducts,
                          mode: FetchMode.confirm,
                        );
                      }
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
