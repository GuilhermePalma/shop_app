import 'package:flutter/material.dart';
import 'package:shop/models/entities/order.dart';
import 'package:shop/models/providers/cart_provider.dart';

class OrdersProvider extends ChangeNotifier {
  List<Order> _items = [];

  List<Order> get items => [..._items];

  int get itemsCount => _items.length;

  void addOrder(CartProvider cart) {
    _items.insert(
      0,
      Order(
        id: Order.generateIdItem,
        total: cart.totalAmout,
        date: DateTime.now(),
        products: cart.items.values.toList(),
      ),
    );
    notifyListeners();
  }
}
