import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/state/state.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/widgets/auto_size_text_widget.dart';
import '../../../detailsProducts/data/model/size_data.dart';
import '../state_mangment/riverpod.dart';

class ListOfSizeInFilterWidget extends ConsumerWidget {
  const ListOfSizeInFilterWidget({
    super.key,
    required this.isSearchFilter,
    required this.size,
    required this.idCategory,
    required this.nameSearch,
  });

  final bool isSearchFilter;
  final String nameSearch;
  final List<SizeData> size;
  final int idCategory;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSizes = ref.watch(selectedSizesProvider(idCategory));
    final stateFilter = ref.watch(filterProductProvider(idCategory));

    return Wrap(
      spacing: 12.w,
      runSpacing: 12.h,
      children: size.map((item) {
        final isSelected = selectedSizes.contains(item.id);
        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12.r),
            onTap: () {
              if (stateFilter.stateData != States.loading) {
                ref
                    .read(selectedSizesProvider(idCategory).notifier)
                    .toggleSize(item.id!);
                ref.read(filterProductProvider(idCategory).notifier).getProductOfFilter(
                      idSize: ref.read(selectedSizesProvider(idCategory)),
                      idColor: ref.read(selectedColorsProvider(idCategory)),
                      idSubCategory:
                          ref.read(selectedCategoryProvider(idCategory)),
                  sortOption: ref.read(selectProductsSortOptionProvider(idCategory)),
                      nameSearch: isSearchFilter ? nameSearch : '',
                    );
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isSelected ? AppColors.primaryColor : const Color(0xFFE5E7EB),
                  width: 1.w,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primaryColor.withValues(alpha: 0.25),
                          offset: const Offset(0, 4),
                          blurRadius: 10,
                        )
                      ]
                    : [],
              ),
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF4B5563),
                  fontSize: 12.sp,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontFamily: 'Tajawal', // Assuming this is your app's font
                ),
                child: Text(
                  item.sizeTypeName ?? '',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
