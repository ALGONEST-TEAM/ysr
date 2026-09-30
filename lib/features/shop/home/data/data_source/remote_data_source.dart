import '../../../../../core/network/remote_request.dart';
import '../../../../../core/network/urls.dart';
import '../../../home/data/model/sections_and_offers_data.dart';
import '../../../home/data/model/section_with_product_data.dart';
import '../model/offer_products_model.dart';

class SectionsRemoteDataSource {
  SectionsRemoteDataSource();

  static const vendors = [
    {'id': 1, 'name': 'متجر الأناقة الرياضية', 'rating': 4.8, 'reviews_count': 95, 'logo': 'https://img.freepik.com/free-vector/bird-colorful-logo-gradient-vector_343694-1365.jpg'},
    {'id': 2, 'name': 'مؤسسة التقنية الحديثة', 'rating': 4.9, 'reviews_count': 140, 'logo': 'https://img.freepik.com/free-vector/gradient-bird-logo-template_23-2151128362.jpg'},
    {'id': 3, 'name': 'متجر يسر الرسمي', 'rating': 5.0, 'reviews_count': 320, 'logo': 'https://img.freepik.com/free-vector/modern-eagle-logo-design_1332-1599.jpg'},
  ];

  Future<SectionsAndOffersData> getAllSectionAndAllOffersData() async {
    final response = await RemoteRequest.getData(
      url: "/sections?page=1",
    );

    final data = response.data['data'];
    if (data['sections'] != null) {
      for (int i = 0; i < (data['sections'] as List).length; i++) {
        final section = data['sections'][i];
        final sectionId = section['id'] as int? ?? i;
        final vendor = vendors[sectionId % vendors.length];
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
        final vendor = vendors[productId % vendors.length];
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
