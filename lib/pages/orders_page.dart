import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/custom_drawer.dart';
import 'package:shop/components/order_item.dart';
import 'package:shop/models/providers/orders_provider.dart';
import 'package:shop/utils/routes.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrdersProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Meus Pedidos"),
      ),
      drawer: CustomDrawer(namePage: Routes.routeOrders),
      body: orderProvider.itemsCount <= 0
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Não Foi encontrado nenhum Historico de Pagamentos !",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Adicione Itens no Carrinho e Realize a Compra",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: orderProvider.itemsCount,
              itemBuilder: (ctx, index) =>
                  OrderItem(order: orderProvider.items.elementAt(index)),
            ),
    );
  }
}
