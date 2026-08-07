import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/enums/sort_option.dart';
import '../../data/models/products.dart';
import '../favorite/favorite_provider.dart';
import '../product/product_provider.dart';


// -----------------------------------------------------------------------------
// SEARCH
// -----------------------------------------------------------------------------

class SearchNotifier extends Notifier<String> {
  @override
  String build() {
    return '';
  }

  void setSearch(String value) {
    state = value;
  }

  void clear() {
    state = '';
  }
}

final searchProvider = NotifierProvider<SearchNotifier, String>(
  SearchNotifier.new,
);


// -----------------------------------------------------------------------------
// CATEGORY
// -----------------------------------------------------------------------------

class CategoryNotifier extends Notifier<String> {
  @override
  String build() {
    return 'All';
  }

  void setCategory(String category) {
    state = category;
  }

  void reset() {
    state = 'All';
  }
}

final categoryProvider = NotifierProvider<CategoryNotifier, String>(
  CategoryNotifier.new,
);


// -----------------------------------------------------------------------------
// SORT
// -----------------------------------------------------------------------------

class SortNotifier extends Notifier<SortOption> {
  @override
  SortOption build() {
    return SortOption.none;
  }

  void setSort(SortOption option) {
    state = option;
  }

  void reset() {
    state = SortOption.none;
  }
}

final sortProvider = NotifierProvider<SortNotifier, SortOption>(
  SortNotifier.new,
);


// -----------------------------------------------------------------------------
// CATEGORIES AVAILABLE
// -----------------------------------------------------------------------------

final categoriesProvider =
Provider<AsyncValue<List<String>>>((ref) {
  final productsAsync = ref.watch(productsProvider);

  return productsAsync.whenData((products) {
    final categories = products
        .map((product) => product.category)
        .toSet()
        .toList()
      ..sort();

    return [
      'All',
      ...categories,
    ];
  });
});


// -----------------------------------------------------------------------------
// FILTERED AND SORTED PRODUCTS
// -----------------------------------------------------------------------------

final filteredProductsProvider =
Provider<AsyncValue<List<Product>>>((ref) {
  final productsAsync = ref.watch(productsProvider);

  final searchQuery =
  ref.watch(searchProvider).trim().toLowerCase();

  final selectedCategory =
  ref.watch(categoryProvider);

  final selectedSort =
  ref.watch(sortProvider);

  return productsAsync.whenData((products) {
    var filteredProducts = products.where((product) {
      final matchesSearch =
          product.title.toLowerCase().contains(searchQuery) ||
              product.brand.toLowerCase().contains(searchQuery);

      final matchesCategory =
          selectedCategory == 'All' ||
              product.category == selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();

    switch (selectedSort) {
      case SortOption.priceAsc:
        filteredProducts.sort(
              (a, b) => a.price.compareTo(b.price),
        );
        break;

      case SortOption.priceDesc:
        filteredProducts.sort(
              (a, b) => b.price.compareTo(a.price),
        );
        break;

      case SortOption.ratingDesc:
        filteredProducts.sort(
              (a, b) => b.rating.compareTo(a.rating),
        );
        break;

      case SortOption.nameAsc:
        filteredProducts.sort(
              (a, b) => a.title.compareTo(b.title),
        );
        break;

      case SortOption.none:
        break;
    }

    return filteredProducts;
  });
});


// -----------------------------------------------------------------------------
// FAVORITE PRODUCTS
// -----------------------------------------------------------------------------

final favoriteProductsProvider =
Provider<AsyncValue<List<Product>>>((ref) {
  final productsAsync = ref.watch(productsProvider);
  final favoritesAsync = ref.watch(favoritesProvider);

  if (productsAsync.hasError) {
    return AsyncError(
      productsAsync.error!,
      productsAsync.stackTrace!,
    );
  }

  if (favoritesAsync.hasError) {
    return AsyncError(
      favoritesAsync.error!,
      favoritesAsync.stackTrace!,
    );
  }

  if (productsAsync.isLoading ||
      favoritesAsync.isLoading) {
    return const AsyncLoading();
  }

  final products = productsAsync.value ?? [];
  final favoriteIds =
      favoritesAsync.value ?? <int>{};

  final favoriteProducts = products
      .where(
        (product) => favoriteIds.contains(product.id),
  )
      .toList();

  return AsyncData(favoriteProducts);
});