import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/widgets/auto_size_text_widget.dart';
import '../../../../../../core/widgets/online_images_widget.dart';
import '../../../../home/data/model/vendor_model.dart';
import '../../data/model/cart_model.dart';
import '../riverpod/cart_riverpod.dart';
import 'check_box_for_cart_products_widget.dart';

class VendorCartHeaderWidget extends ConsumerWidget {
  final VendorModel? vendor;
  final List<CartModel> products;

  const VendorCartHeaderWidget({
    super.key,
    required this.vendor,
    required this.products,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = vendor?.name ?? 'متجر غير معروف';
    final logo = vendor?.logo ?? '';
    final cart = ref.watch(cartProvider.notifier);
    ref.watch(cartProvider);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, ),
      decoration: BoxDecoration(
        color: AppColors.scaffoldColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
        border: Border(
          bottom: BorderSide(
            color: AppColors.greySwatch.shade100,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CheckBoxForCartProductsWidget(
                  value: cart.isVendorProductsFullySelected(products),
                  onChanged: (isChecked) {
                    cart.toggleVendorProductsSelection(
                      isChecked ?? false,
                      products,
                    );
                  },
                ),
                4.w.horizontalSpace,
                if (logo.isNotEmpty)
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: AppColors.greySwatch.shade200,
                        width: 0.8,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: OnlineImagesWidget(
                        imageUrl: logo,
                        size: Size(24.w, 24.w),
                        backgroundColor: AppColors.greySwatch.shade50,
                      ),
                    ),
                  )
                else
                  Container(
                    width: 24.w,
                    height: 24.w,
                    decoration: BoxDecoration(
                      color: AppColors.primarySwatch.shade50,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: AppColors.primarySwatch.shade100,
                        width: 0.8,
                      ),
                    ),
                    child: Icon(
                      Icons.storefront_outlined,
                      size: 14.sp,
                      color: AppColors.primaryColor,
                    ),
                  ),
                8.w.horizontalSpace,
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: AutoSizeTextWidget(
                          text: name,
                          colorText: AppColors.mainColorFont,
                          fontWeight: FontWeight.w700,
                          fontSize: 12.sp,
                          maxLines: 1,
                        ),
                      ),
                      4.w.horizontalSpace,
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 5.w,
                          vertical: 1.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primarySwatch.shade50,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: AutoSizeTextWidget(
                          text: "${products.length}",
                          colorText: AppColors.primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 9.5.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          8.w.horizontalSpace,
        ],
      ),
    );
  }
}
