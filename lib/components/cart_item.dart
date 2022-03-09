import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/entities/cart.dart';
import 'package:shop/models/providers/cart_provider.dart';

class CartItem extends StatelessWidget {
  final Cart cartItem;

  const CartItem({
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
        Provider.of<CartProvider>(
          context,
          listen: false,
        ).removeItem(cartItem.productId);
      },

      /// Retorna um evento Futuro (Booleano)
      confirmDismiss: (_) {
        /// Retorna um Dialog confirmando ou não a Exclusão
        return showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Confirmar Exclusão"),
            content: const Text("Você deseja exlcuir o Item do Carrinho ?"),
            actions: [
              TextButton(
                child: const Text("Não Excluir"),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              TextButton(
                child: const Text("Excluir"),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          ),
        );
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
