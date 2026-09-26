import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/widgets/auto_size_text_widget.dart';
import '../../../../../../core/widgets/price_and_currency_widget.dart';
import '../../../../../../generated/l10n.dart';
import '../../data/model/orders_bill_data.dart';

class BillWidget extends StatelessWidget {
  final OrdersBillData billData;
  final num? deliveryCost;

  const BillWidget({
    super.key,
    required this.billData,
    required this.deliveryCost,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveDeliveryCost = deliveryCost ?? 0;
    final totalPayable = billData.totalPayable + effectiveDeliveryCost;
    final totalDiscount = (billData.productDiscount) + (billData.couponDiscount);

    return Container(
      margin: EdgeInsets.only(top: 14.h, bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFE5E9F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 10.r,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFC),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(13.r),
              ),
              border: const Border(
                bottom: BorderSide(color: Color(0xFFEBEFF5), width: 1),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.receipt_long_rounded,
                    size: 16.sp,
                    color: AppColors.primaryColor,
                  ),
                ),
                8.w.horizontalSpace,
                AutoSizeTextWidget(
                  text: 'ملخص الفاتورة',
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.bold,
                  colorText: AppColors.mainColorFont,
                ),
                const Spacer(),
                if (totalDiscount > 0)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: const Color(0xFFA7F3D0)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.local_offer_rounded,
                          size: 11.sp,
                          color: const Color(0xFF059669),
                        ),
                        4.w.horizontalSpace,
                        AutoSizeTextWidget(
                          text: 'وفرت ',
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                          colorText: const Color(0xFF059669),
                        ),
                        PriceAndCurrencyWidget(
                          price: totalDiscount.toString(),
                          fontSize1: 10.sp,
                          fontSize2: 7.sp,
                          colorText1: const Color(0xFF059669),
                          colorText2: const Color(0xFF059669),
                          textWeight1: FontWeight.bold,
                          textWeight2: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // Items List
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            child: Column(
              children: [
                _buildBillItemRow(
                  icon: Icons.shopping_bag_outlined,
                  label: S.of(context).theTotal,
                  price: billData.totalBeforeDiscount,
                ),
                if (billData.totalPrinting != 0)
                  _buildBillItemRow(
                    icon: Icons.print_outlined,
                    label: S.of(context).printingPrice,
                    price: billData.totalPrinting,
                  ),
                _buildBillItemRow(
                  icon: Icons.local_shipping_outlined,
                  label: S.of(context).deliveryCost,
                  price: effectiveDeliveryCost,
                ),
                if (billData.productDiscount != 0)
                  _buildBillItemRow(
                    icon: Icons.discount_outlined,
                    label: S.of(context).discountOnBill,
                    price: billData.productDiscount,
                    isDiscount: true,
                  ),
                if (billData.couponDiscount != 0)
                  _buildBillItemRow(
                    icon: Icons.confirmation_num_outlined,
                    label: S.of(context).couponDiscount,
                    price: billData.couponDiscount,
                    isDiscount: true,
                  ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFC),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(13.r),
              ),
              border: const Border(
                top: BorderSide(color: Color(0xFFEBEFF5), width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeTextWidget(
                      text: S.of(context).total,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      colorText: AppColors.mainColorFont,
                    ),
                    2.h.verticalSpace,
                    AutoSizeTextWidget(
                      text: 'المبلغ الإجمالي المطلوب سداده',
                      fontSize: 9.5.sp,
                      colorText: AppColors.fontColor2,
                    ),
                  ],
                ),
                PriceAndCurrencyWidget(
                  price: totalPayable.toString(),
                  fontSize1: 15.sp,
                  fontSize2: 10.sp,
                  textWeight1: FontWeight.bold,
                  textWeight2: FontWeight.bold,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillItemRow({
    required IconData icon,
    required String label,
    required num price,
    bool isDiscount = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        children: [
          Icon(
            icon,
            size: 15.sp,
            color: isDiscount ? const Color(0xFF059669) : AppColors.fontColor2,
          ),
          8.w.horizontalSpace,
          Expanded(
            child: AutoSizeTextWidget(
              text: label,
              fontSize: 11.5.sp,
              fontWeight: isDiscount ? FontWeight.w600 : FontWeight.w500,
              colorText: isDiscount ? const Color(0xFF059669) : AppColors.mainColorFont,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isDiscount) ...[
                AutoSizeTextWidget(
                  text: '- ',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  colorText: const Color(0xFF059669),
                ),
              ],
              PriceAndCurrencyWidget(
                price: price.toString(),
                fontSize1: 12.sp,
                fontSize2: 8.5.sp,
                colorText1: isDiscount ? const Color(0xFF059669) : AppColors.primaryColor,
                colorText2: isDiscount ? const Color(0xFF059669) : AppColors.secondaryColor,
                textWeight1: FontWeight.w600,
                textWeight2: FontWeight.w600,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
