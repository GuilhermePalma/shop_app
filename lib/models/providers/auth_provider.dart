import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/auth_exceptions.dart';
import 'package:shop/utils/urls.dart';

class AuthProvider with ChangeNotifier {
  static const String paramEmail = "email";
  static const String paramPassword = "password";
  static const String paramExpirationTime = "expiresIn";
  static const String paramUID = "localId";
  static const String paramToken = "idToken";

  String? _token;
  String? _uid;
  DateTime? _expirationDate;
  String? _email;

  bool get isAuth {
    final isValidDate = _expirationDate?.isAfter(DateTime.now()) ?? false;
    return _token != null && isValidDate;
  }

  String? get getToken => isAuth ? _token : null;
  String? get getUID => isAuth ? _uid : null;
  String? get getEmail => isAuth ? _email : null;

  /// Metodo Generico Responsavel por Realizar o Cadastro ou Login do Cadastro
  Future<void> _authUser(
    String email,
    String password,
    String urlTypeAuth,
  ) async {
    final responseAPI = await http.post(
      Uri.parse(
        "${Urls.urlAuth}$urlTypeAuth${Urls.paramKeyAPIAuth}${Urls.valueApiKey}",
      ),
      body: jsonEncode({
        paramEmail: email,
        paramPassword: password,
        "returnSecureToken": true,
      }),
    );

    if (responseAPI.statusCode != 200) {
      throw (AuthExceptions.fromJSON(responseAPI.body));
    } else {
      Map<String, dynamic> jsonData = jsonDecode(responseAPI.body);
      _token = jsonData[paramToken];
      _uid = jsonData[paramUID];
      _expirationDate = DateTime.now().add(
        Duration(seconds: int.tryParse(jsonData[paramExpirationTime]) ?? 0),
      );
      _email = jsonData[paramEmail];
      notifyListeners();
    }
  }

  /// Metodo Responsavel por Cadastrar e Obter o Token do Usuario na API
  Future<void> singUp(String email, String password) async =>
      _authUser(email, password, Urls.paramSingUpAuth);

  // Metodo Responsavel por realizar o Login e Obter o Token do Usuario na API
  Future<void> login(String email, String password) async =>
      _authUser(email, password, Urls.paramLoginAuth);
}
