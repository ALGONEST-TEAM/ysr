import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/state/data_state.dart';
import '../../../../../core/state/state.dart';
import '../../data/model/vendor_model.dart';
import '../../data/repos/reposaitories.dart';

final categoryVendorsProvider = StateProvider.family<List<VendorModel>, int>((
  ref,
  categoryId,
) {
  return VendorModel.mockVendors.map((v) => VendorModel.fromJson(v)).toList();
});

// final allVendorsProvider = FutureProvider<List<VendorModel>>((ref) async {
//   final repository = SectionReposaitory();
//   final result = await repository.getAllVendors();
//
//   return result.fold((l) => <VendorModel>[], (r) => r);
// });

final allVendorsProvider =
    StateNotifierProvider.autoDispose<
        GetAllVendorsController,
      DataState<List<VendorModel>>
    >((ref) {
      return GetAllVendorsController();
    });

class GetAllVendorsController
    extends StateNotifier<DataState<List<VendorModel>>> {
  GetAllVendorsController()
    : super(DataState<List<VendorModel>>.initial([])) {
    getData();
  }

  final _controller = SectionReposaitory();

  Future<void> getData() async {
    state = state.copyWith(state: States.loading);
    final data = await _controller.getAllVendors();
    data.fold(
      (f) {
        state = state.copyWith(state: States.error, exception: f);
      },
      (data) {
        state = state.copyWith(state: States.loaded, data: data);
      },
    );
  }
}
