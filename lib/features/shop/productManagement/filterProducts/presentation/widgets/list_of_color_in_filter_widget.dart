import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/state/state.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../detailsProducts/data/model/color_data.dart';
import '../../../detailsProducts/presentation/widget/list_of_colors_product_widget.dart';
import '../state_mangment/riverpod.dart';

class ListOfColorInFilterWidget extends ConsumerWidget {
  const ListOfColorInFilterWidget(
      {super.key,
      required this.colorFilter,
      required this.idCategory,
      required this.nameSearch,
      required this.isSearchFilter});

  final List<ColorOfProductData> colorFilter;
  final int idCategory;
  final String nameSearch;
  final bool isSearchFilter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedColors = ref.watch(selectedColorsProvider(idCategory));
    final stateFilter = ref.watch(filterProductProvider(idCategory));
    return Wrap(
      spacing: 10.w,
      runSpacing: 10.h,
      children: colorFilter.map((item) {
        final isSelected = selectedColors.contains(item.idColor);

        return Material(
          color: Colors.transparent,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () {
              if (stateFilter.stateData != States.loading) {
                ref
                    .read(selectedColorsProvider(idCategory).notifier)
                    .toggleColor(item.idColor!);
                ref.read(filterProductProvider(idCategory).notifier).getProductOfFilter(
                    idSize: ref.read(selectedSizesProvider(idCategory)),
                    idColor: ref.read(selectedColorsProvider(idCategory)),
                    idSubCategory: ref.read(selectedCategoryProvider(idCategory)),
                  sortOption: ref.read(selectProductsSortOptionProvider(idCategory)),
                    nameSearch: isSearchFilter ? nameSearch : '',
                );
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutBack,
              height: 34.w,
              width: 34.w,
              padding: EdgeInsets.all(isSelected ? 2.w : 0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primaryColor : Colors.transparent,
                  width: 1.4.w,
                ),
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: hexToColor(item.colorHex!),
                  border: isSelected 
                    ? null 
                    : Border.all(color: const Color(0xFFE5E7EB), width: 1.w),
                  boxShadow: [
                    if (!isSelected)
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                      )
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
