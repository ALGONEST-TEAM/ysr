import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/widgets/auto_size_text_widget.dart';

class MainFilterDesignWidget extends StatelessWidget {
  final String title;
  final String icon;
  final Color? color;
  final GestureTapCallback onTap;
  final bool border;

  const MainFilterDesignWidget({
    super.key,
    required this.title,
    required this.icon,
    this.color,
    required this.onTap,
    this.border = false,
  });

  @override
  Widget build(BuildContext context) {
    // Active state (selected filter)
    final activeBgColor = AppColors.primaryColor.withValues(alpha: 0.06);
    final activeBorderColor = AppColors.primaryColor.withValues(alpha: 0.2);
    final activeTextColor = AppColors.primaryColor;

    // Inactive state
    const inactiveBgColor = Color(0xFFF9FAFB);
    const inactiveBorderColor = Color(0xFFE5E7EB);
    const inactiveTextColor = Color(0xFF4B5563);

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24.r),
          splashColor: AppColors.primaryColor.withValues(alpha: 0.05),
          highlightColor: AppColors.primaryColor.withValues(alpha: 0.02),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: border ? activeBgColor : inactiveBgColor,
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(
                color: border ? activeBorderColor : inactiveBorderColor,
                width: 1.w,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: AutoSizeTextWidget(
                    text: title,
                    colorText: border ? activeTextColor : inactiveTextColor,
                    fontSize: 12.sp,
                    minFontSize: 10,
                    fontWeight: border ? FontWeight.w600 : FontWeight.w500,
                    maxLines: 1,
                  ),
                ),
                4.w.horizontalSpace,
                SvgPicture.asset(
                  icon,
                  colorFilter: ColorFilter.mode(
                    border ? activeTextColor : inactiveTextColor,
                    BlendMode.srcIn,
                  ),
                  height: 12.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
