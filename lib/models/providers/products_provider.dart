import 'package:flutter/material.dart';
import 'package:shop/data/dummy_data.dart';
import 'package:shop/models/entities/product.dart';

class ProductsProvider with ChangeNotifier {
  final List<Product> _items = dummyProducts;

  /// Retorna um Clone da Lista com os Produtos Salvos
  List<Product> get productsList => [..._items];

  /// Retorna os Produtos Favoritos do Usuario
  List<Product> get productsFavoritesList =>
      [..._items.where((productItem) => productItem.isFavorite).toList()];

  /// Obtem a Quantidade de Itens presentes na Lista
  int get itemsCount => _items.length;

  /// Adiciona um Product à Lista
  void addProduct(Product product) {
    _items.add(product);
    notifyListeners();
  }

  /// Atualiza um Product na Lista por meio do seu ID
  void updateProduct(Product product) {
    // Obtem o Index com o Id Informado
    int indexProduct = _items.indexWhere((p) => p.id == product.id);

    // Inclui ou Atualiza o Produto na Lista
    if (indexProduct < 0) {
      addProduct(product);
    } else {
      _items.removeAt(indexProduct);
      _items.insert(indexProduct, product);
      notifyListeners();
    }
  }

  /// Adiciona um Product à Lista por meio de um Map
  void addProductFromData(Map<String, Object> productData) {
    bool hasId = productData.containsKey("id") && productData["id"] != null;

    final Product product = Product(
      id: hasId ? productData["id"] as String : Product.generateIdItem,
      name: productData["name"] as String,
      description: productData["description"] as String,
      price: productData["price"] as double,
      imageURL: productData["imageUrl"] as String,
    );

    // Atualiza ou Insere o Produto
    hasId ? updateProduct(product) : addProduct(product);
  }
}
