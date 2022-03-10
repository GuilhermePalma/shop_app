import 'dart:convert';

class Cart {
  static const String paramID = "id";
  static const String paramProductID = "productID";
  static const String paramNameProduct = "nameProduct";
  static const String paramQuantityProduct = "quantityProduct";
  static const String paramPriceItem = "priceItem";

  final String id;
  final String productId;
  final String nameProduct;
  final int quantityProducts;
  final double priceItem;

  Cart({
    required this.id,
    required this.productId,
    required this.nameProduct,
    required this.quantityProducts,
    required this.priceItem,
  });

  Cart copyWith({
    String? id,
    String? productId,
    String? nameProduct,
    int? quantityProducts,
    double? priceItem,
  }) {
    return Cart(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      nameProduct: nameProduct ?? this.nameProduct,
      quantityProducts: quantityProducts ?? this.quantityProducts,
      priceItem: priceItem ?? this.priceItem,
    );
  }

  Map<String, Object> toMap() {
    return {
      paramProductID: productId,
      paramNameProduct: nameProduct,
      paramQuantityProduct: quantityProducts,
      paramPriceItem: priceItem,
    };
  }

  factory Cart.fromMap(Map<String, dynamic> map) {
    return Cart(
      id: map[paramID] ?? '',
      productId: map[paramProductID] ?? '',
      nameProduct: map[paramNameProduct] ?? '',
      quantityProducts: int.tryParse(map[paramQuantityProduct].toString()) ?? 0,
      priceItem: double.tryParse(map[paramPriceItem].toString()) ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Cart.fromJson(String source) => Cart.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Cart(id: $id, productId: $productId, nameProduct: $nameProduct, quantityProducts: $quantityProducts, priceItem: $priceItem)';
  }
}
