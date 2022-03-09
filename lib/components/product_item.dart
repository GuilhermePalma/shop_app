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
              icon: const Icon(Icons.edit_rounded),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.delete_rounded),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
