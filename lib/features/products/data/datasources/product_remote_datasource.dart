import 'package:dio/dio.dart';
import 'package:tes/features/products/data/models/product_model.dart';

class ProductRemoteDataSource {
  final Dio dio;

  ProductRemoteDataSource({required this.dio});

  Future<List<ProductModel>> getProducts({
    int limit = 20,
    int skip = 0,
  }) async {
    final response = await dio.get(
      '/products',
      queryParameters: {
        'limit': limit,
        'skip': skip,
      },
    );

    final List products = response.data['products'];

    return products
        .map((product) => ProductModel.fromJson(product))
        .toList();
  }

  Future<ProductModel> getProductDetails(int productId) async {
    final response = await dio.get(
      '/products/$productId',
    );

    return ProductModel.fromJson(response.data);
  }

  Future<List<ProductModel>> searchProducts(String query) async {
    final response = await dio.get(
      '/products/search',
      queryParameters: {
        'q': query,
      },
    );

    final List products = response.data['products'];

    return products
        .map((product) => ProductModel.fromJson(product))
        .toList();
  }

  Future<List<String>> getCategories() async {
    final response = await dio.get('/products/categories');

    return (response.data as List).map((category) {
      if (category is Map) {
        return category['slug'].toString();
      }
      return category.toString();
    }).toList();
  }

  Future<List<ProductModel>> getProductsByCategory(
    String category,
  ) async {
    final response = await dio.get(
      '/products/category/$category',
    );

    final List products = response.data['products'];

    return products
        .map((product) => ProductModel.fromJson(product))
        .toList();
  }
}