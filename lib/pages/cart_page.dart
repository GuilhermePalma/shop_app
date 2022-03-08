import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/cart_item_widget.dart';
import 'package:shop/providers/cart.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Cart cartProvider = Provider.of<Cart>(context);
    final itemsCart = cartProvider.items.values.toList();

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
                      "R\$${cartProvider.totalAmout}",
                      style: TextStyle(
                        color:
                            Theme.of(context).primaryTextTheme.headline6?.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {},
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
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView.builder(
                itemCount: cartProvider.itemCount,
                itemBuilder: (ctx, index) => CartItemWidget(
                  cartItem: itemsCart.elementAt(index),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
