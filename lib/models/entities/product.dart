import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Product with ChangeNotifier {
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
  void toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
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

  /// Gera um ID utilizando o Nome da Classe, Hora Atual, e um Numero Aleatorio
  static String get generateIdItem {
    String dateNowFormated = DateFormat("DDMMy_H_m_s").format(DateTime.now());
    return "product_" + dateNowFormated + Random().nextInt(3999).toString();
  }
}
