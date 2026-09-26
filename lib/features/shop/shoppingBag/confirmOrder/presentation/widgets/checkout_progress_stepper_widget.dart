import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/widgets/auto_size_text_widget.dart';

class CheckoutProgressStepperWidget extends StatelessWidget {
  const CheckoutProgressStepperWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildProgressStep(
            label: 'السلة',
            isDone: true,
            isActive: false,
            icon: Icons.shopping_bag_outlined,
          ),
          Expanded(
            child: Container(
              height: 2.h,
              color: AppColors.primaryColor,
            ),
          ),
          _buildProgressStep(
            label: 'تأكيد الطلب والدفع',
            isDone: false,
            isActive: true,
            icon: Icons.credit_card_outlined,
          ),
          Expanded(
            child: Container(
              height: 2.h,
              color: Colors.grey.shade300,
            ),
          ),
          _buildProgressStep(
            label: 'اكتمال الطلب',
            isDone: false,
            isActive: false,
            icon: Icons.done_all_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressStep({
    required String label,
    required bool isDone,
    required bool isActive,
    required IconData icon,
  }) {
    Color color;
    Widget innerIcon;

    if (isDone) {
      color = Colors.green.shade600;
      innerIcon = Icon(Icons.check_rounded, color: Colors.white, size: 13.sp);
    } else if (isActive) {
      color = AppColors.primaryColor;
      innerIcon = Icon(icon, color: Colors.white, size: 13.sp);
    } else {
      color = Colors.grey.shade300;
      innerIcon = Icon(icon, color: Colors.grey.shade600, size: 13.sp);
    }

    return Column(
      children: [
        Container(
          width: 26.w,
          height: 26.w,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColors.primaryColor.withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Center(child: innerIcon),
        ),
        4.h.verticalSpace,
        AutoSizeTextWidget(
          text: label,
          fontSize: 9.sp,
          fontWeight: isActive || isDone ? FontWeight.bold : FontWeight.w500,
          colorText: isActive
              ? AppColors.primaryColor
              : (isDone ? Colors.green.shade800 : Colors.grey.shade500),
        ),
      ],
    );
  }
}
