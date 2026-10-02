import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../core/constants/app_icons.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/widgets/auto_size_text_widget.dart';

class CardOfSubFilterDrawerWidget extends StatefulWidget {
  final String title;
  final Widget child;
  final bool isOpenToRead;

  const CardOfSubFilterDrawerWidget({
    super.key,
    required this.child,
    required this.title,
    required this.isOpenToRead,
  });

  @override
  State<CardOfSubFilterDrawerWidget> createState() =>
      _CardOfSubFilterDrawerWidgetState();
}

class _CardOfSubFilterDrawerWidgetState
    extends State<CardOfSubFilterDrawerWidget> {
  bool readAll = false;

  @override
  Widget build(BuildContext context) {
    final bool isExpanded = readAll || widget.isOpenToRead;
    
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1.w,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () {
            setState(() {
              readAll = !readAll;
            });
          },
          child: Padding(
            padding: EdgeInsets.all(12.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AutoSizeTextWidget(
                      text: widget.title,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      colorText: AppColors.mainColorFont,
                    ),
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: SvgPicture.asset(
                        AppIcons.arrowBottom2,
                        height: 12.4.h,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF6B7280),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ],
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: isExpanded
                      ? Padding(
                          padding: EdgeInsets.only(top: 14.h),
                          child: widget.child,
                        )
                      : const SizedBox(width: double.infinity),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
