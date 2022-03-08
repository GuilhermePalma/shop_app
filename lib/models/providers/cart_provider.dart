import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/models/entities/cart.dart';
import 'package:shop/models/entities/product.dart';

class CartProvider extends ChangeNotifier {
  Map<String, Cart> _items = {};

  Map<String, Cart> get items => {..._items};

  int get itemCount {
    return _items.length;
  }

  double get totalAmout {
    double totalPriceCart = 0.0;
    _items.forEach((key, value) =>
        totalPriceCart += value.priceItem * value.quantityProducts);
    return totalPriceCart;
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items.update(product.id, (existingValue) {
        return Cart(
          id: existingValue.id,
          productId: existingValue.productId,
          nameProduct: existingValue.nameProduct,
          quantityProducts: existingValue.quantityProducts + 1,
          priceItem: existingValue.priceItem,
        );
      });
    } else {
      _items.putIfAbsent(
        product.id,
        () => Cart(
          // TODO Mudar Id
          id: Random().nextDouble().toString(),
          productId: product.id,
          nameProduct: product.name,
          quantityProducts: 1,
          priceItem: product.price,
        ),
      );
    }

    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
