import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/state/check_state_in_get_api_data_widget.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/auto_size_text_widget.dart';
import '../../data/data_source/remote_data_source.dart';
import '../riverpod/home_riverpod.dart';
import '../widgets/app_bar_home_widget.dart';
import '../widgets/loading_home_widget.dart';
import '../widgets/sections_widget.dart';
import '../widgets/tap_bar_widget.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
as extended;

class HomePage extends ConsumerStatefulWidget {
  final int? vendorId;
  final String? vendorName;
  final String? vendorCity;

  const HomePage({
    super.key,
    this.vendorId,
    this.vendorName,
    this.vendorCity,
  });

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
      appBar: widget.vendorId != null
          ? appBarVendorWidget(
              context: context,
              vendorName: widget.vendorName ?? 'متجر المورد',
              vendorCity: widget.vendorCity,
            )
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
              if (widget.vendorId != null) {
                sections = sections.where((s) {
                  final sVendorId = (s.vendorId != null && s.vendorId! > 0)
                      ? s.vendorId!
                      : SectionsRemoteDataSource.vendors[(s.id ?? 0) % SectionsRemoteDataSource.vendors.length]['id'] as int;
                  return sVendorId == widget.vendorId;
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
                      if (widget.vendorId != null)
                        SliverToBoxAdapter(
                          child: _VendorStoreHeader(vendorId: widget.vendorId!),
                        ),
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
                          vendorId: widget.vendorId, // Pass vendorId down
                          key: PageStorageKey('tab_${section.id}'),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          )),
    );
  }
}

class _VendorStoreHeader extends StatelessWidget {
  final int vendorId;
  const _VendorStoreHeader({required this.vendorId});

  @override
  Widget build(BuildContext context) {
    final vendorData = SectionsRemoteDataSource.vendors.firstWhere(
      (v) => v['id'] == vendorId, 
      orElse: () => SectionsRemoteDataSource.vendors.first,
    );
    
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: const Color(0xFF1DA1F2).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: const Color(0xFF1DA1F2).withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Icon(Icons.verified_rounded, color: const Color(0xFF1DA1F2), size: 14.sp),
                4.horizontalSpace,
                AutoSizeTextWidget(
                  text: 'بائع معتمد',
                  colorText: const Color(0xFF1DA1F2),
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
          12.horizontalSpace,
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: const Color(0xFFFFB800).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: const Color(0xFFFFB800).withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Icon(Icons.star_rounded, color: const Color(0xFFFFB800), size: 14.sp),
                4.horizontalSpace,
                AutoSizeTextWidget(
                  text: '${vendorData['rating']}',
                  colorText: const Color(0xFF162238),
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                ),
                4.horizontalSpace,
                AutoSizeTextWidget(
                  text: '(${vendorData['reviews_count']})',
                  colorText: AppColors.fontColor3,
                  fontSize: 10.sp,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
