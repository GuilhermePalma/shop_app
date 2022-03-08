import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/pages/cart_page.dart';
import 'package:shop/pages/product_details_page.dart';
import 'package:shop/pages/products_overview_page.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/order_list.dart';
import 'package:shop/providers/product_list.dart';
import 'package:shop/utils/routes.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductList()),
        ChangeNotifierProvider(create: (_) => Cart()),
        ChangeNotifierProvider(create: (_) => OrderList()),
      ],
      child: MaterialApp(
        title: 'Shop APP',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: "Lato",
          colorScheme: const ColorScheme.light(primary: Colors.purple)
              .copyWith(secondary: Colors.deepOrange),
        ),
        routes: {
          Routes.routeMain: (ctx) => const ProductsOverviewPage(),
          Routes.routeProductDetails: (ctx) => const ProductDetailsPage(),
          Routes.routeCartPage: (ctx) => const CartPage(),
        },
        initialRoute: Routes.routeMain,
      ),
    );
  }
}
