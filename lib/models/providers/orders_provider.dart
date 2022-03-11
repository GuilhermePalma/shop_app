import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/http_exceptions.dart';
import 'package:shop/models/entities/order.dart';
import 'package:shop/models/providers/cart_provider.dart';
import 'package:shop/utils/urls.dart';

class OrdersProvider extends ChangeNotifier {
  /// Token Usado nas Requisições
  final String _token;

  /// Lista que armazena as Orders
  List<Order> _listOrders = [];

  OrdersProvider({
    required String token,
    required List<Order> listOrders,
  })  : _token = token,
        _listOrders = listOrders;

  /// Retorna a Lista de Order
  List<Order> get items => [..._listOrders];

  /// Retorna o Tamanho da Lista de Order
  int get itemsCount => _listOrders.length;

  /// Adiciona uma Order na Lista e na API
  Future<void> addOrder(CartProvider cart) async {
    Order order = Order.fromCart(cart);

    final responseAPI = await http.post(
      Uri.parse(
        "${Urls.urlOrders}.json${Urls.paramAuth}$_token",
      ),
      body: order.toJson(),
    );

    if (responseAPI.statusCode < 400 && responseAPI.body != "null") {
      final idOrder = jsonDecode(responseAPI.body)["name"];

      _listOrders.insert(0, order.copyWith(id: idOrder));
      notifyListeners();
    } else {
      throw (HttpExceptions(
        message: "Não foi Possivel Efetuar a Transação",
        statusCode: responseAPI.statusCode,
        bodyError: responseAPI.body,
      ));
    }
  }

  /// Metodo responsavel por obter as Orders da API
  Future<void> loadedOrders() async {
    final responseAPI = await http.get(
      Uri.parse(
        "${Urls.urlOrders}.json${Urls.paramAuth}$_token",
      ),
    );

    if (responseAPI.statusCode < 400 && responseAPI.body != "null") {
      List<Order> listOrders = [];
      Map<String, dynamic> dataJson = jsonDecode(responseAPI.body);
      dataJson.forEach((id, valueOrder) {
        listOrders.add(Order.fromMap(valueOrder).copyWith(id: id));
      });

      // Mantem sempre o Item mais Atual na Parte Superior
      _listOrders = listOrders.reversed.toList();
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
    _listOrders = [];
    return loadedOrders();
  }
}
