import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';

class CheckBoxForCartProductsWidget extends StatelessWidget {
  final bool value;
  final ValueChanged onChanged;
  final Color color;

  const CheckBoxForCartProductsWidget({
    super.key,
    required this.value,
    required this.onChanged,
    this.color = AppColors.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: value,
      onChanged: onChanged,
      activeColor: color,
      checkColor: Colors.white,
      shape: const CircleBorder(),
      side: MaterialStateBorderSide.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return  BorderSide(color: color, width: 1.5);
        }
        return BorderSide(
          color: AppColors.fontColor2.withValues(alpha: 0.6),
          width: 1.2,
        );
      }),
      visualDensity: const VisualDensity(horizontal: -4),
      fillColor: MaterialStateProperty.resolveWith<Color>((
        Set<MaterialState> states,
      ) {
        if (states.contains(MaterialState.selected)) {
          return color;
        }
        return Colors.white;
      }),
    );
  }
}
