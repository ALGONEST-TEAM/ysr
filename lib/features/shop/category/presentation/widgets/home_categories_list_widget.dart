import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/auto_size_text_widget.dart';
import '../../../../../generated/l10n.dart';
import '../../data/model/category_data.dart';
import 'home_category_widget.dart';

class HomeCategoriesList extends StatelessWidget {
  const HomeCategoriesList({super.key, required this.category});

  final List<CategoryData>? category;

  @override
  Widget build(BuildContext context) {
    if (category == null || category!.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        6.verticalSpace,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 8.h),
          child: Row(
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
                text: S.of(context).categories,
                colorText: AppColors.fontColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 100.h,
          width: double.infinity,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: category!.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(left: 4.w),
                child: HomeCategoryWidget(
                  idCategory: category![index].id!,
                  name: category![index].name!,
                  image: category![index].image ?? '',
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
