import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/network/errors/remote_exception.dart';
import '../../../../../core/state/data_state.dart';
import '../../../../../core/state/state.dart';
import '../../../../../core/widgets/auto_size_text_widget.dart';
import '../../../../../core/widgets/error_widget.dart';
import '../../../../../core/widgets/online_images_widget.dart';
import '../../../category/data/model/category_data.dart';
import '../../data/model/section_with_product_data.dart';
import '../../../category/presentation/widgets/home_categories_list_widget.dart';
import 'loading_home_widget.dart';

class CategoryWidget extends StatelessWidget {
  final DataState<SectionAndProductData> state;
  final VoidCallback? refresh;

  const CategoryWidget({
    super.key,
    required this.state,
    this.refresh,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Consumer(builder: (context, ref, child) {
        if (state.stateData == States.loading) {
          return Padding(
            padding:  EdgeInsets.only(top: 24.h),
            child: const LoadingHomeWidget(),
          );
        } else if (state.stateData == States.loaded ||
            state.stateData == States.loadingMore) {
          // return ListToDisplayCategoriesOnTheHomeWidget(
          //   category: state.data.sections![0].category ?? [],
          // );
          return HomeCategoriesList(
            category: state.data.sections![0].category ?? [],
          );
        } else if (state.stateData == States.error) {
          state.stateData = States.initial;
          return Padding(
            padding: EdgeInsets.only(top: 20.h),
            child: ErrorsWidget(
              title: MessageOfErorrApi.getExeptionMessage(state.exception as DioException).first,
              subTitle: MessageOfErorrApi.getExeptionMessage(state.exception as DioException).last,
              onPressed: refresh,
            ),
          );
        }
        return const SizedBox.shrink();
      }),
    );
  }
}

// class ListToDisplayCategoriesOnTheHomeWidget extends ConsumerWidget {
//   const ListToDisplayCategoriesOnTheHomeWidget({super.key,required this.category});
//   final List<CategoryData>? category;
//
//
//   @override
//   Widget build(BuildContext context,ref) {
//     return Container(
//       height: 100.h,
//       width: double.infinity,
//       margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
//       decoration: BoxDecoration(
//         color: Colors.transparent,
//         borderRadius: BorderRadius.circular(12.sp),
//       ),
//
//       child: GridView.builder(
//         scrollDirection: Axis.horizontal,
//         padding: EdgeInsets.all(8.sp),
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 1,
//           mainAxisSpacing: 0.0,
//           crossAxisSpacing: 0.0,
//           childAspectRatio: 1.2,
//         ),
//         itemCount: category!.length,
//         itemBuilder: (context, index) {
//           return CircleCardForCategoriesWidget(
//             idCategory: category![index].id!,
//             name: category![index].name!,
//             image: category![index].image?? 'https://eyess.cc/?seraph_accel_gci=wp-content%2Fuploads%2F2019%2F07%2F2138-1.jpg&n=Flq38TbBQfHfEB8rSZ0XQ',
//
//             // image: 'https://eyess.cc/?seraph_accel_gci=wp-content%2Fuploads%2F2019%2F07%2F2138-1.jpg&n=Flq38TbBQfHfEB8rSZ0XQ',
//           );
//
//         },
//       ),
//       // child: Padding(
//       //   padding:  EdgeInsets.all(8.0.sp),
//       //   child: Wrap(
//       //     spacing: 8.0.w,
//       //     runSpacing: 10.0.h,
//       //
//       //     children: category!.map((item){
//       //       return CircleCardForCategoriesWidget(
//       //                 idCategory: item.id!,
//       //                 name: item.name!,
//       //                 image: 'https://eyess.cc/?seraph_accel_gci=wp-content%2Fuploads%2F2019%2F07%2F2138-1.jpg&n=Flq38TbBQfHfEB8rSZ0XQ',
//       //               );
//       //     }).toList(),
//       //   ),
//       // ),
//     );
//   }
// }

