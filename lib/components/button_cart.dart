import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/exceptions/http_exceptions.dart';
import 'package:shop/models/providers/cart_provider.dart';
import 'package:shop/models/providers/orders_provider.dart';

class ButtonCart extends StatefulWidget {
  final CartProvider cartProvider;

  const ButtonCart({Key? key, required this.cartProvider}) : super(key: key);

  @override
  State<ButtonCart> createState() => _ButtonCartState();
}

class _ButtonCartState extends State<ButtonCart> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final bool _isEmptyCart = widget.cartProvider.itemCount <= 0;

    return _isLoading
        ? const Padding(
            padding: EdgeInsets.only(right: 4.0),
            child: CircularProgressIndicator(),
          )
        : TextButton(
            child: const Text("COMPRAR"),
            style: TextButton.styleFrom(
              textStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            onPressed: _isEmptyCart
                ? null
                : () async {
                    String textSnackBar;
                    if (_isEmptyCart) {
                      textSnackBar =
                          'Não é possivel realizar uma Compra com o Carrinho Vazio';
                    } else {
                      try {
                        setState(() => _isLoading = true);
                        await Provider.of<OrdersProvider>(context,
                                listen: false)
                            .addOrder(widget.cartProvider);

                        widget.cartProvider.clear();
                        setState(() => _isLoading = false);
                        textSnackBar = 'Compra Realizada com Sucesso !';
                      } on HttpExceptions catch (error) {
                        textSnackBar = error.getMessage;
                      }
                    }

                    // Configura e Exibe a Mensagem do SnackBar
                    final snackBar = SnackBar(
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.6),
                      content: Text(textSnackBar),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
          );
  }
}
