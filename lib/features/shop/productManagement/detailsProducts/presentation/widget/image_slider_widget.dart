import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/widgets/online_images_widget.dart';
import '../../data/model/product_data.dart';

class ImageSliderWidget extends StatefulWidget {
  final ProductData productData;
  final int? indexColorImage;

  const ImageSliderWidget({
    super.key,
    required this.productData,
    this.indexColorImage,
  });

  @override
  State<ImageSliderWidget> createState() => _ImageSliderWidgetState();
}

class _ImageSliderWidgetState extends State<ImageSliderWidget> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final imagesByColor = widget.productData.colorsProduct!.isNotEmpty
        ? widget.productData.colorsProduct![widget.indexColorImage ?? 0].image ?? []
        : [];
    final allImage = widget.productData.allImage!;
    
    final displayImages = widget.productData.colorHasImage == false
        ? allImage
        : imagesByColor;

    if (displayImages.isEmpty) {
      return SizedBox(
        height: 480.h,
        child: const Center(child: Text("لا توجد صور")),
      );
    }

    if (currentIndex >= displayImages.length) {
      currentIndex = 0;
    }

    return SizedBox(
      height: 440.h,
      child: Stack(
        children: [
              // Main Image
              Positioned.fill(
                child: Center(
                  child: OnlineImagesWidget(
                    imageUrl: displayImages[currentIndex],
                    size: Size(double.infinity, 440.h),
                    borderRadius: 0,
                  ),
                ),
              ),
              
              // Thumbnails Column
              Positioned(
                left: 12.w,
                top: 74.h,
                bottom: 0,
                child: SizedBox(
                  width: 66.w,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: displayImages.length,
                          itemBuilder: (context, index) {
                            final isSelected = index == currentIndex;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  currentIndex = index;
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 8.h),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.r),
                                  gradient: isSelected
                                      ? const LinearGradient(
                                          colors: [
                                            Color(0xFFE5B250),
                                            AppColors.secondaryColor,
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        )
                                      : null,
                                  border: isSelected
                                      ? null
                                      : Border.all(
                                          color: AppColors.greySwatch.shade400,
                                          width: 1.2,
                                        ),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: AppColors.secondaryColor.withValues(alpha: 0.3),
                                            blurRadius: 8,
                                            spreadRadius: 1,
                                            offset: const Offset(0, 4),
                                          ),
                                        ]
                                      : [],
                                ),
                                padding: EdgeInsets.all(isSelected ? 3.sp : 0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.r),
                                  child: Container(
                                    color: Colors.white,
                                    child: OnlineImagesWidget(
                                      imageUrl: displayImages[index],
                                      size: Size(65.w, 65.w),
                                      borderRadius: 10.r,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      if (displayImages.length > 4)
                        Padding(
                          padding: EdgeInsets.only(bottom: 4.h, top: 2.h),
                          child: Icon(
                            Icons.keyboard_double_arrow_down_rounded,
                            color: AppColors.secondaryColor.withValues(alpha: 0.8),
                            size: 28.sp,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
  }
}
