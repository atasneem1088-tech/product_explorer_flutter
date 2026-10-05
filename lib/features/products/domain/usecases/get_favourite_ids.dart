import '../repositories/product_repository.dart';

class GetFavouriteIds {
  final ProductRepository repository;

  GetFavouriteIds(this.repository);

  Future<List<int>> call() {
    return repository.getFavouriteIds();
  }
}