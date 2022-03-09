import 'dart:math';

import 'package:intl/intl.dart';
import 'package:shop/models/entities/cart.dart';

class Order {
  final String id;
  final double total;
  final List<Cart> products;
  final DateTime date;
  Order({
    required this.id,
    required this.total,
    required this.products,
    required this.date,
  });

  /// Gera um ID utilizando o Nome da Classe, Hora Atual, e um Numero Aleatorio
  static String get generateIdItem {
    String dateNowFormated = DateFormat("DDMMy_H_m_s").format(DateTime.now());
    return "order_" + dateNowFormated + Random().nextInt(3999).toString();
  }
}
