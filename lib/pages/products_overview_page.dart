import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/product_grid.dart';
import 'package:shop/providers/product_list.dart';

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

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductList>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Minha Loja"),
        actions: [
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
      body: ProductGrid(showFavoriteOnly: _showFavoritesOnly),
    );
  }
}
