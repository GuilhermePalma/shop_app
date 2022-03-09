import 'package:flutter/material.dart';
import 'package:shop/utils/routes.dart';

class CustomDrawer extends StatelessWidget {
  final String namePage;
  CustomDrawer({Key? key, required this.namePage}) : super(key: key);

  final List<Map<String, Object>> _itemsMenu = [
    {
      "title": "Loja",
      "icon": Icons.shopping_bag_outlined,
      "route": Routes.routeMain,
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
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text("Bem Vindo Usuario"),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ..._itemsMenu.map((item) {
            return ListTile(
              selected: (item["route"] as String) == namePage,
              leading: Icon(item["icon"] as IconData),
              title: Text(item["title"] as String),
              onTap: () => Navigator.of(context).pushReplacementNamed(
                item["route"] as String,
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
