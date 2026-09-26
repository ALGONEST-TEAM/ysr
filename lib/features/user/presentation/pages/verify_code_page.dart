import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../../../../core/helpers/navigateTo.dart';
import '../../../../core/state/check_state_in_post_api_data_widget.dart';
import '../../../../core/state/state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/auto_size_text_widget.dart';
import '../../../../core/widgets/bottomNavbar/bottom_navigation_bar_widget.dart';
import '../../../../core/widgets/buttons/default_button.dart';
import '../../../../generated/l10n.dart';
import '../../../../services/auth/auth.dart';
import '../../../notifications/presentation/state_mangment/notifications_riverpod.dart';
import '../../../shop/shoppingBag/cart/presentation/riverpod/cart_riverpod.dart';
import '../riverpod/user_riverpod.dart';
import '../widgets/resend_code_widget.dart';
import '../widgets/verify_pinput_widget.dart';
import '../widgets/wavy_header_widget.dart';
import 'sign_up_page.dart';

class VerifyCodePage extends ConsumerStatefulWidget {
  final String phoneNumber;

  const VerifyCodePage({super.key, required this.phoneNumber});

  @override
  ConsumerState<VerifyCodePage> createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends ConsumerState<VerifyCodePage>
    with CodeAutoFill {
  static const _otpLen = 6;

  final TextEditingController _verifyController = TextEditingController();

  bool _canAutoSubmit = true;

  @override
  void initState() {
    super.initState();
    listenForCode();

    _verifyController.addListener(_maybeAutoSubmit);
  }

  @override
  void codeUpdated() {
    final c = code ?? '';
    if (c.isNotEmpty) {
      _verifyController.text = c;
    }
  }

  void _maybeAutoSubmit() async {
    final text = _verifyController.text.trim();
    if (text.length < _otpLen) {
      _canAutoSubmit = true;
      return;
    }
    if (_canAutoSubmit && text.length == _otpLen) {
      _canAutoSubmit = false;
      FocusManager.instance.primaryFocus?.unfocus();
      ref
          .read(checkOTPProvider.notifier)
          .checkOTP(
            phoneNumber: widget.phoneNumber,
            otp: text,
            fcmToken: await Auth().getFcmToken(),
          );
    }
  }

  @override
  void dispose() {
    cancel();
    _verifyController.removeListener(_maybeAutoSubmit);
    _verifyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final checkOTPState = ref.watch(checkOTPProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          WavyHeaderWidget(
            height: 0.32,
            showBackButton: true,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  6.h.verticalSpace,

                  AutoSizeTextWidget(
                    text: S.of(context).verificationCode, // Login text
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w800,
                    colorText: AppColors.primaryColor,
                  ),

                  6.h.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AutoSizeTextWidget(
                        text:
                            "${S.of(context).codeHasBeenSendTo} ${widget.phoneNumber}",

                        fontSize: 14.sp,
                        colorText: AppColors.fontColor2,
                        fontWeight: FontWeight.w500,
                      ),

                      6.w.horizontalSpace,
                      InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        child: Text(
                          "تعديل",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  24.h.verticalSpace,
                  VerifyPinputWidget(verifyController: _verifyController),
                  24.h.verticalSpace,
                  ResendCodeWidget(phoneNumberOrEmail: widget.phoneNumber),

                  24.h.verticalSpace,
                  CheckStateInPostApiDataWidget(
                    state: checkOTPState,
                    hasMessageSuccess: checkOTPState.data.status == true,
                    messageSuccess: S.of(context).loginSuccessful,
                    functionSuccess: () async {
                      if (checkOTPState.data.status == true) {
                        Auth().login(checkOTPState.data);
                        navigateAndFinish(
                          context,
                          const BottomNavigationBarWidget(),
                        );
                        ref.read(unreadCountProvider.notifier).refresh();
                        ref.read(getCartCountProvider.notifier).refresh();
                      } else {
                        Navigator.of(context).pop();
                        navigateTo(context, const SignUpPage());
                      }
                    },
                    bottonWidget: DefaultButtonWidget(
                      text: S.of(context).confirm,
                      textSize: 14.8.sp,
                      isLoading: checkOTPState.stateData == States.loading,
                      gradientColors: [
                        AppColors.primaryColor,
                        const Color(0xFF384399),
                      ],
                      borderRadius: 16.r,
                      onPressed: () async {
                        final code = _verifyController.text.trim();
                        if (code.length != _otpLen) return;
                        FocusManager.instance.primaryFocus?.unfocus();
                        ref
                            .read(checkOTPProvider.notifier)
                            .checkOTP(
                              phoneNumber: widget.phoneNumber,
                              otp: code,
                              fcmToken: await Auth().getFcmToken(),
                            );
                      },
                    ),
                  ),
                  // 24.h.verticalSpace,
                  24.h.verticalSpace,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
