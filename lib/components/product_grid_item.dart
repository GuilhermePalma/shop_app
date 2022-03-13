import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/entities/product.dart';
import 'package:shop/models/providers/auth_provider.dart';
import 'package:shop/models/providers/cart_provider.dart';
import 'package:shop/utils/routes.dart';

class ProductGridItem extends StatelessWidget {
  const ProductGridItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Obtem o Produto pelo Provider, mas desativa a Notificação de Alterações
    final Product product = Provider.of<Product>(
      context,
      listen: false,
    );

    final CartProvider cartProvider =
        Provider.of<CartProvider>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(
            Routes.routeProductDetails,
            arguments: product,
          ),
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder: const AssetImage(
                "assets/images/product-placeholder.png",
              ),
              image: NetworkImage(product.imageURL),
              fit: BoxFit.cover,
              imageErrorBuilder: (ctx, obj, error) =>
                  Image.asset("assets/images/error_404.jpg"),
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(
            product.name,
            textAlign: TextAlign.center,
          ),
          leading: Consumer<Product>(
            // Insere o Provider no Icone de Favorito, já que só há alteração de estado nele
            builder: (ctx, productItem, _) => IconButton(
              icon: Icon(
                product.isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_outline_rounded,
                color: product.isFavorite
                    ? Theme.of(context).colorScheme.secondary
                    : Colors.white,
              ),
              onPressed: () {
                final provider = Provider.of<AuthProvider>(
                  context,
                  listen: false,
                );

                product.toggleFavorite(
                  provider.getToken ?? "",
                  provider.getUserID ?? "",
                );
              },
            ),
          ),
          trailing: IconButton(
            icon: const Icon(
              Icons.shopping_cart_outlined,
            ),
            onPressed: () {
              cartProvider.addItem(product);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text("Produto Adicionado com Sucesso"),
                  action: SnackBarAction(
                    label: "DESFAZER",
                    onPressed: () => cartProvider.removeSingleItem(product.id),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
