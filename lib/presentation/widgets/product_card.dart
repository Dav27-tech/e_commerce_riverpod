import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/products.dart';
import '../../providers/cart/cart_provider.dart';
import '../../providers/favorite/favorite_provider.dart';

class ProductCard extends ConsumerWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoritesProvider);

    final isFavorite =
        favoritesAsync.value?.contains(product.id) ?? false;

    final isOutOfStock = product.stock <= 0;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(
                      product.thumbnail,
                      fit: BoxFit.cover,
                      errorBuilder: (
                          context,
                          error,
                          stackTrace,
                          ) {
                        return const Center(
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            size: 40,
                          ),
                        );
                      },
                      loadingBuilder: (
                          context,
                          child,
                          loadingProgress,
                          ) {
                        if (loadingProgress == null) {
                          return child;
                        }

                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  ),

                  if (product.discountPercentage > 0)
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .error,
                          borderRadius:
                          BorderRadius.circular(8),
                        ),
                        child: Text(
                          '-${product.discountPercentage.round()}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),

                  Positioned(
                    top: 8,
                    right: 8,
                    child: Material(
                      color: Colors.white.withValues(
                        alpha: 0.9,
                      ),
                      shape: const CircleBorder(),
                      child: IconButton(
                        tooltip: 'Favori',
                        onPressed:
                        favoritesAsync.hasValue
                            ? () {
                          ref
                              .read(
                            favoritesProvider
                                .notifier,
                          )
                              .toggleFavorite(
                            product.id,
                          );
                        }
                            : null,
                        icon: Icon(
                          isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: isFavorite
                              ? AppColors.favorite
                              : null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    product.brand,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 16,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        product.rating.toStringAsFixed(1),
                      ),
                      const Spacer(),
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (product.stock <= 5 &&
                      product.stock > 0)
                    Text(
                      'Plus que ${product.stock} en stock',
                      style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .error,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: isOutOfStock
                          ? null
                          : () {
                        ref
                            .read(
                          cartProvider.notifier,
                        )
                            .addProduct(product);

                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${product.title} ajouté au panier',
                            ),
                            duration:
                            const Duration(
                              seconds: 2,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.add_shopping_cart,
                        size: 18,
                      ),
                      label: Text(
                        isOutOfStock
                            ? 'Rupture'
                            : 'Ajouter',
                      ),
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