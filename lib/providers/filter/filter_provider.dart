import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/products.dart';
import '../product/product_provider.dart';
import '../../core/enums/sort_option.dart';

class SearchNotifier extends Notifier<String> {
  @override
  String build() => '';

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

class CategoryNotifier extends Notifier<String> {
  @override
  String build() => 'All';

  void setCategory(String value) {
    state = value;
  }

  void reset() {
    state = 'All';
  }
}

final categoryProvider = NotifierProvider<CategoryNotifier, String>(
  CategoryNotifier.new,
);

class SortNotifier extends Notifier<SortOption> {
  @override
  SortOption build() => SortOption.none;

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

final filteredProductsProvider = Provider<AsyncValue<List<Product>>>((ref) {
  final productsAsync = ref.watch(productsProvider);
  final query = ref.watch(searchProvider).trim().toLowerCase();
  final category = ref.watch(categoryProvider);
  final sortOption = ref.watch(sortProvider);

  return productsAsync.whenData((products) {
    var filtered = products.where((product) {
      final matchesSearch = product.title.toLowerCase().contains(query) ||
          product.brand.toLowerCase().contains(query);

      final matchesCategory =
      category == 'All' ? true : product.category == category;

      return matchesSearch && matchesCategory;
    }).toList();

    switch (sortOption) {
      case SortOption.priceAsc:
        filtered.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortOption.priceDesc:
        filtered.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortOption.ratingDesc:
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case SortOption.nameAsc:
        filtered.sort((a, b) => a.title.compareTo(b.title));
        break;
      case SortOption.none:
        break;
    }

    return filtered;
  });
});