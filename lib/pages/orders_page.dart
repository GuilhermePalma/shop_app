import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/custom_drawer.dart';
import 'package:shop/components/loading_widget.dart';
import 'package:shop/components/order_item.dart';
import 'package:shop/models/entities/order.dart';
import 'package:shop/models/providers/orders_provider.dart';
import 'package:shop/utils/routes.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  bool _isLoading = true;
  OrdersProvider? _orderProvider;

  /// Inicia os Itens que serão exibidos na Pagina
  @override
  void initState() {
    super.initState();
    _orderProvider = Provider.of<OrdersProvider>(context, listen: false);

    if (_orderProvider!.itemsCount <= 0) {
      _orderProvider!
          .loadedOrders()
          .then((_) => setState(() => _isLoading = false));
    } else {
      setState(() => _isLoading = false);
    }
  }

  /// Metodo de Recarregar as Orders
  Future<void> _onRefreshOrders() => _orderProvider!.refreshOrders();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meus Pedidos"),
      ),
      drawer: CustomDrawer(namePage: Routes.routeOrders),
      // Exibição do Loading ou do Body Configurado
      body: _isLoading ? const LoadingWidget() : _body(context),
    );
  }

  /// Configura o Body da Pagina de Orders.
  Widget _body(BuildContext context) {
    List<Order> listOrders = Provider.of<OrdersProvider>(context).items;

    return RefreshIndicator(
      onRefresh: _onRefreshOrders,
      child: listOrders.isEmpty
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
              itemCount: listOrders.length,
              itemBuilder: (ctx, index) =>
                  OrderItem(order: listOrders.elementAt(index)),
            ),
    );
  }
}
