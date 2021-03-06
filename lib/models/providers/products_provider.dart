import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/http_exceptions.dart';
import 'package:shop/models/entities/product.dart';
import 'package:shop/utils/urls.dart';

class ProductsProvider with ChangeNotifier {
  final String _token;
  final String _userID;
  List<Product> _listProducts;

  ProductsProvider({
    String token = "",
    List<Product> listProducts = const [],
    String userID = "",
  })  : _token = token,
        _listProducts = listProducts,
        _userID = userID;

  /// Retorna um Clone da Lista com os Produtos Salvos
  List<Product> get productsList => [..._listProducts];

  /// Retorna os Produtos Favoritos do Usuario
  List<Product> get productsFavoritesList =>
      [..._listProducts.where((product) => product.isFavorite).toList()];

  /// Obtem a Quantidade de Itens presentes na Lista
  int get itemsCount => _listProducts.length;

  /// Obtem os Produtos Cadastrados na API
  Future<void> loadedProducts() async {
    final responseProducts = await http.get(
      Uri.parse(
        "${Urls.urlProducts}.json${Urls.paramAuth}$_token",
      ),
    );

    if (responseProducts.statusCode != 200 || responseProducts.body == 'null') {
      throw (HttpExceptions(
        message: "Houve um Erro ao Obter os Produtos",
        statusCode: responseProducts.statusCode,
        bodyError: responseProducts.body,
      ));
    }

    final responseFavorites = await http.get(
      Uri.parse(
        "${Urls.urFavoriteProducts}/$_userID.json${Urls.paramAuth}$_token",
      ),
    );

    // Obtem a Resposta da Requisição dos Favoritos
    Map<String, dynamic> jsonFavorites = {};
    if (responseFavorites.statusCode != 200 &&
        responseFavorites.body == 'null') {
      throw (HttpExceptions(
        message: "Houve um Erro ao verificar se o Produto é Favorito",
        statusCode: responseFavorites.statusCode,
        bodyError: responseFavorites.body,
      ));
    } else if (responseFavorites.body != 'null') {
      jsonFavorites = jsonDecode(responseFavorites.body) ?? {};
    }

    // Converte o JSON em Map e Obtem os Itens
    Map<String, dynamic> dataJson = jsonDecode(responseProducts.body);
    dataJson.forEach((productId, productData) {
      bool isFavorite = jsonFavorites[productId] ?? false;
      // Verifica se o Item já está na Lista.
      int index = _listProducts.indexWhere((prod) => prod.id == productId);
      if (index == -1) {
        _listProducts.add(Product.fromMap(productData).copyWith(
          id: productId,
          isFavorite: isFavorite,
        ));
      }
    });

    notifyListeners();
  }

  /// Metodo responsavel por Recarregar a Lista de Produtos
  Future<void> refreshProducts() {
    _listProducts = [];
    return loadedProducts();
  }

  /// Adiciona um Product na Lista e na API
  /// Por ser aync, ele obrigatoriamente tem que retornar um Future. Com isso,  a solicitação na
  /// API, retorna um void de Forma Assincrona.
  Future<void> addProduct(Product product) async {
    // await é utilizado em itens marcados como async. Ele espera o Future ser concluido
    final responseAPI = await http.post(
      Uri.parse(
        "${Urls.urlProducts}.json${Urls.paramAuth}$_token",
      ),
      body: product.copyWith(id: "").toJson(),
    );

    if (responseAPI.statusCode != 200 || responseAPI.body == "null") {
      throw (HttpExceptions(
        message: "Ocorreu um Item ao Salvar o Produto",
        statusCode: responseAPI.statusCode,
        bodyError: responseAPI.body,
      ));
    }

    final String idForFirebase = jsonDecode(responseAPI.body)["name"];
    _listProducts.add(product.copyWith(id: idForFirebase));
    notifyListeners();
  }

  /// Exclui um Product da Lista
  Future<void> deleteProduct(Product product) async {
    int indexProduct =
        _listProducts.indexWhere((itemList) => itemList.id == product.id);
    if (indexProduct >= 0) {
      final Product product = _listProducts.elementAt(indexProduct);

      _listProducts.removeAt(indexProduct);
      notifyListeners();

      final responseAPI = await http.delete(
        Uri.parse(
          "${Urls.urlProducts}/${product.id}.json${Urls.paramAuth}$_token",
        ),
        body: product.copyWith(id: "").toJson(),
      );

      if (responseAPI.statusCode >= 400) {
        _listProducts.add(product);
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
        _listProducts.indexWhere((itemList) => itemList.id == product.id);

    // Inclui ou Atualiza o Produto na Lista
    if (indexProduct < 0) {
      addProduct(product);
    } else {
      await http.patch(
        Uri.parse(
          "${Urls.urlProducts}/${product.id}.json${Urls.paramAuth}$_token",
        ),
        body: product.copyWith(id: "").toJson(),
      );

      _listProducts.removeAt(indexProduct);
      _listProducts.insert(indexProduct, product);
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
