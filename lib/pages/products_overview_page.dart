import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/badge.dart';
import 'package:shop/components/custom_drawer.dart';
import 'package:shop/components/loading_widget.dart';
import 'package:shop/components/product_grid.dart';
import 'package:shop/exceptions/http_exceptions.dart';
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
  ProductsProvider? productsProvider;

  @override
  void initState() {
    super.initState();

    productsProvider = Provider.of<ProductsProvider>(context, listen: false);

    // Somente Obtem os Itens, caso a Lista esteja Vazia
    if (productsProvider!.itemsCount == 0) {
      productsProvider!
          .loadedProducts()
          .then((_) => setState(() => _isLoading = false));
    } else {
      setState(() => _isLoading = false);
    }
  }

  /// Metodo Responsavel por Exibir um AlertDialog de Erro
  void _showErrorDialog(String massage) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Ocorreu um Erro"),
        content: Text(massage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  /// Metodo Responsavel por Sinctronizar as Transações
  Future<void> _onRefreshProducts(BuildContext context) async {
    try {
      productsProvider!.refreshProducts();
    } on HttpExceptions catch (error) {
      _showErrorDialog(error.message);
    }
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
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                Navigator.of(context).pushNamed(Routes.routeCartPage);
              },
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
      drawer: const CustomDrawer(namePage: Routes.routeProducts),
      body: _isLoading
          ? const LoadingWidget()
          : RefreshIndicator(
              onRefresh: () => _onRefreshProducts(context),
              child: ProductGrid(showFavoriteOnly: _showFavoritesOnly),
            ),
    );
  }
}
