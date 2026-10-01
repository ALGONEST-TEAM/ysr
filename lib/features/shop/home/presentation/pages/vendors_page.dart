import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/state/check_state_in_get_api_data_widget.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/auto_size_text_widget.dart';
import '../../../../../core/widgets/secondary_app_bar_widget.dart';
import '../widgets/vendor_store_card_widget.dart';
import '../riverpod/vendor_riverpod.dart';

class VendorsPage extends ConsumerWidget {
  const VendorsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vendorsState = ref.watch(allVendorsProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: SecondaryAppBarWidget(
        title: 'جميع الموردين',
        fontSize: 16.sp,
      ),
      body: CheckStateInGetApiDataWidget(
        state: vendorsState,
        widgetOfData: vendorsState.data.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.store_mall_directory_outlined,
                      size: 60.sp,
                      color: AppColors.fontColor3.withValues(alpha: 0.5),
                    ),
                    12.verticalSpace,
                    AutoSizeTextWidget(
                      text: 'لا يوجد موردين حالياً',
                      colorText: AppColors.fontColor3,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              )
            : ListView.separated(
                padding: EdgeInsets.only(top: 8.h, bottom: 34.h),
                itemCount: vendorsState.data.length,
                separatorBuilder: (context, index) => 14.verticalSpace,
                itemBuilder: (context, index) {
                  return VendorStoreCardWidget(vendor: vendorsState.data[index]);
                },
              ),
      ),
    );
  }
}
