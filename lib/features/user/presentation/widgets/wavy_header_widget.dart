import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/buttons/icon_button_widget.dart';

class WavyHeaderWidget extends StatelessWidget {
  final double height;
  final bool showBackButton;
  const WavyHeaderWidget({
    super.key,
    this.height = 0.34,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Gold accent wave behind the main header
        ClipPath(
          clipper: WavyHeaderClipper(),
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * height + 5.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.secondaryColor.withValues(alpha: 0.6),
                  AppColors.secondaryColor,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
        ),
        // Main Navy Header
        ClipPath(
          clipper: WavyHeaderClipper(),
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * height,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              // Subtle background pattern or gradient
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primaryColor,
                  AppColors.primaryColor.withValues(alpha: 0.85),
                ],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Stack(
                children: [
                  Positioned(
                    right: -40.w,
                    top: 20.h,
                    child: Container(
                      width: 150.w,
                      height: 150.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.03),
                      ),
                    ),
                  ),
                  if (showBackButton)
                    Positioned(
                      top: 4.h,
                      right: 16.w,
                      child:  IconButtonWidget(
                        iconColor: Colors.white,
                        height: 26.h,
                        width: 26.w,
                      ),
                    ),
                  // Main Logo Content
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 70.w,
                          height: 70.w,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.secondaryColor.withValues(alpha: 0.3),
                                blurRadius: 15,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: CustomPaint(
                            painter: YsrLogoPainter(
                              color: AppColors.secondaryColor,
                            ),
                          ),
                        ),
                        12.h.verticalSpace,
                        Text(
                          "يـســر",
                          style: TextStyle(
                            fontSize: 42.sp,
                            fontWeight: FontWeight.w900,
                            color: AppColors.secondaryColor,
                            height: 1.0,
                          ),
                        ),
                        4.h.verticalSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Y  S  R",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 4,
                              ),
                            ),
                            10.w.horizontalSpace,
                            Row(
                              children: [
                                Container(
                                  width: 8.w,
                                  height: 8.w,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                4.w.horizontalSpace,
                                Container(
                                  width: 8.w,
                                  height: 8.w,
                                  decoration: const BoxDecoration(
                                    color: AppColors.secondaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        20.h.verticalSpace, // Space for the wave
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Custom Clipper for the wavy header
class WavyHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 40);
    // First curve
    path.quadraticBezierTo(
      size.width / 4,
      size.height,
      size.width / 2,
      size.height - 20,
    );
    // Second curve
    path.quadraticBezierTo(
      size.width * 3 / 4,
      size.height - 40,
      size.width,
      size.height,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

// Custom Painter for the YSR Basket Logo
class YsrLogoPainter extends CustomPainter {
  final Color color;

  YsrLogoPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.18
      ..strokeCap = StrokeCap.round;

    final path = Path();
    // Start top left
    path.moveTo(size.width * 0.25, size.height * 0.25);
    // Line down
    path.lineTo(size.width * 0.25, size.height * 0.55);
    // Arc to bottom right
    path.arcToPoint(
      Offset(size.width * 0.75, size.height * 0.55),
      radius: Radius.circular(size.width * 0.25),
      clockwise: false,
    );
    // Line up
    path.lineTo(size.width * 0.75, size.height * 0.25);

    canvas.drawPath(path, paint);

    // Draw the two dots inside the basket
    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Left dot
    canvas.drawCircle(
      Offset(size.width * 0.38, size.height * 0.35),
      size.width * 0.08,
      dotPaint,
    );
    // Right dot
    canvas.drawCircle(
      Offset(size.width * 0.62, size.height * 0.35),
      size.width * 0.08,
      dotPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
