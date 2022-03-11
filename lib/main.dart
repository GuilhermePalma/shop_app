import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/providers/auth_provider.dart';
import 'package:shop/pages/auth_page.dart';
import 'package:shop/pages/cart_page.dart';
import 'package:shop/pages/home_page.dart';
import 'package:shop/pages/manager_products_page.dart';
import 'package:shop/pages/orders_page.dart';
import 'package:shop/pages/product_details_page.dart';
import 'package:shop/pages/product_form_page.dart';
import 'package:shop/pages/products_overview_page.dart';
import 'package:shop/models/providers/cart_provider.dart';
import 'package:shop/models/providers/orders_provider.dart';
import 'package:shop/models/providers/products_provider.dart';
import 'package:shop/utils/routes.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(
          create: (_) => ProductsProvider(token: "", listProducts: []),
          update: (ctx, authProvider, previous) => ProductsProvider(
            token: authProvider.getToken ?? "",
            listProducts: previous?.productsList ?? [],
          ),
        ),
        ChangeNotifierProxyProvider<AuthProvider, OrdersProvider>(
          create: (_) => OrdersProvider(token: "", listOrders: []),
          update: (ctx, authProvider, previous) => OrdersProvider(
            token: authProvider.getToken ?? "",
            listOrders: previous?.items ?? [],
          ),
        ),
        ChangeNotifierProvider(create: (_) => CartProvider()),
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
          Routes.routeHome: (ctx) => const HomePage(),
          Routes.routeAuth: (ctx) => const AuthPage(),
          Routes.routeProducts: (ctx) => const ProductsOverviewPage(),
          Routes.routeProductDetails: (ctx) => const ProductDetailsPage(),
          Routes.routeCartPage: (ctx) => const CartPage(),
          Routes.routeOrders: (ctx) => const OrdersPage(),
          Routes.routeManagerProducts: (ctx) => const ManagerProductsPage(),
          Routes.routeProductForm: (ctx) => const ProductFormPage(),
        },
        initialRoute: Routes.routeHome,
      ),
    );
  }
}
