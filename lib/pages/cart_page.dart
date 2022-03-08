import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/cart_item.dart';
import 'package:shop/models/providers/cart_provider.dart';
import 'package:shop/models/providers/orders_provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CartProvider _cartProvider = Provider.of<CartProvider>(context);
    final _itemsCart = _cartProvider.items.values.toList();

    final bool _isEmptyCart = _cartProvider.itemCount <= 0;

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
                  TextButton(
                    onPressed: () {
                      if (_isEmptyCart) {
                        /// Configura e exibe a SnackBAr
                        final snackBar = SnackBar(
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.6),
                          content: const Text(
                            'Não é possivel realizar uma Compra com o Carrinho Vazio',
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        Provider.of<OrdersProvider>(context, listen: false)
                            .addOrder(_cartProvider);
                        _cartProvider.clear();
                      }
                    },
                    child: const Text("COMPRAR"),
                    style: TextButton.styleFrom(
                      textStyle: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _isEmptyCart
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
}
