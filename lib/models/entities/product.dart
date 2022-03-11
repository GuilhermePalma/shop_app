import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/http_exceptions.dart';
import 'package:shop/utils/urls.dart';

class Product with ChangeNotifier {
  static const String paramID = "id";
  static const String paramName = "name";
  static const String paramDescription = "description";
  static const String paramPrice = "price";
  static const String paramImageURL = "imageURL";
  static const String paramIsFavorite = "isFavorite";

  final String id;
  final String name;
  final String description;
  final double price;
  final String imageURL;
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageURL,
    this.isFavorite = false,
  });

  /// Altera o valor de Favorito do Produto
  void _toggleVarFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  /// Metodo Responsavel por Alterar Controlar a Mudança de Favorito na API
  Future<void> toggleFavorite(String token, String userUID) async {
    try {
      _toggleVarFavorite();

      final Uri uriRequuest = Uri.parse(
        "${Urls.urFavoriteProducts}/$userUID/$id.json${Urls.paramAuth}$token",
      );
      final responseAPI = isFavorite
          ? await http.put(uriRequuest, body: jsonEncode(isFavorite))
          : await http.delete(uriRequuest);

      // Verifica se foi bem Sucedido
      if (responseAPI.statusCode >= 400) {
        _toggleVarFavorite();
        throw (HttpExceptions(
          message: "Houve um Erro ao Favoritar o Produto",
          statusCode: responseAPI.statusCode,
        ));
      }
    } catch (_) {
      _toggleVarFavorite();
    }
  }

  /// Realiza a Validação do Nome, Retornando a String de Erro ou Nulo
  static String? validateName(String? name) {
    final String _name = name ?? "";
    if (_name.trim().isEmpty) {
      return "O Nome é Obrigatorio";
    } else if (_name.trim().length < 8) {
      return "O Nome Precisa ter no minimo 8 Letras";
    } else {
      return null;
    }
  }

  /// Realiza a Validação da Descrição, Retornando a String de Erro ou Nulo
  static String? validateDescription(String? description) {
    final String _description = description ?? "";
    if (_description.trim().isEmpty) {
      return "A Descrição é Obrigatoria";
    } else if (_description.trim().length < 10) {
      return "A Descrição Precisa ter no minimo 10 Letras";
    } else {
      return null;
    }
  }

  /// Realiza a Validação do Preço, Retornando a String de Erro ou Nulo
  static String? validatePrice(String? price) {
    final double _price = double.tryParse(price ?? "-1.0") ?? -1.0;
    if (_price == -1) {
      return "O Preço é Obrigatorio";
    } else if (_price <= 0) {
      return "Informe um Preço Valido";
    } else {
      return null;
    }
  }

  /// Realiza a Validação da URL da Imagem, Retornando a String de Erro ou Nulo
  static String? validateImageURL(String? imageURL) {
    final String _url = imageURL ?? "";

    if (_url.trim().isEmpty) {
      return "URL da Imagem é Obrigatoria";
    } else if (_url.trim().length < 10) {
      return "A URL Precisa ter no minimo 10 Caracteres";
    }
    bool isValidUrl = Uri.tryParse(_url)?.hasAbsolutePath ?? false;
    if (!isValidUrl) {
      return "A URL Informada não é Valida";
    } else {
      return null;
    }
  }

  /// Metodo que copia e permite alterações nos Atributos do Produto, retornando
  /// uma nova Instancia de Product
  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageURL,
    bool? isFavorite,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageURL: imageURL ?? this.imageURL,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  /// Metodo que Permite gerar um Map a Partir de um Product
  Map<String, dynamic> toMap() {
    return {
      if (id.trim().isNotEmpty) paramID: id,
      paramName: name,
      paramDescription: description,
      paramPrice: price,
      paramImageURL: imageURL,
    };
  }

  /// Metodo que Retorna uma Instancia de Product a partir de um Map
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map[paramID] ?? '',
      name: map[paramName] ?? '',
      description: map[paramDescription] ?? '',
      price: double.tryParse(map[paramPrice]?.toString() ?? "0.0") ?? 0.0,
      imageURL: map[paramImageURL] ?? '',
      isFavorite: map[paramIsFavorite] ?? false,
    );
  }

  /// Transfroma um Product em um Map e Converte em JSON
  String toJson() => json.encode(toMap());

  /// Converte um JSON que está em um Map para um Product
  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));

  /// Metodo Responsavel por Transformar os Dados do Product em String
  @override
  String toString() =>
      'Product(id: $id, name: $name, description: $description, price: $price, imageURL: $imageURL, isFavorite: $isFavorite)';
}
