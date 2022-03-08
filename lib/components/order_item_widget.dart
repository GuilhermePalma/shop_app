import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop/models/order.dart';

class OrderItemWidget extends StatelessWidget {
  final Order order;

  const OrderItemWidget({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text("R\$ ${order.total.toStringAsFixed(2)}"),
        subtitle: Text(DateFormat("dd/MM/yyyy hh:mm").format(order.date)),
        trailing: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.expand_more_rounded),
        ),
      ),
    );
  }
}
