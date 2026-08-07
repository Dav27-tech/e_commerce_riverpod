import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/cart/cart_provider.dart';
import '../../widgets/cart_item_card.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final totalPrice = ref.watch(cartTotalProvider);
    final totalItems = ref.watch(cartItemCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon panier'),
        actions: [
          if (cartItems.isNotEmpty)
            IconButton(
              tooltip: 'Vider le panier',
              onPressed: () {
                _showClearCartDialog(context, ref);
              },
              icon: const Icon(Icons.delete_sweep_outlined),
            ),
        ],
      ),
      body: cartItems.isEmpty
          ? const _EmptyCart()
          : Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                20,
                20,
                20,
                24,
              ),
              itemCount: cartItems.length,
              separatorBuilder: (_, _) =>
              const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = cartItems[index];

                return CartItemCard(
                  item: item,
                );
              },
            ),
          ),
          _CartSummary(
            totalItems: totalItems,
            totalPrice: totalPrice,
          ),
        ],
      ),
    );
  }

  Future<void> _showClearCartDialog(
      BuildContext context,
      WidgetRef ref,
      ) async {
    final shouldClear = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Vider le panier ?'),
          content: const Text(
            'Tous les produits seront supprimés du panier.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Annuler'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Vider'),
            ),
          ],
        );
      },
    );

    if (shouldClear == true) {
      ref.read(cartProvider.notifier).clearCart();
    }
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 20),
            Text(
              'Votre panier est vide',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ajoutez des produits pour les retrouver ici.',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _CartSummary extends StatelessWidget {
  const _CartSummary({
    required this.totalItems,
    required this.totalPrice,
  });

  final int totalItems;
  final double totalPrice;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        20,
        20,
        20,
        24,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context)
                .colorScheme
                .outlineVariant,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Row(
              children: [
                const Text('Articles'),
                const Spacer(),
                Text('$totalItems'),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  'Total',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '\$${totalPrice.toStringAsFixed(2)}',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}