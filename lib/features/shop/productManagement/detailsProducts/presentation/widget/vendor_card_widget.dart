import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/helpers/navigateTo.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/widgets/auto_size_text_widget.dart';
import '../../../../../../core/widgets/online_images_widget.dart';
import '../../../../home/data/model/vendor_model.dart';
import '../../../../home/presentation/pages/home_page.dart';

class VendorCardWidget extends StatelessWidget {
  final VendorModel? vendor;
  final VoidCallback? onTap;

  const VendorCardWidget({
    super.key,
    this.vendor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (vendor == null) return const SizedBox.shrink();

    final hasCity = vendor!.city != null && vendor!.city!.trim().isNotEmpty;
    final hasRating = vendor!.rating != null && vendor!.rating! > 0;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 12.w,vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap ??
              () {
                if (vendor != null) {
                  navigateTo(
                    context,
                    HomePage(
                      vendorId: vendor!.id,
                      vendorName: vendor!.name,
                      vendorCity: vendor!.city,
                    ),
                  );
                }
              },
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 48.w,
                      height: 48.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(
                          color: AppColors.primaryColor.withValues(alpha:0.12),
                          width: 1.5.w,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha:0.04),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(2.r),
                      child: ClipOval(
                        child: OnlineImagesWidget(
                          imageUrl: vendor!.logo ?? '',
                          circularImage: true,
                          fit: BoxFit.cover,
                          backgroundColor: const Color(0xFFF8F9FA),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -1.h,
                      right: -2.w,
                      child: Container(
                        padding: EdgeInsets.all(1.5.r),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.verified_rounded,
                          color: const Color(0xFF1DA1F2),
                          size: 14.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                12.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 1.5.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: AutoSizeTextWidget(
                              text: 'المتجر الرسمي',
                              colorText: AppColors.primaryColor,
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (hasRating) ...[
                            6.horizontalSpace,
                            Icon(
                              Icons.star_rounded,
                              color: const Color(0xFFFFB800),
                              size: 13.sp,
                            ),
                            2.horizontalSpace,
                            AutoSizeTextWidget(
                              text: vendor!.rating!.toStringAsFixed(1),
                              colorText: const Color(0xFF162238),
                              fontWeight: FontWeight.w700,
                              fontSize: 10.5.sp,
                            ),
                            if (vendor!.reviewsCount != null &&
                                vendor!.reviewsCount! > 0) ...[
                              2.horizontalSpace,
                              AutoSizeTextWidget(
                                text: '(${vendor!.reviewsCount})',
                                colorText: const Color(0xFF8C98A4),
                                fontWeight: FontWeight.w500,
                                fontSize: 9.5.sp,
                              ),
                            ],
                          ],
                        ],
                      ),
                      6.verticalSpace,
                      AutoSizeTextWidget(
                        text: vendor!.name,
                        colorText: const Color(0xFF162238),
                        fontWeight: FontWeight.w700,
                        fontSize: 13.5.sp,
                      ),
                      if (hasCity) ...[
                        3.verticalSpace,
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              color: const Color(0xFF8C98A4),
                              size: 12.sp,
                            ),
                            3.horizontalSpace,
                            Expanded(
                              child: AutoSizeTextWidget(
                                text: vendor!.city!,
                                colorText: const Color(0xFF8C98A4),
                                fontWeight: FontWeight.w500,
                                fontSize: 11.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                8.horizontalSpace,
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
                  decoration: BoxDecoration(
                    color: Color(0xFFF3EFEA),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: AppColors.primaryColor.withValues(alpha:0.12),
                      width: 1.w,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AutoSizeTextWidget(
                        text: 'زيارة المتجر',
                        colorText: AppColors.primaryColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 11.sp,
                      ),
                      4.horizontalSpace,
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: AppColors.primaryColor,
                        size: 10.sp,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
