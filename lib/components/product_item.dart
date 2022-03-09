import 'package:flutter/material.dart';
import 'package:shop/models/entities/product.dart';

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
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                Icons.delete_rounded,
                color: Theme.of(context).errorColor,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
