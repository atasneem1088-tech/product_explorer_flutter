import 'package:tes/features/products/domain/repositories/product_repository.dart';

class GetCategories {
  final ProductRepository repository;

  GetCategories({required this.repository});

  Future<List<String>> call() {
    return repository.getCategories();
  }
}