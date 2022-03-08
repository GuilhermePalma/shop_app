import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop/components/cart_item_widget.dart';
import 'package:shop/models/cart_item.dart';
import 'package:shop/models/order.dart';

class OrderItemWidget extends StatefulWidget {
  final Order order;

  const OrderItemWidget({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderItemWidget> createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text("R\$ ${widget.order.total.toStringAsFixed(2)}"),
            subtitle:
                Text(DateFormat("dd/MM/yyyy hh:mm").format(widget.order.date)),
            trailing: IconButton(
              icon: Icon(
                _isExpanded
                    ? Icons.expand_less_rounded
                    : Icons.expand_more_rounded,
              ),
              onPressed: () => setState(() => _isExpanded = !_isExpanded),
            ),
          ),
          if (_isExpanded)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: (widget.order.products.length * 26.0 )+10,
              child: ListView(
                children: widget.order.products.map((product) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.nameProduct,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "R\$ ${product.quantityProducts}x ${product.priceItem}",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
