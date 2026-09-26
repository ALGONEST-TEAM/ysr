import '../../../../home/data/model/vendor_model.dart';

class CartProductModel {
  final int id;
  final int productId;
  final int quantity;
  final dynamic colorId;
  final int sizeId;
  final String colorHex;
  final String colorName;
  final String sizeName;
  final String image;
  final dynamic price;
  final num? productPriceAfterDiscount;
  final num? discount;
  final int? numberId;
  final String? numberName;
  final int? isPrintable;
  final dynamic productPrintingPrice;
  final int printingPrice;
  final int vendorId;
  final VendorModel? vendor;

  CartProductModel({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.colorId,
    required this.sizeId,
    required this.colorHex,
    required this.colorName,
    required this.sizeName,
    required this.image,
    required this.price,
    required this.productPriceAfterDiscount,
    required this.discount,
    required this.numberId,
    required this.numberName,
    required this.isPrintable,
    required this.productPrintingPrice,
    required this.printingPrice,
    required this.vendorId,
    this.vendor,
  });

  factory CartProductModel.fromJson(Map<String, dynamic> json) {
    return CartProductModel(
      id: (json['id'] as num? ?? 0).toInt(),
      productId: (json['product_id'] as num? ?? 0).toInt(),
      quantity: (json['quantity'] as num? ?? 1).toInt(),
      colorId: json['color_id'],
      sizeId: (json['parent_measuring_id'] as num? ?? 0).toInt(),
      sizeName: (json['measuring_value'] ?? '').toString(),
      colorHex: (json['color_hex'] ?? '').toString(),
      colorName: (json['color_name'] ?? '').toString(),
      image: (json['image'] ?? '').toString(),
      price: json['price'] ,
      productPriceAfterDiscount: json['product_price_after_discount'] ,
      discount: json['discount'] ,
      numberId: (json['number_id'] as num?)?.toInt(),
      numberName: (json['number_name'] ?? '').toString(),
      isPrintable: json['is_printable'],
      productPrintingPrice: json['product_printing_price'],
      printingPrice: json['printing_price'],
      vendorId: (json['vendor_id'] as num? ?? 0).toInt(),
      vendor: json['vendor'] != null ? VendorModel.fromJson(json['vendor']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'quantity': quantity,
      'color_id': colorId,
      'parent_measuring_id': sizeId,
      'measuring_value': sizeName,
      'color_hex': colorHex,
      'color_name': colorName,
      'image': image,
      'price': price,
      'product_price_after_discount': productPriceAfterDiscount,
      'discount': discount,
      'number_id': numberId,
      'number_name': numberName,
      'is_printable': isPrintable,
      'product_printing_price': productPrintingPrice,
      'printing_price': printingPrice,
      'vendor_id': vendorId,
      'vendor': vendor?.toJson(),
    };
  }

  CartProductModel copyWith({
    int? id,
    int? productId,
    int? quantity,
    dynamic colorId,
    int? sizeId,
    String? colorHex,
    String? colorName,
    String? sizeName,
    String? image,
    dynamic price,
    num? productPriceAfterDiscount,
    num? discount,
    int? numberId,
    String? numberName,
    int? isPrintable,
    dynamic productPrintingPrice,
    int? printingPrice,
    int? vendorId,
    VendorModel? vendor,
  }) {
    return CartProductModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      colorId: colorId ?? this.colorId,
      sizeId: sizeId ?? this.sizeId,
      colorHex: colorHex ?? this.colorHex,
      colorName: colorName ?? this.colorName,
      sizeName: sizeName ?? this.sizeName,
      image: image ?? this.image,
      price: price ?? this.price,
      productPriceAfterDiscount: productPriceAfterDiscount ?? this.productPriceAfterDiscount,
      discount: discount ?? this.discount,
      numberId: numberId ?? this.numberId,
      numberName: numberName ?? this.numberName,
      isPrintable: isPrintable ?? this.isPrintable,
      productPrintingPrice: productPrintingPrice ?? this.productPrintingPrice,
      printingPrice: printingPrice ?? this.printingPrice,
      vendorId: vendorId ?? this.vendorId,
      vendor: vendor ?? this.vendor,
    );
  }

  factory CartProductModel.empty() => CartProductModel(
        id: 0,
        productId: 0,
        quantity: 0,
        colorId: 0,
        sizeId: 0,
        colorHex: '',
        colorName: '',
        sizeName: '',
        image: '',
        price: '',
        productPriceAfterDiscount: null,
        discount: null,
        isPrintable: 0,
        numberName: '',
        numberId: 0,
        productPrintingPrice: 0,
        printingPrice: 0,
        vendorId: 0,
      );
}
