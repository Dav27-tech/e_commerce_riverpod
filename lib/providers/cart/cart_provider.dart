import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/cart_item.dart';
import '../../data/models/products.dart';

class CartNotifier extends Notifier<List<CartItem>> {
  @override
  List<CartItem> build() {
    return [];
  }

  void addProduct(Product product) {
    // Impossible d'ajouter un produit qui n'est plus en stock.
    if (product.stock <= 0) {
      return;
    }

    final index = state.indexWhere(
          (item) => item.product.id == product.id,
    );

    // Le produit existe déjà dans le panier.
    if (index != -1) {
      final existingItem = state[index];

      // On ne peut pas dépasser le stock disponible.
      if (existingItem.quantity >= product.stock) {
        return;
      }

      final updatedItem = existingItem.copyWith(
        quantity: existingItem.quantity + 1,
      );

      state = [
        ...state.sublist(0, index),
        updatedItem,
        ...state.sublist(index + 1),
      ];

      return;
    }

    // Le produit n'est pas encore dans le panier.
    state = [
      ...state,
      CartItem(
        product: product,
        quantity: 1,
      ),
    ];
  }

  void removeProduct(int productId) {
    state = state
        .where((item) => item.product.id != productId)
        .toList();
  }

  void increaseQuantity(int productId) {
    final index = state.indexWhere(
          (item) => item.product.id == productId,
    );

    if (index == -1) {
      return;
    }

    final item = state[index];

    // La quantité ne peut pas dépasser le stock.
    if (item.quantity >= item.product.stock) {
      return;
    }

    final updatedItem = item.copyWith(
      quantity: item.quantity + 1,
    );

    state = [
      ...state.sublist(0, index),
      updatedItem,
      ...state.sublist(index + 1),
    ];
  }

  void decreaseQuantity(int productId) {
    final index = state.indexWhere(
          (item) => item.product.id == productId,
    );

    if (index == -1) {
      return;
    }

    final item = state[index];

    // Si la quantité est 1, on retire le produit du panier.
    if (item.quantity <= 1) {
      removeProduct(productId);
      return;
    }

    final updatedItem = item.copyWith(
      quantity: item.quantity - 1,
    );

    state = [
      ...state.sublist(0, index),
      updatedItem,
      ...state.sublist(index + 1),
    ];
  }

  void clearCart() {
    state = [];
  }
}

final cartProvider = NotifierProvider<CartNotifier, List<CartItem>>(
  CartNotifier.new,
);

final cartTotalProvider = Provider<double>((ref) {
  final cartItems = ref.watch(cartProvider);

  return cartItems.fold(
    0.0,
        (total, item) => total + item.totalPrice,
  );
});

final cartItemCountProvider = Provider<int>((ref) {
  final cartItems = ref.watch(cartProvider);

  return cartItems.fold(
    0,
        (total, item) => total + item.quantity,
  );
});