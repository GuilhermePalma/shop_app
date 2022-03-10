import 'package:flutter/material.dart';
import 'package:shop/models/entities/cart.dart';
import 'package:shop/models/entities/product.dart';

class CartProvider extends ChangeNotifier {
  Map<String, Cart> _items = {};

  /// Metodo Responsavel por Retornar uma Lista com os Itens do Carrinho
  Map<String, Cart> get items => {..._items};

  /// Metodo Responsavel por Obter o Tamanho da Lista dos Itens do Carrinho
  int get itemCount => _items.length;

  /// Metodo Responsavel por Retornar o Preço Total do Carrinho
  double get totalAmout {
    double totalPriceCart = 0.0;
    _items.forEach((key, value) =>
        totalPriceCart += value.priceItem * value.quantityProducts);
    return totalPriceCart;
  }

  /// Metodo Responsavel por Adicionar um Produto ao Carrinho
  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items.update(product.id, (existingItem) {
        return existingItem.copyWith(
            quantityProducts: existingItem.quantityProducts + 1);
      });
    } else {
      _items.putIfAbsent(product.id, () => Cart.fromProduct(product));
    }

    notifyListeners();
  }

  /// Metodo Responsavel por Remover um Item do Carrinho pelo ID do Produto
  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  /// Metodo Responsavel por Remover 1 Item da Quantidade Total do Item
  /// na Lista dos Itens do Carrinho
  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) return;

    if (_items[productId]?.quantityProducts == 1) {
      _items.remove(productId);
    } else {
      _items.update(productId, (existingItem) {
        return existingItem.copyWith(
            quantityProducts: existingItem.quantityProducts - 1);
      });
    }
    notifyListeners();
  }

  /// Metodo Responsavel por Limpar a Lista do Carrinho
  void clear() {
    _items = {};
    notifyListeners();
  }
}
