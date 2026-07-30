import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasource/product_remote_data_source.dart';
import '../../data/models/products.dart';
import '../../data/repositories/product_repository.dart';


// Fournit le DataSource
final productRemoteDataSourceProvider =
Provider<ProductRemoteDataSource>((ref) {
  return ProductRemoteDataSource();
});


// Fournit le Repository
final productRepositoryProvider =
Provider<ProductRepository>((ref) {
  return ProductRepository(
    remoteDataSource: ref.read(productRemoteDataSourceProvider),
  );
});


// Charge les produits depuis l'API
final productsProvider =
FutureProvider<List<Product>>((ref) async {
  final repository = ref.read(productRepositoryProvider);

  return repository.getProducts();
});