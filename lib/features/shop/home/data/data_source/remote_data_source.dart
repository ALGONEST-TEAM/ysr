import '../../../../../core/network/remote_request.dart';
import '../../../../../core/network/urls.dart';
import '../../../home/data/model/sections_and_offers_data.dart';
import '../../../home/data/model/section_with_product_data.dart';
import '../../data/model/vendor_model.dart';
import '../model/offer_products_model.dart';

class SectionsRemoteDataSource {
  SectionsRemoteDataSource();

  Future<SectionsAndOffersData> getAllSectionAndAllOffersData() async {
    final response = await RemoteRequest.getData(
      url: "/sections?page=1",
    );

    final data = response.data['data'];
    if (data['sections'] != null) {
      for (int i = 0; i < (data['sections'] as List).length; i++) {
        final section = data['sections'][i];
        final sectionId = section['id'] as int? ?? i;
        final vendor = VendorModel.mockVendors[sectionId % VendorModel.mockVendors.length];
        section['vendor_id'] = vendor['id'];
        section['vendor'] = vendor;
      }
    }

    return SectionsAndOffersData.fromJson(data);
  }

  Future<SectionAndProductData> getSectionData(
    int idSection,
    int page,
    int filterType,
  ) async {
    final response = await RemoteRequest.getData(
      url: "/sections/$idSection?page=$page&perPage=10&filter=$filterType",
    );

    final data = response.data['data'];
    if (data['products'] != null && data['products']['data'] != null) {
      for (int i = 0; i < (data['products']['data'] as List).length; i++) {
        final product = data['products']['data'][i];
        final productId = product['id'] as int? ?? i;
        final vendor = VendorModel.mockVendors[productId % VendorModel.mockVendors.length];
        product['vendor_id'] = vendor['id'];
        product['vendor'] = vendor;
      }
    }

    return SectionAndProductData.fromJson(data);
  }

  Future<OfferProductsModel> getOfferProducts(int offerId) async {
    final response = await RemoteRequest.getData(
      url: "${AppURL.getOfferProducts}$offerId/products",
    );

    return OfferProductsModel.fromJson(response.data['data']);
  }
}
