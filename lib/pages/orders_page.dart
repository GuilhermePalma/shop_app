import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/custom_drawer.dart';
import 'package:shop/components/order_item_widget.dart';
import 'package:shop/providers/order_list.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderList>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Meus Pedidos"),
      ),
      drawer: const CustomDrawer(),
      body: ListView.builder(
        itemCount: orderProvider.itemsCount,
        itemBuilder: (ctx, index) =>
            OrderItemWidget(order: orderProvider.items.elementAt(index)),
      ),
    );
  }
}
