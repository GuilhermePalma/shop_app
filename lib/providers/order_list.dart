import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/models/order.dart';
import 'package:shop/providers/cart.dart';

class OrderList extends ChangeNotifier {
  List<Order> _items = [];

  List<Order> get items => [..._items];

  int get itemsCount => _items.length;

  void addOrder(Cart cart) {
    _items.insert(
      0,
      Order(
        // TODO: Alterar ID
        id: Random().nextDouble().toString(),
        total: cart.totalAmout,
        date: DateTime.now(),
        products: cart.items.values.toList(),
      ),
    );
    notifyListeners();
  }
}
