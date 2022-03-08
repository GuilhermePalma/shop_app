import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/product_item.dart';
import 'package:shop/models/entities/product.dart';
import 'package:shop/models/providers/products_provider.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavoriteOnly;

  const ProductGrid({
    Key? key,
    required this.showFavoriteOnly,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductsProvider>(context);
    final List<Product> loadedProducts = showFavoriteOnly
        ? provider.productsFavoritesList
        : provider.productsList;

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
          // Sem o const no Contrutor para não dar erro na Listagem Dinamica
          // ignore: prefer_const_constructors
          child: ProductItem(),
        );
      },
    );
  }
}
