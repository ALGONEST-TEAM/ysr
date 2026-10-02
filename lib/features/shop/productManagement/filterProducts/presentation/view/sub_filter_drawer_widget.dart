import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/widgets/auto_size_text_widget.dart';
import '../../../../../../generated/l10n.dart';
import '../../../../category/data/model/category_data.dart';
import '../../../detailsProducts/data/model/color_data.dart';
import '../../../detailsProducts/data/model/size_data.dart';
import '../state_mangment/riverpod.dart';
import '../widgets/list_of_color_in_filter_widget.dart';
import '../widgets/list_of_filter_category_widget.dart';
import '../widgets/list_of_size_in_filter_widget.dart';
import '../widgets/card_of_sub_filter_drawer_widget.dart';
import '../widgets/clear_button_and_done.dart';

class SubFilterDrawerWidget extends ConsumerStatefulWidget {
  const SubFilterDrawerWidget({
    super.key,
    required this.colorFilterList,
    required this.sizeFilterList,
    required this.categoryFilterList,
    required this.nameSearch,
    required this.isSearchFilter,
    required this.idCategory,
  });

  final List<SizeData> sizeFilterList;
  final List<ColorOfProductData> colorFilterList;
  final List<CategoryData> categoryFilterList;
  final String nameSearch;
  final int idCategory;
  final bool isSearchFilter;

  @override
  ConsumerState<SubFilterDrawerWidget> createState() =>
      _SubFilterDrawerWidgetState();
}

class _SubFilterDrawerWidgetState extends ConsumerState<SubFilterDrawerWidget> {
  @override
  Widget build(BuildContext context) {
    final selectedSizes = ref.watch(selectedSizesProvider(widget.idCategory));
    final selectedColors = ref.watch(selectedColorsProvider(widget.idCategory));
    final selectedCategory =
        ref.watch(selectedCategoryProvider(widget.idCategory));
    return SafeArea(
      top: false,
      child: Drawer(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 40.h, bottom: 16.h, left: 16.w, right: 16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    offset: const Offset(0, 2),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AutoSizeTextWidget(
                    text: S.of(context).filter,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    colorText: AppColors.primaryColor,
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(50.r),
                    child: Container(
                      padding: EdgeInsets.all(6.r),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF3F4F6),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        size: 16.sp,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CardOfSubFilterDrawerWidget(
                      isOpenToRead: selectedColors.isNotEmpty,
                      title: S.of(context).color,
                      child: ListOfColorInFilterWidget(
                        colorFilter: widget.colorFilterList,
                        idCategory: widget.idCategory,
                        nameSearch: widget.nameSearch,
                        isSearchFilter: widget.isSearchFilter,
                      ),
                    ),
                    CardOfSubFilterDrawerWidget(
                      isOpenToRead: selectedSizes.isNotEmpty,
                      title: S.of(context).size2,
                      child: ListOfSizeInFilterWidget(
                        size: widget.sizeFilterList,
                        idCategory: widget.idCategory,
                        nameSearch: widget.nameSearch,
                        isSearchFilter: widget.isSearchFilter,
                      ),
                    ),
                    CardOfSubFilterDrawerWidget(
                      isOpenToRead: selectedCategory != null,
                      title: S.of(context).categories,
                      child: ListOfFilterCategoryWidget(
                        categoryFilter: widget.categoryFilterList,
                        idCategory: widget.idCategory,
                        nameSearch: widget.nameSearch,
                        isSearchFilter: widget.isSearchFilter,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    offset: const Offset(0, -4),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: ClearButtonAndDone(
                idCategory: widget.idCategory,
                height: 42.h,
                doneOnTap: () {
                  Navigator.pop(context);
                },
                clearOnTap: () {
                  clearProductFilters(
                    context: context,
                    ref: ref,
                    categoryId: widget.idCategory,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
