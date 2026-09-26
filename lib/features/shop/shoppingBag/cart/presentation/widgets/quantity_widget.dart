import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/widgets/auto_size_text_widget.dart';

class QuantityWidget extends StatelessWidget {
  final String quantity;
  final bool isLoading;

  const QuantityWidget({
    super.key,
    required this.quantity,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20.h,
      width: 23.w,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: AppColors.scaffoldColor,
        borderRadius: BorderRadius.circular(5.r),
      ),
      alignment: Alignment.center,
      child: isLoading
          ? SpinKitThreeBounce(
              color: AppColors.primaryColor,
              size: 9.3.sp,
            )
          : AutoSizeTextWidget(
              text: quantity,
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              colorText: AppColors.fontColor,
              textAlign: TextAlign.center,
            ),
    );
  }
}
