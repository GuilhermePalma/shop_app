import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product.dart';
import 'package:shop/utils/routes.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Obtem o Produto pelo Provider
    final Product product = Provider.of<Product>(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(
            Routes.routeProductDetails,
            arguments: product,
          ),
          child: Image.network(
            product.imageURL,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset("assets/images/error_404.jpg");
            },
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(
            product.name,
            textAlign: TextAlign.center,
          ),
          leading: IconButton(
              icon: Icon(
                product.isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_outline_rounded,
                color: product.isFavorite
                    ? Theme.of(context).colorScheme.secondary
                    : Colors.white,
              ),
              onPressed: () => product.toggleFavorite()),
          trailing: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.shopping_cart_outlined,
            ),
          ),
        ),
      ),
    );
  }
}
