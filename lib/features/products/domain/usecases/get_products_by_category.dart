import 'package:tes/features/products/domain/entities/product.dart';
import 'package:tes/features/products/domain/repositories/product_repository.dart';

class GetProductsByCategory {
  final ProductRepository repository;

  GetProductsByCategory({required this.repository});

  Future<List<Product>> call(String category) {
    return repository.getProductsByCategory(category);
  }
}