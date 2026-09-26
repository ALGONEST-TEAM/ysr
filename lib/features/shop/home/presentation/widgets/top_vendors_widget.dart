import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/auto_size_text_widget.dart';
import '../../../../../core/widgets/online_images_widget.dart';
import '../riverpod/home_riverpod.dart';
import '../../data/model/vendor_model.dart';

class TopVendorsWidget extends ConsumerWidget {
  final int categoryId;
  const TopVendorsWidget({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vendors = ref.watch(categoryVendorsProvider(categoryId));

    if (vendors.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w).copyWith(bottom: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 2.w,
                    height: 14.h,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  8.w.horizontalSpace,
                  AutoSizeTextWidget(
                    text: 'أفضل الموردين',
                    colorText: AppColors.fontColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(20.r),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.5.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: Colors.grey.shade200, width: 1.w),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AutoSizeTextWidget(
                        text: 'عرض الكل',
                        colorText: AppColors.fontColor,
                        fontSize: 10.6.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      4.w.horizontalSpace,
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: AppColors.fontColor,
                        size: 9.sp,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // Vendors Horizontal Carousel
        SizedBox(
          height: 120.h,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
            scrollDirection: Axis.horizontal,
            itemCount: vendors.length,
            separatorBuilder: (context, index) => 14.w.horizontalSpace,
            itemBuilder: (context, index) {
              final vendor = vendors[index];
              return _VendorCard(vendor: vendor);
            },
          ),
        ),
      ],
    );
  }
}

/// Luxury Modern Vendor Card
class _VendorCard extends StatelessWidget {
  final VendorModel vendor;

  const _VendorCard({required this.vendor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1.w,
        ),

      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18.r),
        child: InkWell(
          onTap: () {},
          child: Stack(
            children: [
              // Subtle Decorative Gradient Background Wave
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 40.h,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.primaryColor.withValues(alpha: 0.08),
                        AppColors.primaryColor.withValues(alpha: 0.01),
                      ],
                    ),
                  ),
                ),
              ),

              // Main Content Column
              Padding(
                padding: EdgeInsets.fromLTRB(6.w, 8.h, 6.w, 6.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Story Ring Avatar with Squircle Logo
                    Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        // Luxury Story Gradient Ring
                        Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primaryColor,
                                Colors.amber.shade400,
                                AppColors.primaryColor.withValues(alpha: 0.6),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                            child: Container(
                              width: 44.w,
                              height: 44.h,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.r),
                                child: OnlineImagesWidget(
                                  imageUrl: vendor.logo ?? '',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Verified Blue Badge Icon Overlay
                        Positioned(
                          bottom: -2.h,
                          right: -3.w,
                          child: Container(
                            padding: EdgeInsets.all(1.5.w),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.verified_rounded,
                              color: const Color(0xFF1DA1F2),
                              size: 13.sp,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Vendor Name
                    AutoSizeTextWidget(
                      text: vendor.name,
                      colorText: AppColors.fontColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    ),

                    // Sleek "Visit Store" Action Button Pill
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 4.h),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: AppColors.primaryColor.withValues(alpha: 0.15),
                          width: 1.w,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'زيارة المتجر',
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          3.w.horizontalSpace,
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: AppColors.primaryColor,
                            size: 10.sp,
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
}
