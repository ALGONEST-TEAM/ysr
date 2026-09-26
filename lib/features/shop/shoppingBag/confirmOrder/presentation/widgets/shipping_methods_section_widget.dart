import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/widgets/auto_size_text_widget.dart';
import '../../../../../../generated/l10n.dart';
import '../../data/model/delivery_types_model.dart';
import 'list_of_shipping_methods_widget.dart';
import 'required_inputs_widget.dart';

class ShippingMethodsSectionWidget extends StatelessWidget {
  final List<DeliveryTypesModel> deliveryTypes;
  final FormGroup form;
  final String? title;

  const ShippingMethodsSectionWidget({
    super.key,
    required this.deliveryTypes,
    required this.form,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header with Icon and Badge
        Padding(
          padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.local_shipping_rounded,
                      size: 16.sp,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  8.w.horizontalSpace,
                  AutoSizeTextWidget(
                    text: title ?? S.of(context).shippingMethod,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    colorText: AppColors.mainColorFont,
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.bolt_rounded,
                      size: 12.sp,
                      color: AppColors.primaryColor,
                    ),
                    4.w.horizontalSpace,
                    AutoSizeTextWidget(
                      text: 'خيارات التوصيل',
                      fontSize: 8.5.sp,
                      fontWeight: FontWeight.bold,
                      colorText: AppColors.primaryColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Outer Card Container
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: const Color(0xFFE5E9F0),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListOfShippingMethodsWidget(
                deliveryTypes: deliveryTypes,
                form: form,
              ),
              RequiredInputsWidget(
                form: form,
                value: 'shipping_method_id',
                requiredText: S.of(context).pleaseChoseAShippingMethod,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
