import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/products.dart';
import '../../../providers/cart/cart_provider.dart';
import '../../../providers/favorite/favorite_provider.dart';
import '../../../providers/product/product_provider.dart';

class ProductDetailPage extends ConsumerWidget {
  const ProductDetailPage({
    super.key,
    required this.productId,
  });

  final int productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détail du produit'),
      ),
      body: productsAsync.when(
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        error: (error, stackTrace) {
          return Center(
            child: Text(
              'Impossible de charger le produit.',
            ),
          );
        },
        data: (products) {
          Product? product;

          for (final item in products) {
            if (item.id == productId) {
              product = item;
              break;
            }
          }

          if (product == null) {
            return const Center(
              child: Text(
                'Produit introuvable.',
              ),
            );
          }

          return _ProductDetailContent(
            product: product,
          );
        },
      ),
    );
  }
}

class _ProductDetailContent extends ConsumerWidget {
  const _ProductDetailContent({
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoritesProvider);

    final isFavorite =
        favoritesAsync.value?.contains(product.id) ?? false;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius:
                BorderRadius.circular(20),
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
                        size: 56,
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: Text(
                    product.title,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
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
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Text(
              product.brand,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge,
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                const SizedBox(width: 6),
                Text(
                  product.rating.toStringAsFixed(1),
                ),
                const SizedBox(width: 16),
                Text(
                  '${product.stock} en stock',
                ),
              ],
            ),

            const SizedBox(height: 16),

            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'Description',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              product.description,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge,
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: product.stock <= 0
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
                    const SnackBar(
                      content: Text(
                        'Produit ajouté au panier',
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                ),
                label: Text(
                  product.stock <= 0
                      ? 'Rupture de stock'
                      : 'Ajouter au panier',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}