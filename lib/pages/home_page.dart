import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/providers/auth_provider.dart';
import 'package:shop/pages/auth_page.dart';
import 'package:shop/pages/products_overview_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of(context);
    return auth.isAuth ? const ProductsOverviewPage() : const AuthPage();
  }
}
