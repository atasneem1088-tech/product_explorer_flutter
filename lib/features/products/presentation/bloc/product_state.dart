import 'package:tes/features/products/domain/entities/product.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;
  final bool hasMore;
  final bool isLoadingMore;
  final Set<int> favouriteIds;

  ProductLoaded({
    required this.products,
    this.hasMore = true,
    this.isLoadingMore = false,
    this.favouriteIds = const {},
  });
}

class ProductError extends ProductState {
  final String message;

  ProductError(this.message);
}

class CategoriesLoaded extends ProductState {
  final List<String> categories;

  CategoriesLoaded(this.categories);
}

class ProductDetailsLoading extends ProductState {}

class ProductDetailsLoaded extends ProductState {
  final Product product;

  ProductDetailsLoaded(this.product);
}

class ProductDetailsError extends ProductState {
  final String message;

  ProductDetailsError(this.message);
}

class FavouriteProductsLoading extends ProductState {}

class FavouriteProductsLoaded extends ProductState {
  final List<Product> products;
  final Set<int> favouriteIds;

  FavouriteProductsLoaded(
    this.products,{
      this.favouriteIds=const{},
    }
  );
}

class FavouriteProductsError extends ProductState {
  final String message;

  FavouriteProductsError(this.message);
}