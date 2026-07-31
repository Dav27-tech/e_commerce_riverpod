import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasource/favorite_local_data_source.dart';

final favoriteLocalDataSourceProvider =
Provider<FavoriteLocalDataSource>((ref) {
  return FavoriteLocalDataSource();
});

class FavoritesNotifier extends AsyncNotifier<Set<int>> {
  late final FavoriteLocalDataSource _localDataSource;

  @override
  Future<Set<int>> build() async {
    _localDataSource = ref.read(favoriteLocalDataSourceProvider);
    return _localDataSource.loadFavoriteIds();
  }

  Future<void> toggleFavorite(int productId) async {
    final currentFavorites = state.value ?? <int>{};
    final updatedFavorites = {...currentFavorites};

    if (updatedFavorites.contains(productId)) {
      updatedFavorites.remove(productId);
    } else {
      updatedFavorites.add(productId);
    }

    state = AsyncData(updatedFavorites);
    await _localDataSource.saveFavoriteIds(updatedFavorites);
  }

  bool isFavorite(int productId) {
    return state.value?.contains(productId) ?? false;
  }

  Future<void> removeFavorite(int productId) async {
    final currentFavorites = state.value ?? <int>{};
    if (!currentFavorites.contains(productId)) return;

    final updatedFavorites = {...currentFavorites}..remove(productId);
    state = AsyncData(updatedFavorites);
    await _localDataSource.saveFavoriteIds(updatedFavorites);
  }

  Future<void> clearFavorites() async {
    state = const AsyncData(<int>{});
    await _localDataSource.saveFavoriteIds(<int>{});
  }
}

final favoritesProvider =
AsyncNotifierProvider<FavoritesNotifier, Set<int>>(
  FavoritesNotifier.new,
);