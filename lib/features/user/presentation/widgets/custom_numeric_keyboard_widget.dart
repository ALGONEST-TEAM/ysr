import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';

class CustomNumericKeyboardWidget extends StatelessWidget {
  final Function(String) onKeyboardTap;
  final VoidCallback onBackspace;

  const CustomNumericKeyboardWidget({
    super.key,
    required this.onKeyboardTap,
    required this.onBackspace,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildRow(['1', '2', '3']),
            _buildRow(['4', '5', '6']),
            _buildRow(['7', '8', '9']),
            _buildRow(['', '0', 'backspace']),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(List<String> items) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: items.map((item) {
          if (item.isEmpty) {
            return SizedBox(width: 90.w, height: 45.h);
          }
          if (item == 'backspace') {
            return _buildButton(
              child: Icon(Icons.backspace_outlined, color: AppColors.primaryColor, size: 24.sp),
              onTap: onBackspace,
            );
          }
          return _buildButton(
            child: Text(
              item,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryColor,
              ),
            ),
            onTap: () => onKeyboardTap(item),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildButton({required Widget child, required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        splashColor: AppColors.primaryColor.withValues(alpha: 0.1),
        highlightColor: AppColors.primaryColor.withValues(alpha: 0.05),
        child: Container(
          width: 90.w,
          height: 45.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: child,
        ),
      ),
    );
  }
}
