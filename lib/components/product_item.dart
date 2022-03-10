import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/exceptions/http_exceptions.dart';
import 'package:shop/models/entities/product.dart';
import 'package:shop/models/providers/products_provider.dart';
import 'package:shop/utils/routes.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  const ProductItem({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(product.name),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageURL),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.edit_rounded,
                color: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () => Navigator.of(context).pushNamed(
                Routes.routeProductForm,
                arguments: product,
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.delete_rounded,
                color: Theme.of(context).errorColor,
              ),
              onPressed: () => deleteProduct(context),
            ),
          ],
        ),
      ),
    );
  }

  void deleteProduct(BuildContext context) {
    final msg = ScaffoldMessenger.of(context);
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirmar Exclusão"),
        content: Text(
          "Você deseja realmente Excluir o Item \"${product.name}\" ?",
        ),
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
    ).then((confirmDelete) async {
      if (confirmDelete!) {
        try {
          await Provider.of<ProductsProvider>(context, listen: false)
              .deleteProduct(product);
        } on HttpExceptions catch (error) {
          msg.showSnackBar(
            SnackBar(
              content: Text(error.toString()),
            ),
          );
        }
      }
    });
  }
}
