import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/extension/string.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/widgets/auto_size_text_widget.dart';
import '../../../../../../core/widgets/online_images_widget.dart';
import '../../../../../../core/widgets/price_and_currency_widget.dart';
import '../../../../../../core/widgets/text_form_field.dart';
import '../../../../../../generated/l10n.dart';
import '../../../../productManagement/detailsProducts/presentation/widget/line_through_price_widget.dart';
import '../../../cart/data/model/cart_model.dart';

class OrderConfirmationProductCardWidget extends StatelessWidget {
  final CartModel data;
  final TextEditingController? printableController;
  final bool isInsideCard;

  const OrderConfirmationProductCardWidget({
    super.key,
    required this.data,
    this.printableController,
    this.isInsideCard = true,
  });

  @override
  Widget build(BuildContext context) {
    final hasColor = (data.colorHex?.isNotEmpty ?? false) || (data.colorName?.isNotEmpty ?? false);
    final hasSize = (data.sizeName?.isNotEmpty ?? false);
    final hasNumber = (data.numberName?.isNotEmpty ?? false);
    final hasDiscount = (data.discount ?? 0) != 0 || (data.couponDiscount ?? 0) != 0;

    return Container(
      margin: isInsideCard ? EdgeInsets.zero : EdgeInsets.only(top: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: isInsideCard
          ? null
          : BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xFFE5E9F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 8.r,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image with rounded frame
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: const Color(0xFFEAECEF)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: OnlineImagesWidget(
                    imageUrl: data.images.toString(),
                    size: Size(78.w, 78.w),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              12.w.horizontalSpace,
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    AutoSizeTextWidget(
                      text: data.productName ?? '',
                      maxLines: 2,
                      fontSize: 12.5.sp,
                      minFontSize: 11,
                      colorText: AppColors.mainColorFont,
                      fontWeight: FontWeight.w600,
                    ),
                    6.h.verticalSpace,

                    // Variants chips (Color, Size, Number)
                    if (hasColor || hasSize || hasNumber)
                      Wrap(
                        spacing: 6.w,
                        runSpacing: 4.h,
                        children: [
                          if (hasColor)
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF6F7F9),
                                borderRadius: BorderRadius.circular(6.r),
                                border: Border.all(color: const Color(0xFFEAECEF)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (data.colorHex?.isNotEmpty ?? false)
                                    Container(
                                      height: 10.h,
                                      width: 10.w,
                                      margin: EdgeInsetsDirectional.only(end: 4.w),
                                      decoration: BoxDecoration(
                                        color: data.colorHex.toString().toColor(),
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.black12, width: 0.5),
                                      ),
                                    ),
                                  if ((data.colorName ?? '').isNotEmpty)
                                    AutoSizeTextWidget(
                                      text: data.colorName!,
                                      fontSize: 10.sp,
                                      colorText: AppColors.fontColor2,
                                    ),
                                ],
                              ),
                            ),
                          if (hasSize)
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF6F7F9),
                                borderRadius: BorderRadius.circular(6.r),
                                border: Border.all(color: const Color(0xFFEAECEF)),
                              ),
                              child: AutoSizeTextWidget(
                                text: '${S.of(context).size}: ${data.sizeName}',
                                fontSize: 10.sp,
                                colorText: AppColors.fontColor2,
                              ),
                            ),
                          if (hasNumber)
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF6F7F9),
                                borderRadius: BorderRadius.circular(6.r),
                                border: Border.all(color: const Color(0xFFEAECEF)),
                              ),
                              child: AutoSizeTextWidget(
                                text: '${S.of(context).number}: ${data.numberName}',
                                fontSize: 10.sp,
                                colorText: AppColors.fontColor2,
                              ),
                            ),
                        ],
                      ),
                    6.h.verticalSpace,

                    // Price & Quantity Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Price
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            PriceAndCurrencyWidget(
                              price: (data.productPriceAfterDiscount ?? data.price ?? 0).toString(),
                              fontSize1: 13.sp,
                              fontSize2: 9.sp,
                            ),
                            if (hasDiscount) ...[
                              6.w.horizontalSpace,
                              Stack(
                                children: [
                                  PriceAndCurrencyWidget(
                                    price: (data.price ?? 0).toString(),
                                    fontSize1: 10.sp,
                                    fontSize2: 7.sp,
                                  ),
                                  Positioned.fill(
                                    child: CustomPaint(
                                      painter: LineThroughPainter(),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),

                        // Quantity Badge
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: AutoSizeTextWidget(
                            text: "${S.of(context).quantity}: ${data.quantity ?? 1}",
                            fontSize: 10.5.sp,
                            fontWeight: FontWeight.bold,
                            colorText: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),

                    // Discount Breakdown tags (if any)
                    if (hasDiscount) ...[
                      4.h.verticalSpace,
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 4.h,
                        children: [
                          if ((data.discount ?? 0) != 0)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AutoSizeTextWidget(
                                  text: "${S.of(context).discountOnBill}: ",
                                  fontSize: 9.5.sp,
                                  colorText: AppColors.fontColor2,
                                ),
                                PriceAndCurrencyWidget(
                                  price: data.discount.toString(),
                                  fontSize1: 9.5.sp,
                                  fontSize2: 6.5.sp,
                                ),
                              ],
                            ),
                          if ((data.couponDiscount ?? 0) != 0)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AutoSizeTextWidget(
                                  text: "${S.of(context).couponDiscount}: ",
                                  fontSize: 9.5.sp,
                                  colorText: AppColors.fontColor2,
                                ),
                                PriceAndCurrencyWidget(
                                  price: data.couponDiscount.toString(),
                                  fontSize1: 9.5.sp,
                                  fontSize2: 6.5.sp,
                                ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          // Customization / Print Note Field
          if ((data.isPrintable ?? 0) != 0 && printableController != null)
            Container(
              margin: EdgeInsets.only(top: 10.h),
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFC),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: const Color(0xFFE5E9F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.edit_note_rounded,
                        size: 16.sp,
                        color: AppColors.primaryColor,
                      ),
                      6.w.horizontalSpace,
                      AutoSizeTextWidget(
                        text: S.of(context).enterProductPrintDescription,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        colorText: AppColors.mainColorFont,
                      ),
                    ],
                  ),
                  6.h.verticalSpace,
                  TextFormFieldWidget(
                    controller: printableController!,
                    hintText: S.of(context).enterProductPrintDescription,
                    hintFontSize: 10.sp,
                    fillColor: Colors.white,
                    maxLine: 2,
                    fieldValidator: (value) {
                      if (value == null || value.toString().isEmpty) {
                        return S.of(context).pleaseEnterProductPrintDescription;
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
