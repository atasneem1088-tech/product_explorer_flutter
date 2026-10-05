abstract class ProductEvent {}

class LoadProducts extends ProductEvent {}

class LoadMoreProducts extends ProductEvent {}

class SearchProductsEvents extends ProductEvent {
  final String query;

  SearchProductsEvents({required this.query});
}

class LoadCategories extends ProductEvent {}

class FilterProductsByCategory extends ProductEvent {
  final String category;

  FilterProductsByCategory({required this.category});
}

class LoadProductDetails extends ProductEvent {
  final int productId;

  LoadProductDetails({required this.productId});
}

class ToggleFavourite extends ProductEvent {
  final int productId;

  ToggleFavourite({required this.productId});
}

class LoadFavouriteProducts extends ProductEvent {}