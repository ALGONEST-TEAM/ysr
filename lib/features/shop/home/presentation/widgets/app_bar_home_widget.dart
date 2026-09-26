import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../core/constants/app_icons.dart';
import '../../../../../core/helpers/navigateTo.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/auto_size_text_widget.dart';
import '../../../../../core/widgets/buttons/icon_button_widget.dart';
import '../../../../../core/widgets/cart_badge_icon_widget.dart';
import '../../../../../services/auth/auth.dart';
import '../../../../notifications/presentation/pages/notifications_page.dart';
import '../../../../notifications/presentation/state_mangment/notifications_riverpod.dart';
import '../../../../user/presentation/pages/log_in_page.dart';
import '../../../productManagement/search_product/presntation/page/search_page.dart';
import '../../../productManagement/wishlist/presentation/pages/wishlist_page.dart';
import '../../../productManagement/wishlist/presentation/riverpod/wishlist_riverpod.dart';

AppBar appBarHomeWidget({required BuildContext context}) {
  return AppBar(
    elevation: 0,
    titleSpacing: 4.w,
    backgroundColor: AppColors.scaffoldColor,
    centerTitle: false,
    automaticallyImplyLeading: false,
    title: Row(
      children: [
        10.horizontalSpace,
        Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: AutoSizeTextWidget(
            text: 'يسر',
            colorText: AppColors.primaryColor,
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Flexible(
          child: GestureDetector(
            onTap: () {
              navigateTo(context, SearchPage(hintTextSearch: ""));
            },
            child: CustomPaint(
              painter: _SearchFieldArcPainter(
                primaryColor: AppColors.primaryColor,
                secondaryColor: AppColors.secondaryColor,
                dotColor1: AppColors.primarySwatch.shade300,
                dotColor2: AppColors.secondarySwatch.shade300,
                arcDepth: 10.w,
                borderRadius: 22.r,
              ),
              child: Container(
                height: 36.h,
                padding: EdgeInsets.only(right: 22.w, left: 12.w),
                alignment: Alignment.center,
                child: Row(
                  children: [
                    SvgPicture.asset(
                      AppIcons.search,
                      height: 16.h,
                      colorFilter: const ColorFilter.mode(
                        AppColors.fontColor3,
                        BlendMode.srcIn,
                      ),
                    ),
                    8.w.horizontalSpace,
                    AutoSizeTextWidget(
                      text: 'عمّ تبحث اليوم؟',
                      colorText: AppColors.fontColor3,
                      fontSize: 12.sp,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ),
    actions: [
      // 12.w.horizontalSpace,
      // const CartBadgeIconWidget(),
      Consumer(
        builder: (context, ref, child) {
          return IconButtonWidget(
            icon: AppIcons.wishlist,
            height: 18.h,
            onPressed: () {
              if (!Auth().loggedIn) {
                navigateTo(context, const LogInPage());
              } else {
                ref.invalidate(getAllWishesProductsProvider);
                ref.invalidate(getAllListProvider);
                navigateTo(context, const WishlistPage());
              }
            },
          );
        },
      ),
      Consumer(
        builder: (context, ref, _) {
          final unread = ref.watch(unreadCountProvider);
          return Stack(
            clipBehavior: Clip.none,
            children: [
              IconButtonWidget(
                icon: AppIcons.notification,
                height: 20.h,
                onPressed: () async {
                  if (!Auth().loggedIn) {
                    navigateTo(context, const LogInPage());
                  } else {
                    navigateTo(context, const NotificationsPage());
                    ref.read(unreadCountProvider.notifier).refresh();
                  }
                },
              ),
              if (unread > 0)
                Positioned(
                  top: 1,
                  left: unread >= 10 ? 4.w : 6.w,
                  child: Container(
                    padding: EdgeInsets.all(unread >= 10 ? 1.6.sp : 2.sp),
                    decoration: BoxDecoration(
                      color: AppColors.dangerColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white),
                    ),
                    child: AutoSizeTextWidget(
                      text: unread > 99 ? '99+' : ' $unread ',
                      colorText: Colors.white,
                      fontSize: 7.2.sp,
                      minFontSize: 6,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    ],
  );
}

class _SearchFieldArcPainter extends CustomPainter {
  final Color primaryColor;
  final Color secondaryColor;
  final Color dotColor1;
  final Color dotColor2;
  final double arcDepth;
  final double borderRadius;

  const _SearchFieldArcPainter({
    required this.primaryColor,
    required this.secondaryColor,
    required this.dotColor1,
    required this.dotColor2,
    this.arcDepth = 6.5,
    this.borderRadius = 12.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final r = borderRadius;
    final d = arcDepth;

    // المسار الرئيسي مع اقتصاصة مقوسة بانسيابية تامة (مثل القوس)
    final path = Path();
    path.moveTo(r, 0);
    path.lineTo(w - 4, 0);
    // بداية انسيابية من الأعلى نحو القوس
    path.quadraticBezierTo(w, 0, w - 0.5, 3.5);
    // قوس انسيابي متصل ومقوس للداخل (بدون أي زوايا حادة)
    path.cubicTo(
      w - d * 1.35,
      h * 0.25,
      w - d * 1.35,
      h * 0.75,
      w - 0.5,
      h - 3.5,
    );
    // خروج انسيابي من القوس نحو الحافة السفلية
    path.quadraticBezierTo(w, h, w - 4, h);
    path.lineTo(r, h);
    path.quadraticBezierTo(0, h, 0, h - r);
    path.lineTo(0, r);
    path.quadraticBezierTo(0, 0, r, 0);
    path.close();

    // 1. ظل ناعم وخفيف للشكل
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.035)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawPath(path.shift(const Offset(0, 2)), shadowPaint);

    // 2. تعبئة بيضاء نقية
    final fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    // 3. إطار رمادي فائق النعومة
    final borderPaint = Paint()
      ..color = const Color(0xFFEFF0F3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    canvas.drawPath(path, borderPaint);

    // 4. مسار القوس الانسيابي الملون
    final arcPath = Path()
      ..moveTo(w - 0.5, 4.0)
      ..cubicTo(
        w - d * 1.35,
        h * 0.25,
        w - d * 1.35,
        h * 0.75,
        w - 0.5,
        h - 4.0,
      );

    final arcRect = Rect.fromLTWH(w - d * 1.5, 0, d * 1.5 + 4, h);

    // تداخل لوني ناعم وخفيف بين primaryColor و secondaryColor
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        primaryColor.withValues(alpha: 0.35),
        secondaryColor.withValues(alpha: 0.40),
      ],
    );

    // وهج ناعم وخفيف جداً
    final glowPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          primaryColor.withValues(alpha: 0.12),
          secondaryColor.withValues(alpha: 0.16),
        ],
      ).createShader(arcRect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5);
    canvas.drawPath(arcPath, glowPaint);

    // خط القوس المقوس بدرجات ألوان هادئة وخفيفة
    final strokePaint = Paint()
      ..shader = gradient.createShader(arcRect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(arcPath, strokePaint);

    // 5. النقطتان المتداخلتان مع القوس (لتشكيل تصميم الـ "ي")
    final double dotRadius = 3; // تكبير النقطتين قليلاً
    final double dotX =
        w - d - 4.5; // إزاحة لليسار بحيث تلامس بداية الدائرة القوس
    final double dotY1 = h / 2 - 3.2;
    final double dotY2 = h / 2 + 3.2;

    final dotPaint1 = Paint()
      ..color = dotColor1
      ..style = PaintingStyle.fill;

    final dotPaint2 = Paint()
      ..color = dotColor2
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(dotX, dotY1), dotRadius, dotPaint1);
    canvas.drawCircle(Offset(dotX, dotY2), dotRadius, dotPaint2);
  }

  @override
  bool shouldRepaint(covariant _SearchFieldArcPainter oldDelegate) {
    return oldDelegate.primaryColor != primaryColor ||
        oldDelegate.secondaryColor != secondaryColor ||
        oldDelegate.dotColor1 != dotColor1 ||
        oldDelegate.dotColor2 != dotColor2 ||
        oldDelegate.arcDepth != arcDepth ||
        oldDelegate.borderRadius != borderRadius;
  }
}
