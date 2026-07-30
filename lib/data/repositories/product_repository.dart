import '../datasource/product_remote_data_source.dart';
import '../models/products.dart';

class ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepository({
    required this.remoteDataSource,
  });

  Future<List<Product>> getProducts() {
    return remoteDataSource.getProducts();
  }
}