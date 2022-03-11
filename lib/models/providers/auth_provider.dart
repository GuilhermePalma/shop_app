import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/http_exceptions.dart';
import 'package:shop/utils/urls.dart';

class AuthProvider with ChangeNotifier {

  /// Metodo Responsavel por Cadastrar e Obter o Token do Usuario na API
  Future<void> singUp(String email, String password) async {
    final responseAPI = await http.post(
      Uri.parse("${Urls.urlSingUp}${Urls.apiKey}"),
      body: jsonEncode({
        "email": email,
        "password": password,
        "returnSecureToken": true,
      }),
    );

    if (responseAPI.statusCode != 200) {
      throw (HttpExceptions(
        message: "Não Foi Possivel Cadatrar o Usuario",
        statusCode: responseAPI.statusCode,
      ));
    }
  }

  // Metodo Responsavel por realizar o Login e Obter o Token do Usuario na API
  Future<void> login(String email, String password) async {}
}
