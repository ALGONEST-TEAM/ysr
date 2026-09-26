import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../../../../core/constants/app_icons.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/widgets/auto_size_text_widget.dart';
import '../../../../../../core/widgets/show_modal_bottom_sheet_widget.dart';
import '../../../../../../generated/l10n.dart';
import '../../../../address/data/model/address_model.dart';
import '../../../cart/data/model/cart_model.dart';
import '../riverpod/confirm_order_riverpod.dart';
import 'bottom_sheet_design_for_order_confirmation_addresses_widget.dart';
import 'required_inputs_widget.dart';

class AddressToConfirmTheOrderWidget extends ConsumerWidget {
  final List<CartModel> products;
  final List<AddressModel> address;
  final FormGroup form;
  final VoidCallback? onSelectionChanged;

  const AddressToConfirmTheOrderWidget({
    super.key,
    required this.products,
    required this.address,
    required this.form,
    this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StreamBuilder<Object?>(
          stream: form.control('address').valueChanges,
          initialData: form.control('address').value,
          builder: (context, snapshot) {
            return StreamBuilder<Object?>(
              stream: form.control('city_name').valueChanges,
              initialData: form.control('city_name').value,
              builder: (context, snapshot) {
                return StreamBuilder<Object?>(
                  stream: form.control('district').valueChanges,
                  initialData: form.control('district').value,
                  builder: (context, snapshot) {
                    final addressValue =
                        (form.control('address').value as String?)?.trim() ??
                            '';
                    final cityName =
                        (form.control('city_name').value as String?)?.trim() ??
                            '';
                    final district =
                        (form.control('district').value as String?)?.trim() ??
                            '';
                    final locationSummary = [cityName, district]
                        .where((item) => item.isNotEmpty)
                        .join(' - ');

                    final isSelected = addressValue.isNotEmpty;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Section Header
                        Padding(
                          padding: EdgeInsets.only(top: 10.h, bottom: 8.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(6.w),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor
                                          .withValues(alpha: 0.08),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Icon(
                                      Icons.location_on_rounded,
                                      size: 16.sp,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                  8.w.horizontalSpace,
                                  AutoSizeTextWidget(
                                    text: S.of(context).deliveryAddress,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                    colorText: AppColors.mainColorFont,
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: () => _handleAddressTap(context, ref),
                                borderRadius: BorderRadius.circular(8.r),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 6.w,
                                    vertical: 2.h,
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        isSelected
                                            ? Icons.edit_location_alt_outlined
                                            : Icons.add_circle_outline_rounded,
                                        size: 14.sp,
                                        color: AppColors.primaryColor,
                                      ),
                                      4.w.horizontalSpace,
                                      AutoSizeTextWidget(
                                        text: isSelected
                                            ? 'تغيير العنوان'
                                            : 'تحديد عنوان',
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.bold,
                                        colorText: AppColors.primaryColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Main Address Card
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => _handleAddressTap(context, ref),
                            borderRadius: BorderRadius.circular(14.r),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: double.infinity,
                              padding: EdgeInsets.all(14.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14.r),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primaryColor
                                          .withValues(alpha: 0.22)
                                      : const Color(0xFFE5E9F0),
                                  width: isSelected ? 1.2 : 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: isSelected
                                        ? AppColors.primaryColor
                                            .withValues(alpha: 0.05)
                                        : Colors.black.withValues(alpha: 0.02),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: isSelected
                                  ? _buildSelectedAddressContent(
                                      context,
                                      addressValue,
                                      locationSummary,
                                    )
                                  : _buildEmptyAddressContent(context),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
        ),
        RequiredInputsWidget(
          form: form,
          value: 'address',
          requiredText: S.of(context).addressIsRequired,
        ),
      ],
    );
  }

  Widget _buildSelectedAddressContent(
    BuildContext context,
    String addressValue,
    String locationSummary,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Address Icon Container
        Container(
          width: 44.w,
          height: 44.w,
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: AppColors.primaryColor.withValues(alpha: 0.12),
            ),
          ),
          child: SvgPicture.asset(
            AppIcons.deliveryAddress,
            fit: BoxFit.contain,
          ),
        ),
        12.w.horizontalSpace,

        // Address Details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AutoSizeTextWidget(
                text: addressValue,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                colorText: const Color(0xFF1E2348),
                maxLines: 2,
              ),
              if (locationSummary.isNotEmpty) ...[
                5.h.verticalSpace,
                Row(
                  children: [
                    Icon(
                      Icons.near_me_outlined,
                      size: 11.sp,
                      color: AppColors.fontColor2,
                    ),
                    4.w.horizontalSpace,
                    Expanded(
                      child: AutoSizeTextWidget(
                        text: locationSummary,
                        fontSize: 10.sp,
                        colorText: AppColors.fontColor2,
                        fontWeight: FontWeight.w500,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        8.w.horizontalSpace,

        // Arrow or action icon
        Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Icon(
            Icons.arrow_forward_ios_rounded,
            size: 12.sp,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyAddressContent(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44.w,
          height: 44.w,
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.red.shade100),
          ),
          child: Icon(
            Icons.add_location_alt_outlined,
            color: Colors.red.shade600,
            size: 22.sp,
          ),
        ),
        12.w.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizeTextWidget(
                text: 'لم يتم تحديد عنوان التوصيل',
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                colorText: const Color(0xFF1E2348),
              ),
              4.h.verticalSpace,
              AutoSizeTextWidget(
                text: 'انقر هنا لاختيار أو إضافة عنوان استلام طلبك',
                fontSize: 9.5.sp,
                colorText: Colors.grey.shade500,
              ),
            ],
          ),
        ),
        8.w.horizontalSpace,
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: AutoSizeTextWidget(
            text: 'اختيار',
            fontSize: 10.sp,
            fontWeight: FontWeight.bold,
            colorText: AppColors.primaryColor,
          ),
        ),
      ],
    );
  }

  Future<void> _handleAddressTap(BuildContext context, WidgetRef ref) async {
    await scrollShowModalBottomSheetWidget(
      context: context,
      title: S.of(context).yourAddress,
      page: BottomSheetDesignForOrderConfirmationAddressesWidget(
        products: products,
        address: address,
        form: form,
      ),
    );
    if (!context.mounted) return;

    final addressId = form.control('address_id').value;

    if (addressId != null) {
      ref.read(fetchDeliveryProvider(addressId).notifier).getDelivery();
    }
    if (!context.mounted) return;
    onSelectionChanged?.call();
  }
}
