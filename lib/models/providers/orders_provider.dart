import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/http_exceptions.dart';
import 'package:shop/models/entities/order.dart';
import 'package:shop/models/providers/cart_provider.dart';
import 'package:shop/utils/urls.dart';

class OrdersProvider extends ChangeNotifier {
  static const String paramTotal = "totalOrder";
  static const String paramDate = "dateTimeNow";
  static const String paramProducts = "products";

  List<Order> _items = [];

  List<Order> get items => [..._items];

  int get itemsCount => _items.length;

  Future<void> addOrder(CartProvider cart) async {
    final dateNow = DateTime.now();

    final resposneAPI = await http.post(
      Uri.parse("${Urls.urlOrders}.json"),
      body: jsonEncode({
        paramTotal: cart.totalAmout,
        paramDate: dateNow.toIso8601String(),
        paramProducts:
            cart.items.values.map((product) => product.toMap()).toList()
      }),
    );

    if (resposneAPI.statusCode < 400 && resposneAPI.body != "null") {
      final idOrder = jsonDecode(resposneAPI.body)["name"];

      _items.insert(
        0,
        Order(
          id: idOrder,
          total: cart.totalAmout,
          date: dateNow,
          products: cart.items.values.toList(),
        ),
      );

      notifyListeners();
    } else {
      throw (HttpExceptions(
        message: "Não foi Possivel Efetuar a Transação",
        statusCode: resposneAPI.statusCode,
      ));
    }
  }
}
