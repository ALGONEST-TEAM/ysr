import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import '../../../../core/theme/app_colors.dart';

class VerifyPinputWidget extends StatefulWidget {
  final TextEditingController verifyController;

  const VerifyPinputWidget({
    super.key,
    required this.verifyController,
  });

  @override
  State<VerifyPinputWidget> createState() => _VerifyPinputWidgetState();
}

class _VerifyPinputWidgetState extends State<VerifyPinputWidget>
    with WidgetsBindingObserver {
  // late final FocusNode _focus;
  // bool _wasFocused = false;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addObserver(this);
  //   _focus = FocusNode();
  //   _focus.addListener(() => _wasFocused = _focus.hasFocus);
  // }
  //
  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.resumed && _wasFocused && mounted) {
  //     Future.microtask(() {
  //       if (!mounted) return;
  //       FocusScope.of(context).requestFocus(_focus);
  //       SystemChannels.textInput.invokeMethod('TextInput.show');
  //     });
  //   }
  // }
  //
  // @override
  // void dispose() {
  //   WidgetsBinding.instance.removeObserver(this);
  //   _focus.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Pinput(
      controller: widget.verifyController,
      // focusNode: _focus,
      autofocus: false,
      length: 6,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      autofillHints: const [AutofillHints.oneTimeCode],
      defaultPinTheme: PinTheme(
        width: 50.w,
        height: 55.h,
        textStyle: TextStyle(
          fontSize: 20.sp,
          color: AppColors.primaryColor,
          fontWeight: FontWeight.w700,
        ),
        decoration: BoxDecoration(
          color: AppColors.scaffoldColor,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: AppColors.primarySwatch.shade100),
        ),
      ),
      focusedPinTheme: PinTheme(
        width: 50.w,
        height: 55.h,
        textStyle: TextStyle(
          fontSize: 20.sp,
          color: AppColors.primaryColor,
          fontWeight: FontWeight.w700,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.secondaryColor, width: 1.5),
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.secondaryColor.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            )
          ],
        ),
      ),
      submittedPinTheme: PinTheme(
        width: 50.w,
        height: 55.h,
        textStyle: TextStyle(
          fontSize: 20.sp,
          color: AppColors.primaryColor,
          fontWeight: FontWeight.w700,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFEEEEEE)),
          borderRadius: BorderRadius.circular(14.r),
        ),
      ),
    );
  }
}
