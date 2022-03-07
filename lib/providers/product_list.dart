import 'package:flutter/material.dart';
import 'package:shop/data/dummy_data.dart';
import 'package:shop/models/product.dart';

class ProductList with ChangeNotifier {
  final List<Product> _items = dummyProducts;

  /// Retorna um Clone da Lista com os Produtos Salvos
  List<Product> get productsList => [..._items];

  /// Retorna os Produtos Favoritos do Usuario
  List<Product> get productsFavoritesList =>
      [..._items.where((productItem) => productItem.isFavorite).toList()];
}
