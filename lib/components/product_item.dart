import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/entities/product.dart';
import 'package:shop/models/providers/cart_provider.dart';
import 'package:shop/utils/routes.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Obtem o Produto pelo Provider, mas desativa a Notificação de Alterações
    final Product productOfProvider = Provider.of<Product>(
      context,
      listen: false,
    );

    final CartProvider cartProvider = Provider.of<CartProvider>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(
            Routes.routeProductDetails,
            arguments: productOfProvider,
          ),
          child: Image.network(
            productOfProvider.imageURL,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset("assets/images/error_404.jpg");
            },
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(
            productOfProvider.name,
            textAlign: TextAlign.center,
          ),
          leading: Consumer<Product>(
            // Insere o Provider no Icone de Favorito, já que só há alteração de estado nele
            builder: (ctx, productItem, _) => IconButton(
              icon: Icon(
                productOfProvider.isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_outline_rounded,
                color: productOfProvider.isFavorite
                    ? Theme.of(context).colorScheme.secondary
                    : Colors.white,
              ),
              onPressed: () => productOfProvider.toggleFavorite(),
            ),
          ),
          trailing: IconButton(
            onPressed: () => cartProvider.addItem(productOfProvider),
            icon: const Icon(
              Icons.shopping_cart_outlined,
            ),
          ),
        ),
      ),
    );
  }
}
