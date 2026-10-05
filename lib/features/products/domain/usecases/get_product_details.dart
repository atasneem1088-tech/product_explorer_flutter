import 'package:tes/features/products/domain/entities/product.dart';
import 'package:tes/features/products/domain/repositories/product_repository.dart';

class GetProductDetails {
  final ProductRepository repository;

  GetProductDetails({
    required this.repository,
  });

  Future<Product> call(int productId) {
    return repository.getProductDetails(productId);
  }
}