import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ysr/core/widgets/radio_widget.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/auto_size_text_widget.dart';

enum DeliveryMethod { sms, whatsapp }

class OtpDeliveryMethodWidget extends StatefulWidget {
  final Function(DeliveryMethod) onMethodChanged;
  final DeliveryMethod initialMethod;

  const OtpDeliveryMethodWidget({
    super.key,
    required this.onMethodChanged,
    this.initialMethod = DeliveryMethod.sms,
  });

  @override
  State<OtpDeliveryMethodWidget> createState() =>
      _OtpDeliveryMethodWidgetState();
}

class _OtpDeliveryMethodWidgetState extends State<OtpDeliveryMethodWidget> {
  late DeliveryMethod _selectedMethod;

  @override
  void initState() {
    super.initState();
    _selectedMethod = widget.initialMethod;
  }

  void _updateMethod(DeliveryMethod method) {
    if (_selectedMethod == method) return;
    setState(() {
      _selectedMethod = method;
    });
    widget.onMethodChanged(method);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          child: AutoSizeTextWidget(
            text: "طريقة استلام رمز التحقق",
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            colorText: AppColors.primarySwatch.shade400,
          ),
        ),
        8.h.verticalSpace,
        Row(
          children: [
            Expanded(
              child: _MethodCard(
                title: "رسالة نصية",
                iconData: Icons.textsms_outlined,
                isSelected: _selectedMethod == DeliveryMethod.sms,
                onTap: () => _updateMethod(DeliveryMethod.sms),
              ),
            ),
            12.w.horizontalSpace,
            Expanded(
              child: _MethodCard(
                title: "واتساب",
                svgAsset: AppIcons.whatsapp,
                isSelected: _selectedMethod == DeliveryMethod.whatsapp,
                onTap: () => _updateMethod(DeliveryMethod.whatsapp),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MethodCard extends StatelessWidget {
  final String title;
  final IconData? iconData;
  final String? svgAsset;
  final bool isSelected;
  final VoidCallback onTap;

  const _MethodCard({
    required this.title,
    this.iconData,
    this.svgAsset,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected
                  ? AppColors.primaryColor
                  : Colors.grey.withValues(alpha: 0.25),
              width: isSelected ? 1.2 : 1,
            ),
          ),
          child: Row(
            children: [

              if (svgAsset != null)
                SvgPicture.asset(
                  svgAsset!,
                  width: 18.w,
                  height: 18.w,
                  colorFilter: ColorFilter.mode(
                    isSelected ? AppColors.primaryColor : AppColors.fontColor2,
                    BlendMode.srcIn,
                  ),
                )
              else if (iconData != null)
                Icon(
                  iconData,
                  size: 18.sp,
                  color: isSelected
                      ? AppColors.primaryColor
                      : AppColors.fontColor2,
                ),
              8.w.horizontalSpace,

              // Title
              Expanded(
                child: AutoSizeTextWidget(
                  text: title,
                  colorText: isSelected
                      ? AppColors.primaryColor
                      : AppColors.mainColorFont,
                  fontSize: 11.6.sp,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),

              8.w.horizontalSpace,
              RadioWidget(
                selected: isSelected,
                selectedColor: AppColors.secondaryColor,
                border: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
