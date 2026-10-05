import 'package:tes/features/products/domain/entities/product.dart';
import 'package:tes/features/products/domain/repositories/product_repository.dart';

class GetFavouriteProducts {
  final ProductRepository repository;

  GetFavouriteProducts({required this.repository});

  Future<List<Product>> call() {
    return repository.getFavouriteProducts();
  }
}