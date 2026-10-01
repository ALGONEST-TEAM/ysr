import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_icons.dart';
import '../../../../../core/helpers/navigateTo.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/auto_size_text_widget.dart';
import '../../../../../core/widgets/buttons/icon_button_widget.dart';
import '../../../../../core/widgets/cart_badge_icon_widget.dart';
import '../../../../../core/widgets/online_images_widget.dart';
import '../../../productManagement/search_product/presntation/page/search_page.dart';
import '../../data/model/vendor_model.dart';

class AppBarVendorWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final VendorModel vendorData;

  const AppBarVendorWidget({super.key, required this.vendorData});

  @override
  Size get preferredSize => Size.fromHeight(56.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      titleSpacing: 0,
      backgroundColor: AppColors.scaffoldColor,
      centerTitle: false,
      automaticallyImplyLeading: false,
      leading: const IconButtonWidget(),
      toolbarHeight: 56.h,
      title: Row(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 44.w,
                height: 44.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryColor,
                      Colors.amber.shade400,
                      AppColors.primaryColor.withValues(alpha: 0.6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: EdgeInsets.all(2.r),
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: OnlineImagesWidget(
                      imageUrl: vendorData.logo ?? '',
                      circularImage: true,
                      fit: BoxFit.cover,
                      backgroundColor: const Color(0xFFF8F9FA),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -1.h,
                right: -2.w,
                child: Container(
                  padding: EdgeInsets.all(1.2.r),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.verified_rounded,
                    color: AppColors.primaryColor,
                    size: 12.sp,
                  ),
                ),
              ),
            ],
          ),
          8.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AutoSizeTextWidget(
                  text: vendorData.name,
                  colorText: const Color(0xFF162238),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  maxLines: 2,
                ),
                if (vendorData.city != null &&
                    vendorData.city!.trim().isNotEmpty) ...[
                  4.verticalSpace,
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        color: AppColors.fontColor3,
                        size: 11.sp,
                      ),
                      4.horizontalSpace,
                      Flexible(
                        child: AutoSizeTextWidget(
                          text: vendorData.city ?? "",
                          colorText: AppColors.fontColor3,
                          fontSize: 10.sp,
                          minFontSize: 8,
                          fontWeight: FontWeight.w500,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButtonWidget(
          height: 18.h,
          icon: AppIcons.search,
          onPressed: () {
            navigateTo(context, SearchPage(hintTextSearch: ""));
          },
        ),
        const CartBadgeIconWidget(),
      ],
    );
  }
}
