import 'package:tes/features/products/domain/entities/product.dart';
import 'package:tes/features/products/domain/repositories/product_repository.dart';

class GetProducts {
  final ProductRepository repository;

  GetProducts({required this.repository});

  Future<List<Product>> call({
    int limit=10,
    int skip=0,
  })
  {
    return repository.getProducts(
     limit:limit,
     skip:skip,
    );
  }
}