import 'dart:convert';
import 'dart:math';

import 'package:shop/models/entities/product.dart';

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

  /// Metodo que copia e permite alterações nos Atributos do Cart, retornando
  /// uma nova Instancia de Cart
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

  /// Metodo que Permite gerar um Map a Partir de um Cart
  Map<String, Object> toMap() {
    return {
      paramProductID: productId,
      paramNameProduct: nameProduct,
      paramQuantityProduct: quantityProducts,
      paramPriceItem: priceItem,
    };
  }

  /// Metodo que Retorna uma Instancia de Cart a partir de um Map
  factory Cart.fromMap(Map<String, dynamic> map) {
    return Cart(
      id: map[paramID] ?? '',
      productId: map[paramProductID] ?? '',
      nameProduct: map[paramNameProduct] ?? '',
      quantityProducts: int.tryParse(map[paramQuantityProduct].toString()) ?? 0,
      priceItem: double.tryParse(map[paramPriceItem].toString()) ?? 0.0,
    );
  }

  /// Metodo que Retorna uma Instancia de Cart a partir de um Product
  factory Cart.fromProduct(Product product) {
    return Cart(
      id: Random().nextDouble().toString(),
      productId: product.id,
      nameProduct: product.name,
      quantityProducts: 1,
      priceItem: product.price,
    );
  }

  /// Transfroma um Cart em um Map e Converte em JSON
  String toJson() => json.encode(toMap());

  /// Converte um JSON que está em um Map para um Cart
  factory Cart.fromJson(String source) => Cart.fromMap(json.decode(source));

  /// Metodo Responsavel por Transformar os Dados do Cart em String
  @override
  String toString() {
    return 'Cart(id: $id, productId: $productId, nameProduct: $nameProduct, quantityProducts: $quantityProducts, priceItem: $priceItem)';
  }
}
