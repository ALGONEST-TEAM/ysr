import '../../../../../../core/network/remote_request.dart';
import '../../../../../../core/network/urls.dart';
import '../model/product_data.dart';

class ProductDetailsRemoteDataSource {
  ProductDetailsRemoteDataSource();

  final _vendors = const [
    {'id': 1, 'name': 'متجر الأناقة الرياضية', 'rating': 4.8, 'reviews_count': 95},
    {'id': 2, 'name': 'مؤسسة التقنية الحديثة', 'rating': 4.9, 'reviews_count': 140},
    {'id': 3, 'name': 'متجر يسر الرسمي', 'rating': 5.0, 'reviews_count': 320},
  ];

  Future<ProductData> getDetailsOfProduct(int idProduct) async {
    final response = await RemoteRequest.getData(
      url: "${AppURL.getDetailsOfProduct}/$idProduct",
    );
    
    final data = response.data['data']['product'] as Map<String, dynamic>;
    final vendor = _vendors[idProduct % _vendors.length];
    data['vendor_id'] = vendor['id'];
    data['vendor'] = vendor;

    return ProductData.fromJson(data);
  }
}