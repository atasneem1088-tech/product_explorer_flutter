import 'package:tes/core/network/dio_client.dart';

import 'package:tes/features/products/data/datasources/favourite_local_datasource.dart';
import 'package:tes/features/products/data/datasources/product_remote_datasource.dart';

import 'package:tes/features/products/domain/entities/product.dart';
import 'package:tes/features/products/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final FavouriteLocalDataSource localDataSource;

  late final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({
    required this.localDataSource,
  }) {
    final dio = DioClient.create();

    remoteDataSource = ProductRemoteDataSource(
      dio: dio,
    );
  }

  @override
  Future<List<Product>> getProducts({
    int limit = 20,
    int skip = 0,
  }) {
    return remoteDataSource.getProducts(
      limit: limit,
      skip: skip,
    );
  }

  @override
  Future<Product> getProductDetails(int productId) {
    return remoteDataSource.getProductDetails(productId);
  }

  @override
  Future<List<Product>> searchProducts(String query) {
    return remoteDataSource.searchProducts(query);
  }

  @override
  Future<List<String>> getCategories() {
    return remoteDataSource.getCategories();
  }

  @override
  Future<List<Product>> getProductsByCategory(
    String category,
  ) {
    return remoteDataSource.getProductsByCategory(category);
  }

  @override
  Future<void> toggleFavourite(int productId) {
    return localDataSource.toggleFavourite(productId);
  }

  @override
  Future<List<int>> getFavouriteIds() {
    return localDataSource.getFavouriteIds();
  }

  @override
  Future<List<Product>> getFavouriteProducts() async {
    final favouriteIds =
        await localDataSource.getFavouriteIds();

    final products = <Product>[];

    for (final id in favouriteIds) {
      final product =
          await remoteDataSource.getProductDetails(id);

      products.add(product);
    }

    return products;
  }
}