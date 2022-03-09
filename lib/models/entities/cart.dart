import 'dart:math';

import 'package:intl/intl.dart';

class Cart {
  final String id;
  final String productId;
  final String nameProduct;
  final int quantityProducts;
  final double priceItem;

  Cart({
    required this.id,
    required this.productId,
    required this.nameProduct,
    required this.quantityProducts,
    required this.priceItem,
  });

  /// Gera um ID utilizando o Nome da Classe, Hora Atual, e um Numero Aleatorio
  static String get generateIdItem {
    String dateNowFormated = DateFormat("DDMMy_H_m_s").format(DateTime.now());
    return "cart_" + dateNowFormated + Random().nextInt(3999).toString();
  }
}
