import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/button_carrt.dart';
import 'package:shop/components/cart_item.dart';
import 'package:shop/exceptions/http_exceptions.dart';
import 'package:shop/models/providers/cart_provider.dart';
import 'package:shop/models/providers/orders_provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CartProvider _cartProvider = Provider.of<CartProvider>(context);
    final _itemsCart = _cartProvider.items.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Carrinho de Compras"),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total",
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 10),
                  Chip(
                    label: Text(
                      "R\$${_cartProvider.totalAmout.toStringAsFixed(2)}",
                      style: TextStyle(
                        color:
                            Theme.of(context).primaryTextTheme.headline6?.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  const Spacer(),
                  ButtonCart(cartProvider: _cartProvider),
                ],
              ),
            ),
          ),
          Expanded(
            child: _cartProvider.itemCount <= 0
                ? const Center(
                    child: Text(
                      "Não Há Itens no Carrinho !",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ListView.builder(
                      itemCount: _cartProvider.itemCount,
                      itemBuilder: (ctx, index) => CartItem(
                        cartItem: _itemsCart.elementAt(index),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  /// Metodo Responsavel por Tratar o Processo de Finalização da
  /// compra dos Itens do Carrinhi
  void onClickBuy(BuildContext context, bool _isEmptyCart,
      CartProvider cartProvider) async {
    String textSnackBar;
    if (_isEmptyCart) {
      textSnackBar = 'Não é possivel realizar uma Compra com o Carrinho Vazio';
    } else {
      try {
        await Provider.of<OrdersProvider>(context, listen: false)
            .addOrder(cartProvider);
        cartProvider.clear();
        textSnackBar = 'Compra Realizada com Sucesso !';
      } on HttpExceptions catch (error) {
        textSnackBar = error.message;
      }
    }

    // Configura e Exibe a Mensagem do SnackBar
    final snackBar = SnackBar(
      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.6),
      content: Text(textSnackBar),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
