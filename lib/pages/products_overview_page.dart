import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/badge.dart';
import 'package:shop/components/custom_drawer.dart';
import 'package:shop/components/loading_widget.dart';
import 'package:shop/components/product_grid.dart';
import 'package:shop/models/providers/cart_provider.dart';
import 'package:shop/models/providers/products_provider.dart';
import 'package:shop/utils/routes.dart';

/// Enumeração com as Opções do Menu Superior
enum FilterOptions {
  favorite,
  all,
}

class ProductsOverviewPage extends StatefulWidget {
  const ProductsOverviewPage({Key? key}) : super(key: key);

  @override
  State<ProductsOverviewPage> createState() => _ProductsOverviewPageState();
}

class _ProductsOverviewPageState extends State<ProductsOverviewPage> {
  bool _showFavoritesOnly = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<ProductsProvider>(context, listen: false)
        .loadedProducts()
        .then((_) => setState(() => _isLoading = false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Minha Loja"),
        actions: [
          Consumer<CartProvider>(
            // Child define um Item Imutavel
            child: IconButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(Routes.routeCartPage),
              icon: const Icon(Icons.shopping_cart_rounded),
            ),
            // Constroi um Widget que pode sofrer alterações
            builder: (ctx, cart, child) => Badge(
              value: cart.itemCount.toString(),
              child: child!,
            ),
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert_rounded),
            itemBuilder: (_) => [
              const PopupMenuItem(
                child: Text("Todos"),
                value: FilterOptions.all,
              ),
              const PopupMenuItem(
                child: Text("Somente Favoritos"),
                value: FilterOptions.favorite,
              ),
            ],
            onSelected: (FilterOptions selectedValue) {
              setState(() =>
                  _showFavoritesOnly = selectedValue == FilterOptions.favorite);
            },
          ),
        ],
      ),
      drawer: CustomDrawer(namePage: Routes.routeMain),
      body: _isLoading
          ? const LoadingWidget()
          : ProductGrid(showFavoriteOnly: _showFavoritesOnly),
    );
  }
}
