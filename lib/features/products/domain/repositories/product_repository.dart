import 'package:tes/features/products/domain/entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts({
    int limit = 20,
    int skip = 0,
  });

  Future<Product> getProductDetails(int productId);

  Future<List<Product>> searchProducts(String query);

  Future<List<String>> getCategories();

  Future<List<Product>> getProductsByCategory(String category);

  Future<void> toggleFavourite(int productId);

  Future<List<Product>> getFavouriteProducts();

  Future<List<int>> getFavouriteIds();
}