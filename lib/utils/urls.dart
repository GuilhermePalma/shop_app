import 'package:shop/utils/protected_const.dart';

class Urls {
  static const String urlProducts =
      "https://app-shop-flutter-default-rtdb.firebaseio.com/products";
  static const String urlOrders =
      "https://app-shop-flutter-default-rtdb.firebaseio.com/orders";
  static const String urlAuth =
      "https://identitytoolkit.googleapis.com/v1/accounts:";
  static const String urlRefreshToken =
      "https://securetoken.googleapis.com/v1/token";
  static const String urFavoriteProducts =
      "https://app-shop-flutter-default-rtdb.firebaseio.com/favorites_products";

  static const String paramSingUpAuth = "signUp";
  static const String paramLoginAuth = "signInWithPassword";
  static const String paramKeyAPIAuth = "?key=";
  static const String paramAuth = "?auth=";

  // TODO: Put Your Firebase API Key in variable "ProtectedConst.apiKey"
  static const String valueApiKey = ProtectedConst.apiKey;
}
