import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/state/check_state_in_get_api_data_widget.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/auto_size_text_widget.dart';
import '../../data/model/vendor_model.dart';
import '../riverpod/home_riverpod.dart';
import '../widgets/app_bar_home_widget.dart';
import '../widgets/app_bar_vendor_widget.dart';
import '../widgets/loading_home_widget.dart';
import '../widgets/sections_widget.dart';
import '../widgets/tap_bar_widget.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extended;

class HomePage extends ConsumerStatefulWidget {
  final VendorModel? vendorData;

  const HomePage({super.key, this.vendorData});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with TickerProviderStateMixin {
  TabController? _tab;
  final PageStorageBucket _pageStorageBucket = PageStorageBucket();

  @override
  void dispose() {
    _tab?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var state = ref.watch(sectionProvider);

    return Scaffold(
      appBar: widget.vendorData != null
          ? AppBarVendorWidget(vendorData: widget.vendorData!)
          : appBarHomeWidget(context: context),
      body: CheckStateInGetApiDataWidget(
        state: state,
        refresh: () {
          ref.invalidate(sectionProvider);
        },
        widgetOfLoading: const LoadingHomeWidget(subSection: false),
        widgetOfData: Builder(
          builder: (context) {
            var sections = state.data.section ?? [];

            // Filter sections by vendorId if in vendor mode
            if (widget.vendorData?.id != null) {
              sections = sections.where((s) {
                final sVendorId = (s.vendorId != null && s.vendorId! > 0)
                    ? s.vendorId!
                    : VendorModel.mockVendors[(s.id ?? 0) %
                              VendorModel.mockVendors.length]['id']
                          as int;
                return sVendorId == widget.vendorData!.id;
              }).toList();
            }

            if (sections.isEmpty) {
              _tab?.dispose();
              _tab = null;
              return Center(
                child: AutoSizeTextWidget(
                  text: 'لا توجد منتجات أو أقسام متاحة لهذا المتجر حالياً.',
                  colorText: AppColors.fontColor,
                  fontSize: 14.sp,
                ),
              );
            }

            if (_tab == null || _tab!.length != sections.length) {
              final savedIndex = ref.read(homeTabIndexProvider);
              final safeIndex = savedIndex.clamp(0, sections.length - 1);

              _tab?.dispose();
              _tab = TabController(
                length: sections.length,
                vsync: this,
                initialIndex: safeIndex,
              );

              _tab!.addListener(() {
                if (!_tab!.indexIsChanging) {
                  ref.read(homeTabIndexProvider.notifier).state = _tab!.index;
                }
              });
            }
            return PageStorage(
              bucket: _pageStorageBucket,
              child: extended.ExtendedNestedScrollView(
                onlyOneScrollInBody: true,
                floatHeaderSlivers: false,
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverPersistentHeader(
                      pinned: true,
                      floating: false,
                      delegate: CollapsingTabBarHeaderWidget(
                        minHeight: 56.h,
                        maxHeight: 60.h,
                        builder: (t) => TapBarWidget(
                          controller: _tab!,
                          titles: sections.map((s) => s.name ?? '').toList(),
                          t: t,
                        ),
                      ),
                    ),
                  ];
                },
                body: TabBarView(
                  controller: _tab,
                  children: sections.map((section) {
                    return extended.ExtendedVisibilityDetector(
                      uniqueKey: Key('tab_${section.id}'),
                      child: SectionOfCategoryInHomePage(
                        idSection: section.id!,
                        offers: state.data.offers ?? [],
                        vendorId: widget.vendorData?.id, // Pass vendorId down
                        key: PageStorageKey('tab_${section.id}'),
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
