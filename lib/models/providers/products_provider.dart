import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/http_exceptions.dart';
import 'package:shop/models/entities/product.dart';
import 'package:shop/utils/urls.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];

  /// Retorna um Clone da Lista com os Produtos Salvos
  List<Product> get productsList => [..._items];

  /// Retorna os Produtos Favoritos do Usuario
  List<Product> get productsFavoritesList =>
      [..._items.where((productItem) => productItem.isFavorite).toList()];

  /// Obtem a Quantidade de Itens presentes na Lista
  int get itemsCount => _items.length;

  /// Obtem os Produtos Cadastrados na API
  Future<void> loadedProducts() async {
    final responseAPI = await http.get(Uri.parse("${Urls.urlProducts}.json"));

    if (responseAPI.body == 'null') return;

    // Converte o JSON em Map e Obtem os Itens
    Map<String, dynamic> dataJson = jsonDecode(responseAPI.body);
    dataJson.forEach((productId, productData) {
      // Verifica se o Item já está na Lista.
      int index = _items.indexWhere((prod) => prod.id == productId);
      if (index == -1) {
        _items.add(Product.fromMap(productData).copyWith(id: productId));
      }
    });
    notifyListeners();
  }

  /// Metodo responsavel por Recarregar a Lista de Produtos
  Future<void> refreshProducts() {
    _items = [];
    return loadedProducts();
  }

  /// Adiciona um Product na Lista e na API
  /// Por ser aync, ele obrigatoriamente tem que retornar um Future. Com isso,  a solicitação na
  /// API, retorna um void de Forma Assincrona.
  Future<void> addProduct(Product product) async {
    // await é utilizado em itens marcados como async. Ele espera o Future ser concluido
    final responseAPI = await http.post(
      Uri.parse("${Urls.urlProducts}.json"),
      body: product.copyWith(id: "").toJson(),
    );

    final String idForFirebase = jsonDecode(responseAPI.body)["name"];
    _items.add(product.copyWith(id: idForFirebase));
    notifyListeners();
  }

  /// Exclui um Product da Lista
  Future<void> deleteProduct(Product product) async {
    int indexProduct =
        _items.indexWhere((itemList) => itemList.id == product.id);
    if (indexProduct >= 0) {
      final Product product = _items.elementAt(indexProduct);

      _items.removeAt(indexProduct);
      notifyListeners();

      final responseAPI = await http.delete(
        Uri.parse("${Urls.urlProducts}/${product.id}.json"),
        body: product.copyWith(id: "").toJson(),
      );

      if (responseAPI.statusCode >= 400) {
        _items.add(product);
        notifyListeners();
        throw (HttpExceptions(
          message: "Não foi Possivel Excluir o Produto",
          statusCode: responseAPI.statusCode,
          bodyError: responseAPI.body,
        ));
      }
    }
  }

  /// Atualiza um Product na Lista por meio do seu ID
  Future<void> updateProduct(Product product) async {
    // Obtem o Index com o Id Informado
    int indexProduct =
        _items.indexWhere((itemList) => itemList.id == product.id);

    // Inclui ou Atualiza o Produto na Lista
    if (indexProduct < 0) {
      addProduct(product);
    } else {
      await http.patch(
        Uri.parse("${Urls.urlProducts}/${product.id}.json"),
        body: product.copyWith(id: "").toJson(),
      );

      _items.removeAt(indexProduct);
      _items.insert(indexProduct, product);
      notifyListeners();
    }
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
