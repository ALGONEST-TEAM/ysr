import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import '../../theme/app_colors.dart';
import '../auto_size_text_widget.dart';

class DefaultButtonWidget extends StatelessWidget {
  final double? width;

  final double? height;
  final Color? background;
  final Function()? onPressed;
  final String text;
  final double? textSize;
  final Color? textColor;
  final double? borderRadius;
  final double? maxFontSize;
  final double? minFontSize;
  final FontWeight? fontWeight;
  final bool? isLoading;
  final Border? border;
  final bool? withIcon;

  final String? icon;
  final IconData? iconData;
  final Color? iconColor;
  final double? iconHeight;
  final List<Color>? gradientColors;
  final AlignmentGeometry? gradientBegin;
  final AlignmentGeometry? gradientEnd;

  const DefaultButtonWidget({
    super.key,
    this.width = double.infinity,
    this.height,
    this.background,
    this.onPressed,
    required this.text,
    this.textColor,
    this.textSize,
    this.fontWeight,
    this.borderRadius,
    this.maxFontSize,
    this.minFontSize,
    this.isLoading,
    this.border,
    this.withIcon = false,
    this.icon,
    this.iconData,
    this.iconColor,
    this.iconHeight,
    this.gradientColors,
    this.gradientBegin,
    this.gradientEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isLoading == true ? 0.5 : 1,
      child: Container(
        width: width,
        height: height ?? 40.h,
        decoration: BoxDecoration(
          color: gradientColors == null ? (background ?? AppColors.primaryColor) : null,
          gradient: gradientColors != null
              ? LinearGradient(
                  colors: gradientColors!,
                  begin: gradientBegin ?? Alignment.centerRight,
                  end: gradientEnd ?? Alignment.centerLeft,
                )
              : null,
          borderRadius: BorderRadius.circular(borderRadius ?? 12.r),
          border: border ??
              Border.all(
                color: Colors.transparent,
                width: 0,
              ),
        ),
        child: Center(
          child: MaterialButton(
            height: height ?? 40.h,
            minWidth: double.infinity,
            onPressed: isLoading == true ? null : onPressed,
            child: isLoading == true
                ? SpinKitCircle(
                    color: textColor ?? AppColors.whiteColor,
                    size: 20.r,
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AutoSizeTextWidget(
                        text: text,
                        fontSize: textSize ?? 13.sp,
                        colorText: textColor ?? Colors.white,
                        textAlign: TextAlign.center,
                        fontWeight: fontWeight ?? FontWeight.w500,
                        maxFontSize: maxFontSize ?? 25,
                        minFontSize: minFontSize ?? 8,
                      ),
                      Visibility(
                        visible: withIcon == true,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6.w),
                          child: iconData != null
                              ? Icon(
                                  iconData,
                                  size: iconHeight ?? 18.sp,
                                  color: iconColor ?? (textColor ?? Colors.white),
                                )
                              : SvgPicture.asset(
                                  icon ?? '',
                                  height: iconHeight,
                                  colorFilter: iconColor != null
                                      ? ColorFilter.mode(
                                          iconColor!,
                                          BlendMode.srcIn,
                                        )
                                      : null,
                                ),
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
