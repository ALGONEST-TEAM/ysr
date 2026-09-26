import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/state/data_state.dart';
import '../../../../../../core/state/state.dart';
import '../../data/model/cart_model.dart';
import '../../data/model/cart_product_model.dart';
import '../../data/repos/cart_repo.dart';

final getAllCartProvider =
    StateNotifierProvider.autoDispose<
      GetAllCartController,
      DataState<List<CartModel>>
    >((ref) {
      return GetAllCartController();
    });

class GetAllCartController extends StateNotifier<DataState<List<CartModel>>> {
  GetAllCartController() : super(DataState<List<CartModel>>.initial([])) {
    getData();
  }

  final _controller = CartReposaitory();

  // تجميع منتجات السلة لتعرض كقوائم منفصلة لكل مورد
  Map<int, List<CartModel>> get groupedByVendor {
    final Map<int, List<CartModel>> groups = {};
    for (var item in state.data) {
      final vendorId = item.vendorId ?? 0;
      
      if (!groups.containsKey(vendorId)) {
        groups[vendorId] = [];
      }
      
      groups[vendorId]!.add(item);
    }
    return groups;
  }

  Future<void> getData() async {
    state = state.copyWith(state: States.loading);
    final data = await _controller.getAllCart();
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

final getCartCountProvider =
    StateNotifierProvider.autoDispose<GetCartCountNotifier, int>(
      (ref) => GetCartCountNotifier(),
    );

class GetCartCountNotifier extends StateNotifier<int> {
  GetCartCountNotifier() : super(0);

  final _repo = CartReposaitory();

  Future<void> refresh() async {
    final res = await _repo.getCartCount();
    if (!mounted) return; // ✅ قد يكون dispose() تم أثناء الانتظار
    res.fold((_) {}, (count) => state = count);
  }

  void set(int value) => state = value;

  void clear() => state = 0;
}

enum CartOperation { none, add, update, delete }

final cartProvider =
    StateNotifierProvider.autoDispose<
      CartController,
      DataState<CartProductModel>
    >((ref) {
      return CartController();
    });

class CartController extends StateNotifier<DataState<CartProductModel>> {
  CartController()
    : super(DataState<CartProductModel>.initial(CartProductModel.empty()));

  final _controller = CartReposaitory();

  CartOperation _lastOperation = CartOperation.none;

  CartOperation get lastOperation => _lastOperation;

  final List<CartModel> _selectedProducts = [];

  List<CartModel> get selectedProducts => _selectedProducts;

  // التحقق من أن جميع المنتجات المحددة في السلة تابعة لنفس المورد
  // يستخدم لمنع المستخدم من عمل Checkout لمنتجات من موردين مختلفين في نفس الطلب
  bool get isSingleVendorSelected {
    if (_selectedProducts.isEmpty) return true;
    final firstVendorId = _selectedProducts.first.vendorId ?? 0;
    return _selectedProducts.every((p) => (p.vendorId ?? 0) == firstVendorId);
  }

  int? get selectedVendorId {
    if (_selectedProducts.isEmpty) return null;
    if (isSingleVendorSelected) {
      return _selectedProducts.first.vendorId ?? 0;
    }
    return null;
  }

  double calculateSelectedTotalPrice() {
    return _selectedProducts.fold(0, (sum, product) {
      if (product.isPrintable == 1) {
        return sum +
            (product.productPriceAfterDiscount! * product.quantity!) +
            (product.printingPrice! * product.quantity!);
      } else {
        return sum + (product.productPriceAfterDiscount! * product.quantity!);
      }
    });
  }

  bool isVendorProductsFullySelected(List<CartModel> vendorProducts) {
    if (vendorProducts.isEmpty) return false;
    return vendorProducts.every(
      (product) => selectedProducts.any((p) => p.id == product.id),
    );
  }

  void toggleVendorProductsSelection(bool isChecked, List<CartModel> vendorProducts) {
    if (isChecked) {
      for (var product in vendorProducts) {
        if (!selectedProducts.any((p) => p.id == product.id)) {
          selectedProducts.add(product);
        }
      }
    } else {
      selectedProducts.removeWhere((p) => vendorProducts.any((vp) => vp.id == p.id));
    }
    state = state.copyWith(state: States.initial);
  }

  void toggleProductSelection(bool isChecked, CartModel product) {
    if (isChecked) {
      _selectedProducts.add(product);
    } else {
      _selectedProducts.removeWhere((p) => p.id == product.id);
    }
    state = state.copyWith(state: States.initial);
  }

  void updateSelectedProduct(CartModel updatedProduct) {
    int index = selectedProducts.indexWhere((p) => p.id == updatedProduct.id);
    if (index != -1) {
      selectedProducts[index] = updatedProduct;
    }
  }

  void updateSelectedProductQuantity(int id, int quantity) {
    int index = selectedProducts.indexWhere((p) => p.id == id);
    if (index != -1) {
      selectedProducts[index] = selectedProducts[index].copyWith(
        quantity: quantity,
      );
    }
  }

  Future<void> addToCart({
    required int prodectId,
    required dynamic colorId,
    required int sizeId,
    required dynamic price,
    required int quantity,
    required int? numberId,
    required int isPrintable,
  }) async {
    _lastOperation = CartOperation.add;
    state = state.copyWith(state: States.loading);
    final data = await _controller.addToCart(
      prodectId,
      colorId,
      sizeId,
      price,
      quantity,
      numberId,
      isPrintable,
    );
    data.fold(
      (f) {
        state = state.copyWith(state: States.error, exception: f);
      },
      (data) {
        state = state.copyWith(state: States.loaded);
      },
    );
  }

  Future<void> updateCart({
    required int id,
    required int prodectId,
    required dynamic colorId,
    required int sizeId,
    required dynamic price,
    required int quantity,
    required int? numberId,
    required int isPrintable,
  }) async {
    _lastOperation = CartOperation.update;

    state = state.copyWith(state: States.loading);
    final data = await _controller.updateCart(
      id,
      prodectId,
      colorId,
      sizeId,
      price,
      quantity,
      numberId,
      isPrintable,
    );
    data.fold(
      (f) {
        state = state.copyWith(state: States.error, exception: f);
      },
      (data) {
        state = state.copyWith(state: States.loaded, data: data);
        updateSelectedProductQuantity(id, quantity);
      },
    );
  }

  Future<void> deleteAProductFromTheCart({
    required int id,
    required WidgetRef ref,
  }) async {
    _lastOperation = CartOperation.delete;

    state = state.copyWith(state: States.loading);
    final data = await _controller.deleteAProductFromTheCart(id);
    data.fold(
      (f) {
        state = state.copyWith(state: States.error, exception: f);
      },
      (data) {
        selectedProducts.removeWhere((product) => product.id == id);
        ref
            .read(getAllCartProvider.notifier)
            .state
            .data
            .removeWhere((item) => item.id == id);
        ref.read(getCartCountProvider.notifier).refresh();
        state = state.copyWith(state: States.loaded);
      },
    );
  }
}

final cartProductProvider = StateNotifierProvider.autoDispose
    .family<CartProductNotifier, CartModel, int>((ref, productId) {
      final cartState = ref.watch(getAllCartProvider);
      final product = cartState.data.firstWhere(
        (item) => item.id == productId,
        orElse: () => CartModel.empty(),
      );
      return CartProductNotifier(product);
    });

class CartProductNotifier extends StateNotifier<CartModel> {
  CartProductNotifier(super.initialData);

  void updateProduct(CartModel newData) {
    state = newData;
  }
}
