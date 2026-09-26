import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/network/errors/remote_exception.dart';
import '../../../../../core/state/check_state_in_post_api_data_widget.dart';
import '../../../../../core/state/state.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/auto_size_text_widget.dart';
import '../../../../../core/widgets/bottomNavbar/button_bottom_navigation_bar_design_widget.dart';
import '../../../../../core/widgets/buttons/default_button.dart';
import '../../../../../core/widgets/error_widget.dart';
import '../../../../../core/widgets/logo_shimmer_widget.dart';
import '../../../../../core/widgets/secondary_app_bar_widget.dart';
import '../../../../../generated/l10n.dart';
import '../../data/model/address_model.dart';
import '../riverpod/address_riverpod.dart';
import '../widgets/add_a_new_address_widget.dart';
import '../widgets/confirm_leave_page_dialog_widget.dart';
import '../widgets/view_location_on_map_widget.dart';

class AddOrUpdateAddressPage extends ConsumerWidget {
  final AddressModel address;
  final bool? locationIsEmpty;
  final Function onSuccess;

  const AddOrUpdateAddressPage({
    super.key,
    required this.address,
    required this.onSuccess,
    this.locationIsEmpty = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var addressState = ref.watch(addressProvider(address));
    var citiesState = ref.watch(citiesProvider);
    var districtsState = ref.watch(districtsProvider);
    var mapState = ref.watch(mapProvider);
    final isMapLocationEmpty =
        ref.read(mapProvider.notifier).locationIsEmpty == true;

    return WillPopScope(
      onWillPop: address.id == 0
          ? () => ConfirmLeavePageDialogWidget.show(context)
          : () async => true,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldColor,
        appBar: SecondaryAppBarWidget(
          title: address.id != 0
              ? S.of(context).editAddress
              : S.of(context).addANewAddress,
          onPressed: () async {
            if (address.id != 0) {
              Navigator.of(context).pop();
            } else {
              final shouldPop = await ConfirmLeavePageDialogWidget.show(
                context,
              );
              if (shouldPop) {
                Navigator.of(context).pop();
              }
            }
          },
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          child: Column(
            children: [
              if (citiesState.stateData == States.loading ||
                  districtsState.stateData == States.loading)
                SizedBox(
                  height: MediaQuery.of(context).size.height / 1.2,
                  child: const LogoShimmerWidget(),
                )
              else if (citiesState.stateData == States.error ||
                  districtsState.stateData == States.error)
                Center(
                  child: ErrorsWidget(
                    title: MessageOfErorrApi.getExeptionMessage(
                      citiesState.exception as DioException,
                    ).first,
                    subTitle: MessageOfErorrApi.getExeptionMessage(
                      citiesState.exception as DioException,
                    ).last,
                    onPressed: () {
                      ref.invalidate(citiesProvider);
                      ref.invalidate(districtsProvider);
                    },
                  ),
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: AppColors.greySwatch.shade100,
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 16.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8.sp),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor.withValues(
                                    alpha: 0.08,
                                  ),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Icon(
                                  Icons.location_on_rounded,
                                  color: AppColors.primaryColor,
                                  size: 20.sp,
                                ),
                              ),
                              10.w.horizontalSpace,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AutoSizeTextWidget(
                                    text: address.id != 0
                                        ? S.of(context).editAddress
                                        : S.of(context).addANewAddress,
                                    fontSize: 14.sp,
                                    colorText: AppColors.mainColorFont,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  2.h.verticalSpace,
                                  AutoSizeTextWidget(
                                    text: S.of(context).address,
                                    fontSize: 11.sp,
                                    colorText: AppColors.fontColor2,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          14.h.verticalSpace,
                          const Divider(
                            height: 1,
                            thickness: 1,
                            color: Color(0xfff0f1f5),
                          ),
                          12.h.verticalSpace,
                          AddANewAddressWidget(address: address),
                        ],
                      ),
                    ),
                    16.h.verticalSpace,
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: isMapLocationEmpty && locationIsEmpty == true
                              ? AppColors.dangerSwatch.shade200
                              : AppColors.greySwatch.shade100,
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(14.sp),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8.sp),
                                decoration: BoxDecoration(
                                  color: AppColors.secondaryColor.withValues(
                                    alpha: 0.12,
                                  ),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Icon(
                                  Icons.map_rounded,
                                  color: AppColors.secondaryColor,
                                  size: 20.sp,
                                ),
                              ),
                              10.w.horizontalSpace,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AutoSizeTextWidget(
                                      text: S
                                          .of(context)
                                          .pleaseLocateOnTheMap
                                          .replaceAll('*', '')
                                          .trim(),
                                      fontSize: 13.5.sp,
                                      colorText: AppColors.mainColorFont,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    2.h.verticalSpace,
                                    AutoSizeTextWidget(
                                      text: "اضغط على الخريطة لاختيار المكان بدقة",
                                      fontSize: 10.5.sp,
                                      colorText: AppColors.fontColor2,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 5.h,
                                ),
                                decoration: BoxDecoration(
                                  color: !isMapLocationEmpty
                                      ? AppColors.successSwatch.shade50
                                      : AppColors.greySwatch.shade100,
                                  borderRadius: BorderRadius.circular(20.r),
                                  border: Border.all(
                                    color: !isMapLocationEmpty
                                        ? AppColors.successSwatch.shade300
                                        : AppColors.greySwatch.shade300,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      !isMapLocationEmpty
                                          ? Icons.check_circle_rounded
                                          : Icons.touch_app_outlined,
                                      size: 13.sp,
                                      color: !isMapLocationEmpty
                                          ? AppColors.successSwatch.shade700
                                          : AppColors.fontColor2,
                                    ),
                                    4.w.horizontalSpace,
                                    AutoSizeTextWidget(
                                      text: !isMapLocationEmpty
                                          ? S.of(context).done
                                          : "تحديد",
                                      fontSize: 10.5.sp,
                                      fontWeight: FontWeight.w600,
                                      colorText: !isMapLocationEmpty
                                          ? AppColors.successSwatch.shade700
                                          : AppColors.fontColor2,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          14.h.verticalSpace,
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12.r),
                            child: ViewLocationOnMapWidget(address: address),
                          ),
                          if (locationIsEmpty == true &&
                              isMapLocationEmpty) ...[
                            12.h.verticalSpace,
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 9.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.dangerSwatch.shade50,
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(
                                  color: AppColors.dangerSwatch.shade200,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.error_outline_rounded,
                                    size: 16.sp,
                                    color: AppColors.dangerSwatch.shade500,
                                  ),
                                  8.w.horizontalSpace,
                                  Expanded(
                                    child: AutoSizeTextWidget(
                                      text: S.of(context).pleaseLocateOnTheMap,
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w600,
                                      colorText:
                                          AppColors.dangerSwatch.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    20.h.verticalSpace,
                  ],
                ),
            ],
          ),
        ),
        bottomNavigationBar:
            citiesState.stateData == States.loaded &&
                districtsState.stateData == States.loaded
            ? ButtonBottomNavigationBarDesignWidget(
                child: CheckStateInPostApiDataWidget(
                  state: addressState,
                  functionSuccess: onSuccess,
                  bottonWidget: DefaultButtonWidget(
                    text: S.of(context).save,
                    textSize: 15.sp,
                    height: 44.h,
                    borderRadius: 12.r,
                    withIcon: true,
                    iconData: Icons.check_circle_outline_rounded,
                    iconColor: AppColors.whiteColor,
                    isLoading: addressState.stateData == States.loading,
                    background: !isMapLocationEmpty
                        ? AppColors.primaryColor
                        : AppColors.primaryColor.withValues(alpha: .6),
                    onPressed: !isMapLocationEmpty
                        ? () {
                            ref
                                .read(addressProvider(address).notifier)
                                .addOrUpdateAddress(
                                  lat: mapState.location.latitude,
                                  lng: mapState.location.longitude,
                                );
                          }
                        : null,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
