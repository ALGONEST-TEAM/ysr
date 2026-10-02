import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/widgets/auto_size_text_widget.dart';
import '../../../../../../generated/l10n.dart';
import '../../../../../../core/constants/app_icons.dart';

class FilterWithCounterWidget extends StatelessWidget {
  final int sumOfSelectedItemInFilter;
  final VoidCallback onTap;

  const FilterWithCounterWidget({
    super.key,
    required this.sumOfSelectedItemInFilter,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isActive = sumOfSelectedItemInFilter > 0;
    
    return Row(
      children: [
        // A subtle vertical divider
        Container(
          height: 24.h,
          width: 1.w,
          color: const Color(0xFFE5E7EB),
        ),
        8.w.horizontalSpace,
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(24.r),
            splashColor: AppColors.primaryColor.withValues(alpha: 0.05),
            highlightColor: AppColors.primaryColor.withValues(alpha: 0.02),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primaryColor : const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(
                  color: isActive ? AppColors.primaryColor : const Color(0xFFE5E7EB),
                  width: 1.w,
                ),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: AppColors.primaryColor.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        )
                      ]
                    : [],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AutoSizeTextWidget(
                    text: S.of(context).filter,
                    colorText: isActive ? Colors.white : const Color(0xFF4B5563),
                    fontSize: 12.sp,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  ),
                  4.w.horizontalSpace,
                  SvgPicture.asset(
                    AppIcons.filter,
                    colorFilter: ColorFilter.mode(
                      isActive ? Colors.white : const Color(0xFF4B5563),
                      BlendMode.srcIn,
                    ),
                    height: 14.h,
                  ),
                  if (isActive) ...[
                    6.w.horizontalSpace,
                    Container(
                      padding: EdgeInsets.all(4.r),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: AutoSizeTextWidget(
                        text: sumOfSelectedItemInFilter.toString(),
                        colorText: AppColors.primaryColor,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.bold,
                        minFontSize: 1,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
