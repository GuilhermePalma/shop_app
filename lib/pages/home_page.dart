import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/loading_widget.dart';
import 'package:shop/models/providers/auth_provider.dart';
import 'package:shop/pages/auth_page.dart';
import 'package:shop/pages/products_overview_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of(context);
    // Verifica se o Usuario possui um Token Valido Salvo
    return FutureBuilder(
      future: auth.tryAutoLogin(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingWidget();
        } else if (snapshot.error != null) {
          return const Scaffold(
            body: Center(
              child: Text(
                "Occoreu um Erro. Tente Novamente !",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          );
        } else {
          return auth.isAuth ? const ProductsOverviewPage() : const AuthPage();
        }
      },
    );
  }
}
