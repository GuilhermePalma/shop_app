import 'dart:convert';

class AuthExceptions implements Exception {
  /// Nome do Parametro que contem a Key de Error
  static const String paramError = "error";
  static const String paramMessageErrorKey = "message";
  static const String paramStatusCode = "code";

  static const Map<String, String> errorsAuth = {
    // Erros Possiveis de Cadastro
    "EMAIL_EXISTS": "E-mail já Cadastrado.",
    "OPERATION_NOT_ALLOWED": "Operação não Permitida.",
    "TOO_MANY_ATTEMPTS_TRY_LATER":
        "Acesso Temporariamente Bloqueado. Tente Novamente mais Tarde.",
    // Erros Possiveis de Login
    "EMAIL_NOT_FOUND": "O E-mail Informado não Possui um Cadastro.",
    "INVALID_PASSWORD": "Senha Invalida.",
    "USER_DISABLED": "Esse Usuario foi Desativado.",
    // Erros Gerais
    "INVALID_EMAIL": "O Email Informado é Invalido"
  };

  final String keyError;
  final int statusCode;

  AuthExceptions({
    required this.keyError,
    required this.statusCode,
  });

  String get getMessageError => errorsAuth[keyError] ?? "Erro não Identificado";

  /// Obtem a Chave de Erro do Body do JSON
  static AuthExceptions fromJSON(String? json) {
    String _json = json ?? "";

    AuthExceptions emptyClass = AuthExceptions(keyError: "", statusCode: 0);

    if (_json == "" || _json == "null") return emptyClass;

    Map<String, dynamic> jsonMap = jsonDecode(_json);

    if (!jsonMap.containsKey(paramError)) return emptyClass;

    bool constainsValues =
        jsonMap[paramError].containsKey(paramMessageErrorKey) &&
            jsonMap[paramError].containsKey(paramStatusCode);

    return constainsValues
        ? AuthExceptions(
            keyError: jsonMap[paramError][paramMessageErrorKey]!,
            statusCode: jsonMap[paramError][paramStatusCode]!,
          )
        : emptyClass;
  }

  @override
  String toString() {
    return "Error Status Code: $statusCode\nKey Error: $keyError\nMessage Error: $getMessageError";
  }
}
