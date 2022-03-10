import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/http_exceptions.dart';
import 'package:shop/models/entities/order.dart';
import 'package:shop/models/providers/cart_provider.dart';
import 'package:shop/utils/urls.dart';

class OrdersProvider extends ChangeNotifier {
  List<Order> _items = [];

  /// Retorna a Lista de Order
  List<Order> get items => [..._items];

  /// Retorna o Tamanho da Lista de Order
  int get itemsCount => _items.length;

  /// Adiciona uma Order na Lista e na API
  Future<void> addOrder(CartProvider cart) async {
    Order order = Order.fromCart(cart);

    final responseAPI = await http.post(
      Uri.parse("${Urls.urlOrders}.json"),
      body: order.toJson(),
    );

    if (responseAPI.statusCode < 400 && responseAPI.body != "null") {
      final idOrder = jsonDecode(responseAPI.body)["name"];

      _items.insert(0, order.copyWith(id: idOrder));
      notifyListeners();
    } else {
      throw (HttpExceptions(
        message: "Não foi Possivel Efetuar a Transação",
        statusCode: responseAPI.statusCode,
      ));
    }
  }

  /// Metodo responsavel por obter as Orders da API
  Future<void> loadedOrders() async {
    final responseAPI = await http.get(Uri.parse("${Urls.urlOrders}.json"));

    if (responseAPI.statusCode < 400 && responseAPI.body != "null") {
      Map<String, dynamic> dataJson = jsonDecode(responseAPI.body);
      dataJson.forEach((id, valueOrder) {
        _items.add(Order.fromMap(valueOrder).copyWith(id: id));
      });

      notifyListeners();
    } else {
      throw (HttpExceptions(
        message: "Não foi Possivel Obter as Transações",
        statusCode: responseAPI.statusCode,
      ));
    }
  }

  /// Metodo responsavel por Recarregar a Lista de Orders
  Future<void> refreshOrders() {
    _items = [];
    return loadedOrders();
  }
}
