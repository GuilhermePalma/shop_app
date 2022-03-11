import 'package:shop/utils/protected_const.dart';

class Urls {
  static const String urlProducts =
      "https://app-shop-flutter-default-rtdb.firebaseio.com/products";
  static const String urlOrders =
      "https://app-shop-flutter-default-rtdb.firebaseio.com/orders";
  static const String urlSingUp =
      "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=";

  // TODO: Create a File "protected_const.dart" and Class "ProtectedConst" and
  // Put Your Firebase API Key in variable "ConstFirebase.apiKey"
  static const String apiKey = ProtectedConst.apiKey;
}
