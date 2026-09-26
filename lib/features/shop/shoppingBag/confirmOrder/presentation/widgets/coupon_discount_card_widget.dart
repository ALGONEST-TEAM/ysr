import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/state/check_state_in_post_api_data_widget.dart';
import '../../../../../../core/state/data_state.dart';
import '../../../../../../core/state/state.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/widgets/auto_size_text_widget.dart';
import '../../../../../../core/widgets/buttons/default_button.dart';
import '../../../../../../core/widgets/text_form_field.dart';
import '../../../../../../generated/l10n.dart';
import '../../../cart/data/model/cart_model.dart';
import '../../data/model/confirm_order_data_model.dart';
import '../riverpod/confirm_order_riverpod.dart';

class CouponDiscountCardWidget extends StatelessWidget {
  final TextEditingController couponCodeController;
  final DataState<ConfirmOrderDataModel> state;
  final FetchOrderConfirmationDataController ctrl;
  final List<CartModel> products;

  const CouponDiscountCardWidget({
    super.key,
    required this.couponCodeController,
    required this.state,
    required this.ctrl,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    final couponDiscount = state.data.billData?.couponDiscount ?? 0;
    final isCouponApplied = couponDiscount > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: EdgeInsets.only(top: 4.h, bottom: 8.h),
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
                      Icons.confirmation_num_rounded,
                      size: 16.sp,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  8.w.horizontalSpace,
                  AutoSizeTextWidget(
                    text: S.of(context).haveACouponOrDiscountVoucher,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    colorText: AppColors.mainColorFont,
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 3.h,
                ),
                decoration: BoxDecoration(
                  color: AppColors.secondarySwatch.shade50,
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(
                    color:  AppColors.secondarySwatch.shade200,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.local_offer_outlined,
                      size: 11.sp,
                      color: AppColors.secondaryColor,
                    ),
                    4.w.horizontalSpace,
                    AutoSizeTextWidget(
                      text: 'وفّر أكثر',
                      fontSize: 8.5.sp,
                      fontWeight: FontWeight.bold,
                      colorText: AppColors.secondaryColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Card Box
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: isCouponApplied
                  ? Colors.green.shade300
                  : const Color(0xFFE5E9F0),
              width: isCouponApplied ? 1.2 : 1,
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
              TextFormFieldWidget(
                controller: couponCodeController,
                textAlign: TextAlign.center,
                hintText: "أدخل كود الخصم (مثال: YSR10)",
                fillColor: const Color(0xFFF9FAFC),
                borderRadius: 10.r,
                borderSide: const BorderSide(
                  color: Color(0xFFE2E8F0),
                ),
                prefix: Icon(
                  Icons.confirmation_num_outlined,
                  size: 18.sp,
                  color: AppColors.fontColor2.withValues(
                    alpha: 0.7,
                  ),
                ),
                suffixIcon: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 4.h,
                  ),
                  child: CheckStateInPostApiDataWidget(
                    state: state,
                    messageSuccess: S.of(context).couponVerificationSuccess,
                    functionSuccess: () {},
                    hasMessageSuccess: ctrl.lastMode == FetchMode.coupon,
                    bottonWidget: DefaultButtonWidget(
                      text: S.of(context).verify,
                      width: 66.w,
                      textSize: 10.5.sp,
                      height: 32.h,
                      minFontSize: 6,
                      borderRadius: 8.r,
                      gradientColors: [
                        AppColors.primarySwatch.shade400,
                        AppColors.primaryColor,
                      ],
                      isLoading: state.stateData == States.loading &&
                          ctrl.lastMode == FetchMode.coupon,
                      onPressed: () {
                        if (products.isEmpty) {
                          return;
                        }
                        ctrl.getData(
                          products: products,
                          couponCode: couponCodeController.text.trim(),
                          mode: FetchMode.coupon,
                        );
                      },
                    ),
                  ),
                ),
              ),
              if (isCouponApplied) ...[
                8.h.verticalSpace,
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 7.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: Colors.green.shade200,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        size: 15.sp,
                        color: Colors.green.shade700,
                      ),
                      6.w.horizontalSpace,
                      Expanded(
                        child: AutoSizeTextWidget(
                          text: 'تم تطبيق كود الخصم بنجاح: وفرت $couponDiscount ريال',
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                          colorText: Colors.green.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
