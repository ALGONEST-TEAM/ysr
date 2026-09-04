import '../../../../../../core/network/remote_request.dart';
import '../../../../../../core/network/urls.dart';
import '../model/product_data.dart';


class ProductDetailsRemoteDataSource {

  ProductDetailsRemoteDataSource();


  Future<ProductData> getDetailsOfProduct(int idProduct) async {

    final response = await RemoteRequest.getData(
      url: "${AppURL.getDetailsOfProduct}/$idProduct",
    );
    return ProductData.fromJson(response.data['data']['product']);
  }
}