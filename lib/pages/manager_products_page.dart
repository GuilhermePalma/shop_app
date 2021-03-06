import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/custom_drawer.dart';
import 'package:shop/components/product_item.dart';
import 'package:shop/exceptions/http_exceptions.dart';
import 'package:shop/models/entities/product.dart';
import 'package:shop/models/providers/products_provider.dart';
import 'package:shop/utils/routes.dart';

class ManagerProductsPage extends StatelessWidget {
  const ManagerProductsPage({Key? key}) : super(key: key);

  /// Metodo Responsavel por Exibir um AlertDialog de Erro
  void _showErrorDialog(BuildContext context, String massage) {
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

  /// Metodo Responsavel por Sincronizar os Produtos
  Future<void> _onRefreshProducts(BuildContext context) async {
    try {
      Provider.of<ProductsProvider>(context, listen: false).refreshProducts();
    } on HttpExceptions catch (error) {
      _showErrorDialog(context, error.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Product> productsList =
        Provider.of<ProductsProvider>(context).productsList;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Gerenciar Produtos"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () =>
                Navigator.of(context).pushNamed(Routes.routeProductForm),
          ),
        ],
      ),
      drawer: const CustomDrawer(namePage: Routes.routeManagerProducts),
      body: RefreshIndicator(
        onRefresh: () => _onRefreshProducts(context),
        child: ListView.builder(
          itemCount: productsList.length,
          itemBuilder: (ctx, index) => Column(
            children: [
              ProductItem(product: productsList.elementAt(index)),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Divider(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
