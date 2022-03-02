import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/product_item.dart';
import 'package:shop/models/product.dart';
import 'package:shop/providers/product_list.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductList>(context);
    final List<Product> loadedProducts = provider.productsList;

    return GridView.builder(
      itemCount: loadedProducts.length,
      padding: const EdgeInsets.all(10.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Elementos por Linha
        childAspectRatio: 3 / 2, // Relação Entra Altura e Largura
        crossAxisSpacing: 10, // Espaço entre os Elementos (Horizontal -)
        mainAxisSpacing: 10, // Espaço entre os Elementos (Vertical |)
      ),
      itemBuilder: (ctx, index) {
        /* ChangeNotifierProvider utiliza do Provider já criado para
            gerenciar Alterações no Product */
        return ChangeNotifierProvider.value(
          value: loadedProducts.elementAt(index),
          child: const ProductItem(),
        );
      },
    );
  }
}
