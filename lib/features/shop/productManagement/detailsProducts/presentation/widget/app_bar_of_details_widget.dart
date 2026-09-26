import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/constants/app_icons.dart';
import '../../../../../../core/widgets/buttons/icon_button_widget.dart';
import '../../../../../../core/widgets/cart_badge_icon_widget.dart';

class AppBarOfDetailsWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final String nameForShare;
  final String descriptionForShare;
  final String imageForShare;
  final String price;
  final int idProductForShare;
  final bool hideShareButton;
  final VoidCallback? onSharePressed;

  const AppBarOfDetailsWidget({
    super.key,
    required this.descriptionForShare,
    required this.idProductForShare,
    required this.imageForShare,
    required this.nameForShare,
    required this.price,
    this.hideShareButton = true,
    this.onSharePressed,
  });

  @override
  Size get preferredSize => Size.fromHeight(44.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      leading: Container(
        margin: EdgeInsets.symmetric(horizontal: 12.w).copyWith(top: 2.6),
          decoration: BoxDecoration(
            color: Colors.white70,
            shape: BoxShape.circle
          ),
          child: const IconButtonWidget()),
      leadingWidth: 67.w,
      centerTitle: true,
      automaticallyImplyLeading: false,
      toolbarHeight: 44.h,
      actions: [
        8.horizontalSpace,
        if (!hideShareButton)
          Container(
            decoration: BoxDecoration(
                color: Colors.white70,
                shape: BoxShape.circle
            ),
            child: IconButtonWidget(
              icon: AppIcons.sharing,
              height: 20.h,
              onPressed: onSharePressed,
            ),
          ),
        8.horizontalSpace,

        Container(
            decoration: BoxDecoration(
                color: Colors.white70,
                shape: BoxShape.circle
            ),
            child: const CartBadgeIconWidget()),
        12.horizontalSpace,

      ],
    );
  }
}
