import 'package:dio/dio.dart';
import '../models/product_model.dart';

class ProductProvider {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.0.2.2:8000',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );

  Future<List<Product>> fetchProducts({String? category}) async {
    try {
      final response = await _dio.get(
        '/products',
        queryParameters: category != null ? {'category': category} : null,
      );
      List<dynamic> data = response.data;
      return data.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

 Future<void> createProduct(Map<String, dynamic> productData) async {
  try {
    final response = await _dio.post(
      '/products/', // Added trailing slash here
      data: productData,
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to save product on backend');
    }
  } catch (e) {
    throw Exception('Failed to create product: $e');
  }
}
}