import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Store {
  /// Chave Utilizada para Salvar Informações do Usuario
  static const String keyUserData = "userData";

  /// Chave Utilizada para Salvar o Refresh Token
  static const String keyRefreshToken = "refreshToken";

  /// Metodo Responsavel por Armazenar Strings nas SharedPreferences
  static Future<bool> saveString(String key, String value) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.setString(key, value);
  }

  /// Metodo Responsavel por Armazenar um Map nas SharedPreferences
  static Future<bool> saveMap(
      String key, Map<String, dynamic> mapValues) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.setString(key, jsonEncode(mapValues));
  }

  /// Metodo Responsavel por Retornar uma String Salva nas SharedPreferences
  static Future<String> getString(String key,
      [String defaultValue = ""]) async {
    final preferences = await SharedPreferences.getInstance();

    // Codifica a String em JSON (se tornando uma String)
    return preferences.getString(key) ?? defaultValue;
  }

  /// Metodo Responsavel por Retornar um Map Salvo nas SharedPreferences
  static Future<Map> getMap(String key) async {
    try {
      // Descodifica o Map que foi Convertida para JSON (se tornando uma String)
      return jsonDecode(await getString(key));
    } catch (_) {
      return {};
    }
  }

  /// Remove um Item das SharedPrefenreces
  static Future<bool> removeItem(String key) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.remove(key);
  }
}
