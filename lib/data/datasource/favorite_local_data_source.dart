import 'package:shared_preferences/shared_preferences.dart';

class FavoriteLocalDataSource {
  static const String _key = 'favorite_product_ids';

  Future<Set<int>> loadFavoriteIds() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(_key) ?? [];
    return ids.map(int.parse).toSet();
  }

  Future<void> saveFavoriteIds(Set<int> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _key,
      ids.map((id) => id.toString()).toList(),
    );
  }
}