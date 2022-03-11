import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/http_exceptions.dart';
import 'package:shop/utils/urls.dart';

class AuthProvider with ChangeNotifier {
  /// Metodo Generico Responsavel por Realizar o Cadastro ou Login do Cadastro
  Future<void> _authUser(
    String email,
    String password,
    String urlTypeAuth,
  ) async {
    final responseAPI = await http.post(
      Uri.parse(
        "${Urls.urlAuth}$urlTypeAuth${Urls.paramKeyAuth}${Urls.valueApiKey}",
      ),
      body: jsonEncode({
        "email": email,
        "password": password,
        "returnSecureToken": true,
      }),
    );

    if (responseAPI.statusCode != 200) {
      throw (HttpExceptions(
        message: "Não Foi Possivel Autenticar o Usuario",
        statusCode: responseAPI.statusCode,
        bodyError: responseAPI.body,
      ));
    }
  }

  /// Metodo Responsavel por Cadastrar e Obter o Token do Usuario na API
  Future<void> singUp(String email, String password) async =>
      _authUser(email, password, Urls.paramSingUpAuth);

  // Metodo Responsavel por realizar o Login e Obter o Token do Usuario na API
  Future<void> login(String email, String password) async =>
      _authUser(email, password, Urls.paramLoginAuth);
}
