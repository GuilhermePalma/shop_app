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

  Map<String, dynamic> toMap() {
    return {
      paramTotal: total,
      paramProducts: products.map((productCart) => productCart.toMap()).toList(),
      paramDate: date.toIso8601String(),
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: "",
      total: map[paramTotal]?.toDouble() ?? 0.0,
      products:
          List<Cart>.from(map[paramProducts]?.map((x) => Cart.fromMap(x))),
      date: DateTime(map[paramDate]),
    );
  }

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

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) => Order.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Order(id: $id, total: $total, products: $products, date: $date)';
  }
}
