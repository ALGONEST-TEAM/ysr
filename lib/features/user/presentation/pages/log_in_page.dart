import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/state/check_state_in_post_api_data_widget.dart';
import '../../../../core/state/state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/auto_size_text_widget.dart';
import '../../../../core/helpers/navigateTo.dart';
import '../../../../core/widgets/text_form_field.dart';
import '../../../../generated/l10n.dart';
import '../riverpod/user_riverpod.dart';
import '../widgets/otp_delivery_method_widget.dart';
import '../widgets/wavy_header_widget.dart';
import 'verify_code_page.dart';

class LogInPage extends ConsumerStatefulWidget {
  const LogInPage({super.key});

  @override
  ConsumerState<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends ConsumerState<LogInPage> {
  TextEditingController phoneNumberController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  // ignore: unused_field
  DeliveryMethod _selectedMethod = DeliveryMethod.sms;

  @override
  Widget build(BuildContext context) {
    var state = ref.watch(userProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xFFF5F7FA),
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Color(0xFFF5F7FA),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        // Light background for the body
        body: SingleChildScrollView(
          child: Column(
            children: [
              // 1. Wavy Header (Inspired by Talka)
              const WavyHeaderWidget(),

              // 2. Form Body (Inspired by Talabya)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      8.verticalSpace,
                      Center(
                        child: AutoSizeTextWidget(
                          text: "تسجيل الدخول", // Login text
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w900,
                          colorText: AppColors.primaryColor,
                        ),
                      ),
                      8.h.verticalSpace,

                      Center(
                        child: AutoSizeTextWidget(
                          text: "قم بتسجيل الدخول لاستخدام متجر يسر",
                          fontSize: 14.sp,
                          colorText: AppColors.fontColor2,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      20.h.verticalSpace,

                      AutoSizeTextWidget(
                        text: S.of(context).phoneNumber,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        colorText: AppColors.primarySwatch.shade400,
                      ),
                      6.verticalSpace,
                      TextFormFieldWidget(
                        controller: phoneNumberController,
                        type: TextInputType.phone,
                        hintText: "أدخل رقم الهاتف",
                        maxLength: 9,
                        borderRadius: 16.r,
                        fillColor: Colors.white,
                        // Clean white input on light grey background
                        borderSide: BorderSide(
                          color: Colors.grey.withValues(alpha: 0.2),
                          width: 1,
                        ),
                        fieldValidator: (value) {
                          if (value == null || value.toString().isEmpty) {
                            return S.of(context).pleaseEnterPhoneNumber;
                          }
                          final phone = value.trim();
                          if (!phone.startsWith('7')) {
                            return S.of(context).phoneMustStartWith7;
                          }
                          if (phone.length < 9) {
                            return S.of(context).phoneMustBe9Digits;
                          }
                          return null;
                        },
                        prefix: Padding(
                          padding: EdgeInsets.all(16.sp),
                          child: SvgPicture.asset(
                            AppIcons.phone,
                            height: 18.h,
                            colorFilter: const ColorFilter.mode(
                              AppColors.primaryColor,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        suffixIcon: Padding(
                          padding: EdgeInsets.only(
                            left: 16.w,
                            right: 16.w,
                            top: 14.h,
                            bottom: 10.h,
                          ),
                          child: AutoSizeTextWidget(
                            text: "+967",
                            colorText: AppColors.primaryColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      6.h.verticalSpace,

                      OtpDeliveryMethodWidget(
                        onMethodChanged: (method) {
                          _selectedMethod = method;
                        },
                      ),

                      28.h.verticalSpace,

                      // DefaultButtonWidget(text: S.of(context).logIn,
                      // isLoading: state.stateData == States.loading,
                      //
                      // ),

                      // 3. Gradient Button with Icon (Inspired by Talabya)
                      CheckStateInPostApiDataWidget(
                        state: state,
                        hasMessageSuccess: false,
                        functionSuccess: () {
                          navigateTo(
                            context,
                            VerifyCodePage(
                              phoneNumber: phoneNumberController.text,
                            ),
                          );
                        },
                        bottonWidget: InkWell(
                          onTap: () {

                            final isValid = formKey.currentState!.validate();
                            if (isValid) {
                              FocusManager.instance.primaryFocus?.unfocus();
                              ref
                                  .read(userProvider.notifier)
                                  .logIn(
                                    phoneNumber: phoneNumberController.text,
                                  );
                            }
                          },
                          borderRadius: BorderRadius.circular(16.r),
                          child: Container(
                            width: double.infinity,
                            height: 50.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primaryColor,
                                  const Color(0xFF384399),
                                  // Slightly lighter navy
                                ],
                                begin: Alignment.centerRight,
                                end: Alignment.centerLeft,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryColor.withValues(
                                    alpha: 0.3,
                                  ),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: state.stateData == States.loading
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    spacing: 10,
                                    children: [
                                      AutoSizeTextWidget(
                                        text: S.of(context).logIn,
                                        fontSize: 14.sp,
                                        colorText: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      Icon(
                                        Icons.login_rounded,
                                        color: AppColors.secondaryColor,
                                        size: 24,
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),

                      12.h.verticalSpace,

                      // 4. Continue as Guest (Inspired by Talka)
                      Align(
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          borderRadius: BorderRadius.circular(8.r),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 8.h,
                            ),
                            child: AutoSizeTextWidget(
                              text: "المتابعة بدون تسجيل",
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                              colorText: AppColors.fontColor2,
                            ),
                          ),
                        ),
                      ),
                      40.h.verticalSpace,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

