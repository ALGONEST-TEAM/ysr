import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/state/state.dart';
import '../../../../../../core/widgets/buttons/default_button.dart';
import '../../../../../../generated/l10n.dart';
import '../state_mangment/riverpod.dart';

class ClearButtonAndDone extends ConsumerWidget {
  final int idCategory;
  final VoidCallback doneOnTap;
  final VoidCallback clearOnTap;
  final double? height;

  const ClearButtonAndDone({
    super.key,
    required this.idCategory,
    required this.doneOnTap,
    required this.clearOnTap,
    this.height,
  });

  @override
  Widget build(BuildContext context, ref) {
    final stateFilter = ref.watch(filterProductProvider(idCategory));

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          Expanded(
            child: DefaultButtonWidget(
              text: S.of(context).done,
              height: height ?? 34.h,
              textSize: 14.sp,
              onPressed: doneOnTap,
              isLoading: stateFilter.stateData == States.loading,
            ),
          ),
          12.w.horizontalSpace,
          Expanded(
            child: DefaultButtonWidget(
              text: S.of(context).clear,
              height: height ?? 34.h,
              textSize: 14.sp,
              background: Colors.white,
              textColor: const Color(0xFF4B5563),
              border: Border.all(color: const Color(0xFFE5E7EB), width: 1.w),
              onPressed: clearOnTap,
            ),
          ),
        ],
      ),
    );
  }
}
