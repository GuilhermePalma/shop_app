import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/cart_item.dart';
import 'package:shop/providers/cart.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;

  const CartItemWidget({
    Key? key,
    required this.cartItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(cartItem.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(vertical: 4),
        color: Theme.of(context).errorColor,
        child: const Icon(
          Icons.delete_rounded,
          color: Colors.white,
          size: 40,
        ),
      ),
      onDismissed: (_) {
        Provider.of<Cart>(
          context,
          listen: false,
        ).removeItem(cartItem.productId);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListTile(
            title: Text(cartItem.nameProduct),
            subtitle: Text(
              "Total: R\$ ${cartItem.priceItem * cartItem.quantityProducts}",
            ),
            trailing: Text("${cartItem.quantityProducts}x"),
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: FittedBox(
                  child: Text("${cartItem.priceItem}"),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
