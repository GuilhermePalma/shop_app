import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/auth_exceptions.dart';
import 'package:shop/models/entities/store.dart';
import 'package:shop/utils/urls.dart';

class AuthProvider with ChangeNotifier {
  static const String paramEmail = "email";
  static const String paramPassword = "password";
  static const String paramExpirationTime = "expiresIn";
  static const String paramUID = "localId";
  static const String paramToken = "idToken";
  static const String paramRefreshToken = "refreshToken";

  String? _token;
  String? _uid;
  DateTime? _expirationDate;
  String? _email;
  String? _refreshToken;
  Timer? _timerSession;

  /// Verifica se o Token do Usuario está valido
  bool get isAuth {
    final isValidDate = _expirationDate?.isAfter(DateTime.now()) ?? false;
    return _token != null && isValidDate;
  }

  String? get getToken => isAuth ? _token : null;
  String? get getUserID => isAuth ? _uid : null;
  String? get getEmail => isAuth ? _email : null;

  /// Metodo Generico Responsavel por Realizar o Cadastro ou Login do Cadastro
  Future<void> _authUser(String email, String password, String urlTypeAuth,
      bool rememberLogin) async {
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
      _refreshToken = rememberLogin ? jsonData[paramRefreshToken] : "";

      // Armazena os Dados em SharedPreferences
      Store.saveMap(Store.keyUserData, toMap());

      if (rememberLogin) {
        Store.saveString(Store.keyRefreshToken, _refreshToken!);
      }

      _managerSession();
      notifyListeners();
    }
  }

  /// Metodo Responsavel por Tentar Autenticar o Usuario com as Informações Salvas
  Future<void> tryAutoLogin() async {
    if (isAuth) return;

    final _localDataUser = await Store.getMap(Store.keyUserData);
    if (_localDataUser.isEmpty) return;

    // Verifica se o Tempo do Token ainda é valido ou se é necessario um Novo
    final expireDate = DateTime.parse(_localDataUser[paramExpirationTime]);
    if (expireDate.isBefore(DateTime.now())) {
      await _refreshSession();
    } else {
      _token = _localDataUser[paramToken];
      _uid = _localDataUser[paramUID];
      _expirationDate = expireDate;
      _email = _localDataUser[paramEmail];
      _refreshToken = await Store.getString(Store.keyRefreshToken);
      notifyListeners();
    }

    _managerSession();
  }

  /// A partir do Refresh Token, retorna um Token valido com os Dados do Usuario
  Future<void> _refreshSession() async {
    // Obtem o Refresh Token
    final refreshToken = await Store.getString(Store.keyRefreshToken);
    if (refreshToken.isEmpty) return;

    final responseAPI = await http.post(
      Uri.parse(
        "${Urls.urlRefreshToken}${Urls.paramKeyAPIAuth}${Urls.valueApiKey}",
      ),
      body: jsonEncode({
        "grant_type": "refresh_token",
        "refresh_token": refreshToken,
      }),
    );

    if (responseAPI.statusCode != 200 || responseAPI.body == "null") return;

    final Map<String, dynamic> newDataUser = jsonDecode(responseAPI.body);
    _token = newDataUser["id_token"];
    _email = newDataUser[paramEmail];
    _uid = newDataUser["user_id"];
    _expirationDate = DateTime.now().add(
      Duration(seconds: int.tryParse(newDataUser["expires_in"]) ?? 0),
    );

    _refreshToken = newDataUser["refresh_token"];

    // Armazena os Dados em SharedPreferences
    Store.saveMap(Store.keyUserData, toMap());
    Store.saveString(Store.keyRefreshToken, _refreshToken!);

    notifyListeners();
  }

  /// Metodo Responsavel por Renovar o Token ou realizar o Logout do APP
  void _managerSession() {
    _clearLogoutTimer();
    final timeToLogout =
        _expirationDate?.difference(DateTime.now()).inSeconds ?? 0;

    _timerSession = Timer(Duration(seconds: timeToLogout), () async {
      // Verifica se o Token está salvo (Opção Lembrar Login)
      Store.getString(Store.keyRefreshToken).then(
        (token) => token.isNotEmpty ? _refreshSession() : logoutUser(),
      );
    });
  }

  /// Metodo Responsavel por Cadastrar e Obter o Token do Usuario na API
  Future<void> singUp(String email, String password,
          [bool rememberLogin = false]) async =>
      _authUser(email, password, Urls.paramSingUpAuth, rememberLogin);

  // Metodo Responsavel por realizar o Login e Obter o Token do Usuario na API
  Future<void> login(String email, String password,
          [bool rememberLogin = false]) async =>
      _authUser(email, password, Urls.paramLoginAuth, rememberLogin);

  /// Metodo Responsavel por Reiniciar o Timer
  void _clearLogoutTimer() {
    _timerSession?.cancel();
    _timerSession = null;
  }

  /// Metodo Responsavel por Fazer o Logout do Usuario
  void logoutUser() {
    _clearLogoutTimer();
    _token = null;
    _uid = null;
    _expirationDate = null;
    _email = null;

    // Limpa as SharedPreferences e Notifica as Alterações para o APP
    Store.removeItem(Store.keyUserData)
        .then((_) => Store.removeItem(Store.keyRefreshToken))
        .then((_) => notifyListeners());
  }

  /// Metodo que Permite gerar um Map a Partir dos Atributos dessa Classe
  Map<String, Object> toMap() => {
        paramToken: _token ?? "",
        paramEmail: _email ?? "",
        paramUID: _uid ?? "",
        paramExpirationTime: _expirationDate?.toIso8601String() ?? "",
      };

}
