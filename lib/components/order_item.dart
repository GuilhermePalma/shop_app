import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop/models/entities/order.dart';

class OrderItem extends StatefulWidget {
  final Order order;

  const OrderItem({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> with TickerProviderStateMixin {
  bool _isExpanded = false;

  // Variaveis utilizadas no controle da Animação
  AnimationController? _animationController;
  Animation<double>? _opacityAnimation;

  /// Inicializa o COntroller de Animações
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: Curves.linear,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Obtem o Tamanho de Forma Fixa dos Items de uma Compra
    final double _sizeListItem = (widget.order.products.length * 26.0) + 10;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _isExpanded ? _sizeListItem + 80 : 80,
      child: Card(
        child: Column(
          children: [
            ListTile(
              title: Text(
                "R\$ ${widget.order.total.toStringAsFixed(2)}",
              ),
              subtitle: Text(
                DateFormat("dd/MM/yyyy hh:mm").format(widget.order.date),
              ),
              trailing: IconButton(
                icon: Icon(
                  _isExpanded
                      ? Icons.expand_less_rounded
                      : Icons.expand_more_rounded,
                ),
                onPressed: () => setState(() {
                  if (_isExpanded) {
                    _isExpanded = false;
                    _animationController?.reverse();
                  } else {
                    _isExpanded = true;
                    _animationController?.forward();
                  }
                }),
              ),
            ),
            AnimatedContainer(
              height: _isExpanded ? _sizeListItem : 0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.linear,
              child: FadeTransition(
                opacity: _opacityAnimation!,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 4,
                  ),
                  height: _sizeListItem,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
