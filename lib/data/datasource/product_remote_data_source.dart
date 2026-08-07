import 'package:dio/dio.dart';

import '../../core/network/dio_client.dart';
import '../models/products.dart';

class ProductRemoteDataSource {
  final Dio _dio = DioClient.dio;

  Future<List<Product>> getProducts() async {
    try {
      final response = await _dio.get(
        '/products',
        queryParameters: {
          'limit': 0,
        },
      );

      final List<dynamic> data = response.data['products'];

      return data
          .map(
            (json) => Product.fromJson(
          json as Map<String, dynamic>,
        ),
      )
          .toList();
    } catch (e) {
      throw Exception('Impossible de charger les produits : $e');
    }
  }
}