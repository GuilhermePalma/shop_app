import 'dart:convert';
import 'dart:math';

import 'package:shop/models/entities/cart.dart';
import 'package:shop/models/providers/cart_provider.dart';

class Order {
  static const String paramTotal = "totalOrder";
  static const String paramDate = "dateTimeNow";
  static const String paramProducts = "products";

  final String id;
  final double total;
  final List<Cart> products;
  final DateTime date;
  Order({
    required this.id,
    required this.total,
    required this.products,
    required this.date,
  });

  /// Metodo que copia e permite alterações nos Atributos da Order, retornando
  /// uma nova Instancia de Order
  Order copyWith({
    String? id,
    double? total,
    List<Cart>? products,
    DateTime? date,
  }) {
    return Order(
      id: id ?? this.id,
      total: total ?? this.total,
      products: products ?? this.products,
      date: date ?? this.date,
    );
  }

  /// Metodo que Permite gerar um Map a Partir de uma Order
  Map<String, dynamic> toMap() {
    return {
      paramTotal: total,
      paramProducts:
          products.map((productCart) => productCart.toMap()).toList(),
      paramDate: date.toIso8601String(),
    };
  }

  /// Metodo que Retorna uma Instancia de Order a partir de um Map
  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: "",
      total: double.tryParse(map[paramTotal].toString()) ?? 0.0,
      products:
          List<Cart>.from(map[paramProducts]?.map((x) => Cart.fromMap(x))),
      date: DateTime.tryParse(map[paramDate]) ?? DateTime.now(),
    );
  }

  /// Metodo que Retorna uma Instancia de Order a partir de um Cart
  factory Order.fromCart(CartProvider cart) {
    List<Cart> products = [];
    cart.items.forEach((key, value) => products.add(value));

    return Order(
      id: Random().nextDouble().toString(),
      total: cart.totalAmout,
      products: products,
      date: DateTime.now(),
    );
  }

  /// Transfroma uma Order em um Map e Converte em JSON
  String toJson() => json.encode(toMap());

  /// Converte um JSON que está em um Map para uma Order
  factory Order.fromJson(String source) => Order.fromMap(json.decode(source));

  /// Metodo Responsavel por Transformar os Dados da Order em String
  @override
  String toString() {
    return 'Order(id: $id, total: $total, products: $products, date: $date)';
  }
}
