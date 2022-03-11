class HttpExceptions implements Exception {
  final String message;
  final int statusCode;
  final String? bodyError;

  HttpExceptions({
    required this.message,
    required this.statusCode,
    this.bodyError,
  });

  @override
  String toString() =>
      "Status Code: $statusCode\nError Message: $message\nBody Error: $bodyError";

  /// Obtem a Mensagem de Erro da Exceção
  String get getMessage => message;
}
