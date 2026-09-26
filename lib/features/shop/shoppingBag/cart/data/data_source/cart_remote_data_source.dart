import 'package:dartz/dartz.dart';

import '../../../../../../core/network/remote_request.dart';
import '../../../../../../core/network/urls.dart';
import '../model/cart_model.dart';
import '../model/cart_product_model.dart';

class CartRemoteDataSource {
  CartRemoteDataSource();

  final _vendors = const [
    {'id': 1, 'name': 'متجر الأناقة الرياضية', 'rating': 4.8, 'reviews_count': 95},
    {'id': 2, 'name': 'مؤسسة التقنية الحديثة', 'rating': 4.9, 'reviews_count': 140},
    {'id': 3, 'name': 'متجر يسر الرسمي', 'rating': 5.0, 'reviews_count': 320},
  ];

  Future<List<CartModel>> getAllCart() async {
    final response = await RemoteRequest.getData(
      url: AppURL.getAllCart,
    );
    final List<dynamic> items =
        (response.data is Map && response.data['data'] is List)
            ? response.data['data'] as List
            : [];
            
    for (var item in items) {
      if (item is Map) {
        final productId = (item['product_id'] as num?)?.toInt() ?? 0;
        final vendor = _vendors[productId % _vendors.length];
        item['vendor_id'] = vendor['id'];
        item['vendor'] = vendor;
      }
    }
            
    return CartModel.fromJsonList(items);
  }

  Future<int> getCartCount() async {
    final res = await RemoteRequest.getData(url: AppURL.getCartCount);
    return (res.data['data'] as num?)?.toInt() ?? 0;
  }

  Future<Unit> addToCart(
    int productId,
    dynamic colorId,
    int sizeId,
    dynamic price,
    int quantity,
    int? numberId,
    int isPrintable,
  ) async {
    await RemoteRequest.postData(
      path: AppURL.addToCart,
      data: {
        'product_id': productId,
        'color_id': colorId,
        'parent_measuring_id': sizeId,
        'price': price,
        'quantity': quantity,
        if (numberId != 0) 'number_id': numberId,
        'is_printable': isPrintable,
      },
    );
    return Future.value(unit);
  }

  Future<CartProductModel> updateCart(
    int id,
    int productId,
    dynamic colorId,
    int sizeId,
    dynamic price,
    int quantity,
    int? numberId,
    int isPrintable,
  ) async {
    final response = await RemoteRequest.postData(
      path: "${AppURL.updateCart}/$id",
      data: {
        'product_id': productId,
        'color_id': colorId,
        'parent_measuring_id': sizeId,
        'price': price,
        'quantity': quantity,
        if (numberId != 0) 'number_id': numberId,
        'is_printable': isPrintable,
      },
    );
    
    final data = response.data['data'] as Map<String, dynamic>;
    final vendor = _vendors[productId % _vendors.length];
    data['vendor_id'] = vendor['id'];
    data['vendor'] = vendor;
    
    return CartProductModel.fromJson(data);
  }

  Future<Unit> deleteAProductFromTheCart(
    int id,
  ) async {
    await RemoteRequest.postData(path: "${AppURL.deleteCart}/$id");
    return Future.value(unit);
  }
}
