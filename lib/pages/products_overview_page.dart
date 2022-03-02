import 'package:flutter/material.dart';
import 'package:shop/components/product_item.dart';
import 'package:shop/data/dummy_data.dart';
import 'package:shop/models/product.dart';

class ProductsOverviewPage extends StatelessWidget {
  ProductsOverviewPage({Key? key}) : super(key: key);

  final List<Product> loadedProducts = dummyProducts;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Minha Loja"),
      ),
      body: GridView.builder(
        itemCount: loadedProducts.length,
        padding: const EdgeInsets.all(10.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Elementos por Linha
          childAspectRatio: 3 / 2, // Relação Entra Altura e Largura
          crossAxisSpacing: 10, // Espaço entre os Elementos (Horizontal -)
          mainAxisSpacing: 10, // Espaço entre os Elementos (Vertical |)
        ),
        itemBuilder: (ctx, index) =>
            ProductItem(product: loadedProducts.elementAt(index)),
      ),
    );
  }
}
