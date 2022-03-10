import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/data/dummy_data.dart';
import 'package:shop/models/entities/product.dart';

class ProductsProvider with ChangeNotifier {
  // TODO ALTERAR
  final String _baseUrlApi =
      "https://app-shop-flutter-default-rtdb.firebaseio.com";
  final List<Product> _items = dummyProducts;

  /// Retorna um Clone da Lista com os Produtos Salvos
  List<Product> get productsList => [..._items];

  /// Retorna os Produtos Favoritos do Usuario
  List<Product> get productsFavoritesList =>
      [..._items.where((productItem) => productItem.isFavorite).toList()];

  /// Obtem a Quantidade de Itens presentes na Lista
  int get itemsCount => _items.length;

  /// Obtem os Produtos Cadastrados na API
  Future<void> loadedProducts() async {
    final responseAPI = await http.get(Uri.parse("$_baseUrlApi/products.json"));

    if (responseAPI.body == 'null') return;

    // Converte o JSON em Map e Obtem os Itens
    Map<String, dynamic> dataJson = jsonDecode(responseAPI.body);
    dataJson.forEach((productId, productData) {
      _items.add(Product.fromMap(productData).copyWith(id: productId));
    });
    notifyListeners();
  }

  /// Adiciona um Product na Lista e na API
  /// Por ser aync, ele obrigatoriamente tem que retornar um Future. Com isso,  a solicitação na
  /// API, retorna um void de Forma Assincrona.
  Future<void> addProduct(Product product) async {
    // await é utilizado em itens marcados como async. Ele espera o Future ser concluido
    final responseAPI = await http.post(
      Uri.parse("$_baseUrlApi/products.json"),
      body: product.copyWith(id: "").toJson(),
    );

    final String idForFirebase = jsonDecode(responseAPI.body)["name"];
    _items.add(product.copyWith(id: idForFirebase));
    notifyListeners();
  }

  /// Exclui um Product da Lista
  void deleteProduct(Product product) {
    int indexProduct =
        _items.indexWhere((itemList) => itemList.id == product.id);
    if (indexProduct >= 0) {
      _items.removeAt(indexProduct);
      notifyListeners();
    }
  }

  /// Atualiza um Product na Lista por meio do seu ID
  Future<void> updateProduct(Product product) {
    // Obtem o Index com o Id Informado
    int indexProduct =
        _items.indexWhere((itemList) => itemList.id == product.id);

    // Inclui ou Atualiza o Produto na Lista
    if (indexProduct < 0) {
      addProduct(product);
    } else {
      _items.removeAt(indexProduct);
      _items.insert(indexProduct, product);
      notifyListeners();
    }

    return Future.value();
  }

  /// Adiciona um Product à Lista por meio de um Map
  Future<void> addProductFromData(Map<String, Object> productData) {
    bool hasId = productData.containsKey("id") && productData["id"] != null;

    // Convert o Map em Product
    final Product product = Product.fromMap(productData);

    // Atualiza ou Insere o Produto
    return hasId ? updateProduct(product) : addProduct(product);
  }
}
