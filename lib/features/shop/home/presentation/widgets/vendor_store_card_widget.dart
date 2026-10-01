import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ysr/core/widgets/buttons/default_button.dart';
import '../../../../../core/helpers/navigateTo.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/auto_size_text_widget.dart';
import '../../../../../core/widgets/online_images_widget.dart';
import '../../data/model/vendor_model.dart';
import '../pages/home_page.dart';

class VendorStoreCardWidget extends StatelessWidget {
  final VendorModel vendor;

  const VendorStoreCardWidget({
    super.key,
    required this.vendor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w,),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: const Color(0xFFF1F5F9),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E293B).withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 6),
            spreadRadius: -2,
          ),
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20.r),
        child: InkWell(
          onTap:
              () {
                navigateTo(context, HomePage(vendorData: vendor));
              },
          borderRadius: BorderRadius.circular(20.r),
          splashColor: AppColors.primaryColor.withValues(alpha: 0.06),
          highlightColor: AppColors.primaryColor.withValues(alpha: 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 105.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20.r)),
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryColor.withValues(alpha: 0.85),
                          const Color(0xFF0F172A),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20.r)),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          if (vendor.logo != null && vendor.logo!.isNotEmpty)
                            ImageFiltered(
                              imageFilter:
                                  ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                              child: Transform.scale(
                                scale: 1.2,
                                child: OnlineImagesWidget(
                                  imageUrl: vendor.logo!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFF0F172A)
                                      .withValues(alpha: 0.65),
                                  AppColors.primaryColor
                                      .withValues(alpha: 0.40),
                                  Colors.black.withValues(alpha: 0.20),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                          ),
                          Positioned(
                            top: -20.h,
                            left: -20.w,
                            child: Container(
                              width: 100.r,
                              height: 100.r,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.06),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10.h,
                    left: 12.w,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.r),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 9.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.35),
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.25),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star_rounded,
                                color: const Color(0xFFFFB800),
                                size: 15.sp,
                              ),
                              4.horizontalSpace,
                              AutoSizeTextWidget(
                                text: (vendor.rating ?? 5.0)
                                    .toStringAsFixed(1),
                                colorText: Colors.white,
                                fontSize: 11.5.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -26.h,
                    right: 16.w,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 66.r,
                          height: 66.r,
                          padding: EdgeInsets.all(2.5.w),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [
                                AppColors.primaryColor,
                                AppColors.secondaryColor,
                                Color(0xFFF3C762),
                                AppColors.primaryColor,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                          ),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(2.w),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: ClipOval(
                              child: OnlineImagesWidget(
                                imageUrl: vendor.logo ?? '',
                                circularImage: true,
                                fit: BoxFit.cover,
                                backgroundColor: const Color(0xFFF8FAFC),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -1.4.h,
                          right: -1.w,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.verified_rounded,
                              color: AppColors.primaryColor,
                              size: 16.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 32.h,
                  left: 16.w,
                  right: 16.w,
                  bottom: 14.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AutoSizeTextWidget(
                                text: vendor.name,
                                colorText: const Color(0xFF0F172A),
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w800,
                                maxLines: 3,
                              ),
                              8.verticalSpace,
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 7.w, vertical: 2.5.h),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF1F5F9),
                                      borderRadius: BorderRadius.circular(6.r),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.location_on_rounded,
                                          color: AppColors.secondaryColor,
                                          size: 11.sp,
                                        ),
                                        3.horizontalSpace,
                                        AutoSizeTextWidget(
                                          text: vendor.city ?? 'اليمن',
                                          colorText: const Color(0xFF64748B),
                                          fontSize: 10.5.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        10.horizontalSpace,
                        DefaultButtonWidget(
                          text: 'زيارة المتجر',
                          width: 108.w,
                          height: 32.h,
                          borderRadius: 8.r,
                          textSize: 11.5.sp,
                          withIcon: true,
                          iconData: Icons.arrow_forward_rounded,
                          iconHeight: 13.sp,
                          iconColor: Colors.white,
                          gradientColors: const [
                            Color(0xFF1B204F),
                            AppColors.primaryColor,
                          ],
                          gradientBegin: Alignment.topRight,
                          gradientEnd: Alignment.bottomLeft,
                          onPressed:
                              () {
                                navigateTo(context, HomePage(vendorData: vendor));
                              },
                        ),
                      ],
                    ),
                    12.verticalSpace,
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 7.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: const Color(0xFFEDF2F7),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildFeatureBadge(
                            icon: Icons.local_shipping_outlined,
                            text: 'شحن سريع',
                            iconColor: const Color(0xFF0284C7),
                          ),
                          _buildDotDivider(),
                          _buildFeatureBadge(
                            icon: Icons.verified_user_outlined,
                            text: 'منتجات أصلية',
                            iconColor: const Color(0xFF10B981),
                          ),
                          _buildDotDivider(),
                          _buildFeatureBadge(
                            icon: Icons.rate_review_outlined,
                            text:
                                '${vendor.reviewsCount ?? 100}+ تقييم',
                            iconColor: const Color(0xFFF59E0B),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDotDivider() {
    return Container(
      width: 3.r,
      height: 3.r,
      decoration: const BoxDecoration(
        color: Color(0xFFCBD5E1),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildFeatureBadge({
    required IconData icon,
    required String text,
    required Color iconColor,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: iconColor, size: 13.sp),
        4.horizontalSpace,
        AutoSizeTextWidget(
          text: text,
          colorText: const Color(0xFF475569),
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }
}

