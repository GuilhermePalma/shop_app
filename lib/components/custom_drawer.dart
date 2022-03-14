import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/providers/auth_provider.dart';
import 'package:shop/pages/orders_page.dart';
import 'package:shop/utils/custom_routes.dart';
import 'package:shop/utils/routes.dart';

class CustomDrawer extends StatelessWidget {
  final String namePage;
  const CustomDrawer({
    Key? key,
    required this.namePage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, Object>> _itemsMenu = [
      {
        "title": "Loja",
        "icon": Icons.shopping_bag_outlined,
        "route": Routes.routeProducts,
      },
      {
        "title": "Pagamentos",
        "icon": Icons.payment_outlined,
        "route": Routes.routeOrders,
      },
      {
        "title": "Gerenciar Produtos",
        "icon": Icons.edit_rounded,
        "route": Routes.routeManagerProducts,
      },
      {
        "title": "Sair",
        "icon": Icons.exit_to_app_rounded,
        "onTap": () => _logout(context),
      },
    ];

    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text("Bem Vindo Usuario"),
            automaticallyImplyLeading: false,
          ),
          ..._itemsMenu.map((item) {
            return item == _itemsMenu.last
                ? const Spacer()
                : _itemMenu(item, context);
          }).toList(),
          const Divider(),
          _itemMenu(_itemsMenu.last, context),
        ],
      ),
    );
  }

  /// Metodo Responsavel por retornar os Itens do Menu Lateral Configurados
  ListTile _itemMenu(Map<String, Object> item, BuildContext context) =>
      ListTile(
        selected: (item["route"] ?? "") == namePage,
        leading: Icon(item["icon"] as IconData),
        title: Text(item["title"] as String),
        onTap: () {
          if (item.containsKey("route")) {
            Navigator.of(context).pushReplacementNamed(
              item["route"] as String,
            );
          } else if (item.containsKey("onTap")) {
            (item["onTap"] as Function).call();
          }
        },
      );

  /// Metodo Responsavel por Remover a Autenticação e Exibir a Tela de Login
  void _logout(BuildContext context) {
    Provider.of<AuthProvider>(context, listen: false).logoutUser();
    Navigator.of(context).pushReplacementNamed(Routes.routeHome);
  }
}
