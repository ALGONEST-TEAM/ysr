import '../../../productManagement/detailsProducts/data/model/product_data.dart';
import '../model/offers_model.dart';
import '../model/vendor_model.dart';

class MockHomeDataSource {
  static List<OffersModel> getBannersForCategory(int categoryId) {
    // Generate some mock banners specific to the category
    return [
      OffersModel(
        id: categoryId * 10 + 1,
        title: 'عرض خاص',
        image: 'https://via.placeholder.com/800x400.png?text=YSR+Banner+1+Cat+$categoryId',
      ),
      OffersModel(
        id: categoryId * 10 + 2,
        title: 'تخفيضات نهاية الموسم',
        image: 'https://via.placeholder.com/800x400.png?text=YSR+Banner+2+Cat+$categoryId',
      ),
    ];
  }

  static List<VendorModel> getTopVendorsForCategory(int categoryId) {
    return [
      VendorModel(
        id: categoryId * 100 + 1,
        name: 'متجر يسر المتميز $categoryId',
        logo: 'https://via.placeholder.com/150.png?text=V1',
        rating: 4.8,
      ),
      VendorModel(
        id: categoryId * 100 + 2,
        name: 'وكيل معتمد $categoryId',
        logo: 'https://via.placeholder.com/150.png?text=V2',
        rating: 4.5,
      ),
      VendorModel(
        id: categoryId * 100 + 3,
        name: 'مورد موثوق $categoryId',
        logo: 'https://via.placeholder.com/150.png?text=V3',
        rating: 4.9,
      ),
    ];
  }


  static List<ProductData> getFlashDealsForCategory(int categoryId) {
    // Generate some mock products for flash deals
    return List.generate(4, (index) {
      return ProductData(
        id: categoryId * 1000 + index,
        name: 'منتج سريع $index',
        price: 150.0 + (index * 10),
        priceAfterDiscount: 100.0 + (index * 5),
        discount: "50",
        mainImage: ['https://via.placeholder.com/300.png?text=Product+$index'],
        description: 'وصف المنتج السريع',
        favorite: false,
        colorsProduct: [],
        productColorsCount: 0,
        averageRate: 4.5,
        sizeProduct: [],
      );
    });
  }
}
