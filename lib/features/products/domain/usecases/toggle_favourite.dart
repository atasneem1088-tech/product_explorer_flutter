import 'package:tes/features/products/domain/repositories/product_repository.dart';

class ToggleFavourite {
  final ProductRepository repository;

  ToggleFavourite({required this.repository});

  Future<void> call(int productId) {
    return repository.toggleFavourite(productId);
  }
}