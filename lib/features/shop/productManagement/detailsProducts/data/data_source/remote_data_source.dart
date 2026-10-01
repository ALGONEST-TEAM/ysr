import '../../../../../../core/network/remote_request.dart';
import '../../../../../../core/network/urls.dart';
import '../../../../home/data/model/vendor_model.dart';
import '../model/product_data.dart';

class ProductDetailsRemoteDataSource {

  ProductDetailsRemoteDataSource();

  Future<ProductData> getDetailsOfProduct(int idProduct) async {
    final response = await RemoteRequest.getData(
      url: "${AppURL.getDetailsOfProduct}/$idProduct",
    );
    
    final data = response.data['data']['product'] as Map<String, dynamic>;
    final vendor = VendorModel.mockVendors[idProduct % VendorModel.mockVendors.length];
    data['vendor_id'] = vendor['id'];
    data['vendor'] = vendor;

    return ProductData.fromJson(data);
  }
}