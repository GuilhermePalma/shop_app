import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/custom_drawer.dart';
import 'package:shop/components/product_item.dart';
import 'package:shop/models/entities/product.dart';
import 'package:shop/models/providers/products_provider.dart';
import 'package:shop/utils/routes.dart';

class ManagerProductsPage extends StatelessWidget {
  const ManagerProductsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Product> productsList =
        Provider.of<ProductsProvider>(context).productsList;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Gerenciar Produtos"),
      ),
      drawer: CustomDrawer(namePage: Routes.routeManagerProducts),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: productsList.length,
          itemBuilder: (ctx, index) => Column(
            children: [
              ProductItem(product: productsList.elementAt(index)),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
