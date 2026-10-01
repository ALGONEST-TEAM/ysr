import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';

class TapBarWidget extends StatelessWidget {
  final TabController controller;
  final List<String> titles;
  final double t;

  const TapBarWidget({
    super.key,
    required this.controller,
    required this.titles,
    required this.t,
  });

  @override
  Widget build(BuildContext context) {
    final double vPad = lerpDouble(4.h, 7.h, t)!;
    final double hPad = lerpDouble(16.w, 24.w, t)!;
    final double chipHeight = lerpDouble(42.h, 44.h, t)!;
    final double radius = 100.r;
    final double font = lerpDouble(10.8.sp, 11.5.sp, t)!;

    return TabBar(
      controller: controller,
      isScrollable: true,
      tabAlignment:  TabAlignment.start,
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      dividerColor: Colors.transparent,
      indicatorSize: TabBarIndicatorSize.tab,
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      labelPadding: EdgeInsets.zero,
      indicatorPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      indicator: ShapeDecoration(
        color: AppColors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
      tabs: [
        for (int i = 0; i < titles.length; i++)
          AnimatedBuilder(
            animation: controller.animation!,
            builder: (context, _) {
              final value =
                  controller.animation?.value ?? controller.index.toDouble();
              final selectness = (1.0 - (value - i).abs()).clamp(0.0, 1.0);

              final bgColor = Color.lerp(
                  Colors.white, AppColors.primaryColor, selectness)!;
              final textColor = Color.lerp(
                  AppColors.fontColor, Colors.white, selectness)!;
              final borderColor = Color.lerp(
                  Colors.grey.shade300,
                  AppColors.secondarySwatch.shade100,
                  selectness)!;
              final shadowOpacity = lerpDouble(0.0, 0.2, selectness)!;

              return Container(
                height: chipHeight,
                margin: EdgeInsets.symmetric(
                    horizontal: 4.w, vertical: lerpDouble(3.h, 5.h, t)!),
                padding:
                EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(radius),
                  border: Border.all(
                    color: borderColor,
                    width: lerpDouble(1.0, 1.5, selectness)!,
                  ),
                  boxShadow: [
                    if (selectness > 0.05)
                      BoxShadow(
                        color: AppColors.primaryColor
                            .withValues(alpha: shadowOpacity),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                  ],
                ),
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    titles[i],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: 'IBMPlexSansArabic',
                      fontWeight:
                      selectness > 0.5 ? FontWeight.w700 : FontWeight.w500,
                      fontSize: font,
                      height: 1.2,
                      color: textColor,
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}

class CollapsingTabBarHeaderWidget extends SliverPersistentHeaderDelegate {
  CollapsingTabBarHeaderWidget({
    required this.minHeight,
    required this.maxHeight,
    required this.builder,
  }) : assert(maxHeight >= minHeight);

  final double minHeight;
  final double maxHeight;

  final Widget Function(double t) builder;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final total = (maxExtent - minExtent);
    final clamped = (total - shrinkOffset).clamp(0.0, total);
    final t = total == 0 ? 0.0 : (clamped / total);

    return SizedBox.expand(
      child: Material(
        color: AppColors.scaffoldColor,
        child: builder(t),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant CollapsingTabBarHeaderWidget oldDelegate) {
    return minHeight != oldDelegate.minHeight ||
        maxHeight != oldDelegate.maxHeight ||
        builder != oldDelegate.builder;
  }
}
