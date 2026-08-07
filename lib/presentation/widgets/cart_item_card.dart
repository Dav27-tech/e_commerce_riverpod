import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/cart_item.dart';
import '../../providers/cart/cart_provider.dart';

class CartItemCard extends ConsumerWidget {
  const CartItemCard({
    super.key,
    required this.item,
  });

  final CartItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = item.product;
    final isMaxQuantityReached =
        item.quantity >= product.stock;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 92,
                height: 92,
                child: Image.network(
                  product.thumbnail,
                  fit: BoxFit.cover,
                  errorBuilder: (
                      context,
                      error,
                      stackTrace,
                      ) {
                    return const ColoredBox(
                      color: Colors.black12,
                      child: Icon(
                        Icons.image_not_supported_outlined,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          product.title,
                          maxLines: 2,
                          overflow:
                          TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Supprimer',
                        onPressed: () {
                          ref
                              .read(
                            cartProvider.notifier,
                          )
                              .removeProduct(
                            product.id,
                          );
                        },
                        icon: const Icon(
                          Icons.delete_outline,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.brand,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      _QuantitySelector(
                        quantity: item.quantity,
                        isMaxReached:
                        isMaxQuantityReached,
                        onDecrease: () {
                          ref
                              .read(
                            cartProvider.notifier,
                          )
                              .decreaseQuantity(
                            product.id,
                          );
                        },
                        onIncrease: () {
                          ref
                              .read(
                            cartProvider.notifier,
                          )
                              .increaseQuantity(
                            product.id,
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Sous-total : '
                        '\$${item.totalPrice.toStringAsFixed(2)}',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuantitySelector extends StatelessWidget {
  const _QuantitySelector({
    required this.quantity,
    required this.isMaxReached,
    required this.onDecrease,
    required this.onIncrease,
  });

  final int quantity;
  final bool isMaxReached;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: quantity == 1
                ? 'Supprimer'
                : 'Diminuer',
            onPressed: onDecrease,
            icon: Icon(
              quantity == 1
                  ? Icons.delete_outline
                  : Icons.remove,
              size: 18,
            ),
          ),
          Text(
            '$quantity',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            tooltip: isMaxReached
                ? 'Stock maximum atteint'
                : 'Augmenter',
            onPressed:
            isMaxReached ? null : onIncrease,
            icon: const Icon(
              Icons.add,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}