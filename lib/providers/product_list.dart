import 'package:flutter/material.dart';
import 'package:shop/data/dummy_data.dart';
import 'package:shop/models/product.dart';

class ProductList with ChangeNotifier {
  final List<Product> _items = dummyProducts;

  /// Retorna um Clone da Lista com os Produtos Salvos
  List<Product> get productsList => [..._items];

  /// Adiciona um Produto na Lista
  void addProduct(Product product) {
    _items.add(product);

    // Notifica que ocorreu uma mudança
    notifyListeners();
  }
}
