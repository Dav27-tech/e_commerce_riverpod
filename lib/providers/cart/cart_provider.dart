import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/cart_item.dart';
import '../../data/models/products.dart';

class CartNotifier extends Notifier<List<CartItem>> {
  @override
  List<CartItem> build() {
    return [];
  }

  void addProduct(Product product) {
    final index = state.indexWhere((item) => item.product.id == product.id);

    if (index != -1) {
      final existingItem = state[index];
      final updatedItem = existingItem.copyWith(
        quantity: existingItem.quantity + 1,
      );

      state = [
        ...state.sublist(0, index),
        updatedItem,
        ...state.sublist(index + 1),
      ];
    } else {
      state = [
        ...state,
        CartItem(product: product, quantity: 1),
      ];
    }
  }

  void removeProduct(String productId) {
    state = state.where((item) => item.product.id != productId).toList();
  }

  void increaseQuantity(String productId) {
    final index = state.indexWhere((item) => item.product.id == productId);
    if (index == -1) return;

    final item = state[index];
    final updatedItem = item.copyWith(quantity: item.quantity + 1);

    state = [
      ...state.sublist(0, index),
      updatedItem,
      ...state.sublist(index + 1),
    ];
  }

  void decreaseQuantity(String productId) {
    final index = state.indexWhere((item) => item.product.id == productId);
    if (index == -1) return;

    final item = state[index];

    if (item.quantity <= 1) {
      removeProduct(productId);
      return;
    }

    final updatedItem = item.copyWith(quantity: item.quantity - 1);

    state = [
      ...state.sublist(0, index),
      updatedItem,
      ...state.sublist(index + 1),
    ];
  }

  void clearCart() {
    state = [];
  }

  double get totalPrice {
    return state.fold(0, (sum, item) => sum + item.totalPrice);
  }

  int get totalItems {
    return state.fold(0, (sum, item) => sum + item.quantity);
  }
}

final cartProvider = NotifierProvider<CartNotifier, List<CartItem>>(
  CartNotifier.new,
);