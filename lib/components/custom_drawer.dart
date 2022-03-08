import 'package:flutter/material.dart';
import 'package:shop/utils/routes.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

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
          ListTile(
            leading: const Icon(Icons.shopping_bag_outlined),
            title: const Text("Loja"),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(Routes.routeMain);
            },
          ),
          ListTile(
            leading: const Icon(Icons.payment_outlined),
            title: const Text("Pagamentos"),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(Routes.routeOrders);
            },
          ),
        ],
      ),
    );
  }
}
