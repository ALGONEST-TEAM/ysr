import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/helpers/navigateTo.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/auto_size_text_widget.dart';
import '../../../../../core/widgets/online_images_widget.dart';
import '../pages/subcategory_product_filter_page.dart';

class HomeCategoryWidget extends ConsumerWidget {
  final String image;
  final String name;
  final double? circularRadius;
  final VoidCallback? onPressed;
  final int idCategory;

  //final List<CategoryData> category;
  const HomeCategoryWidget(
      {super.key,
        required this.name,
        //required this.category,
        this.circularRadius,
        this.onPressed,
        required this.image,
        required this.idCategory
        //required this.index
      });

  @override
  Widget build(BuildContext context, ref) {

    return InkWell(
      onTap: () {
        navigateTo(
          context,
          SubcategoryProductFilterPage(
            idCategory: idCategory,
            nameCategoryForHintSearch: name,
            isSearchPage: false,
          ),
        );
      },
      borderRadius: BorderRadius.circular(12.r),
      child: SizedBox(
        width: 70.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(1.r),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryColor.withValues(alpha: 0.25),
                    AppColors.secondaryColor.withValues(alpha: 0.25),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    spreadRadius: 1,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: ClipOval(
                  child: OnlineImagesWidget(
                    imageUrl: image,
                    circularImage: true,
                    circularRadius: circularRadius ?? 28.sp,
                    backgroundColor: Colors.transparent,
                    size: Size(50.w, 50.h),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            4.h.verticalSpace,
            // Category Title
            Flexible(
              child: AutoSizeTextWidget(
                text: name,
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                colorText: AppColors.fontColor,
                maxLines: 2,
                minFontSize: 9,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}