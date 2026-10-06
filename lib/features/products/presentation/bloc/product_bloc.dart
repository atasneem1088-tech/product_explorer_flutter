import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_products.dart';
import '../../domain/usecases/get_product_details.dart';
import '../../domain/usecases/search_products.dart';
import '../../domain/usecases/get_categories.dart';
import '../../domain/usecases/get_products_by_category.dart';
import '../../domain/usecases/toggle_favourite.dart' as usecases;
import '../../domain/usecases/get_favourite_products.dart';

import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProducts getProducts;
  final GetCategories getCategories;
  final SearchProducts searchProducts;
  final GetProductDetails getProductDetails;
  final GetProductsByCategory getProductsByCategory;
  final usecases.ToggleFavourite toggleFavourite;
  final GetFavouriteProducts getFavouriteProducts;

  // Last ProductLoaded state yaad rakhta hai, taake state
  // CategoriesLoaded / ProductDetailsLoaded ho tab bhi toggle kaam kare
  ProductLoaded? _lastLoaded;

  @override
  void onChange(Change<ProductState> change) {
    super.onChange(change);
    if (change.nextState is ProductLoaded) {
      _lastLoaded = change.nextState as ProductLoaded;
    }
  }

  int skip = 0;
  final int limit = 10;

  ProductBloc({
    required this.getProducts,
    required this.getCategories,
    required this.searchProducts,
    required this.getProductDetails,
    required this.getProductsByCategory,
    required this.toggleFavourite,
    required this.getFavouriteProducts,
  }) : super(ProductInitial()) {
    on<LoadProducts>(_loadProducts);
    on<LoadMoreProducts>(_loadMoreProducts);
    on<SearchProductsEvents>(_searchProducts);
    on<LoadCategories>(_loadCategories);
    on<FilterProductsByCategory>(_filterByCategory);
    on<LoadProductDetails>(_loadDetails);
    on<ToggleFavourite>(_toggleFavourite);
    on<LoadFavouriteProducts>(_loadFavourites);
  }

  Future<Set<int>> _getFavouriteIds() async {
    final favouriteProducts = await getFavouriteProducts();

    return favouriteProducts
        .map((product) => product.id)
        .toSet();
  }

  Future<void> _loadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());

    try {
      skip = 0;

      final products = await getProducts(
        limit: limit,
        skip: skip,
      );

      final favouriteIds = await _getFavouriteIds();

      emit(
        ProductLoaded(
          products: products,
          hasMore: products.length == limit,
          favouriteIds: favouriteIds,
        ),
      );
    } catch (e) {
      emit(
        ProductError(e.toString()),
      );
    }
  }
  Future<void> _loadMoreProducts(
    LoadMoreProducts event,
    Emitter<ProductState> emit,
  ) async {
    if (state is! ProductLoaded) {
      return;
    }

    final currentState = state as ProductLoaded;

    if (!currentState.hasMore) {
      return;
    }

    try {
      skip += limit;

      final newProducts = await getProducts(
        limit: limit,
        skip: skip,
      );

      final allProducts = [
        ...currentState.products,
        ...newProducts,
      ];

      emit(
        ProductLoaded(
          products: allProducts,
          hasMore: newProducts.length == limit,
          favouriteIds: currentState.favouriteIds,
        ),
      );
    } catch (e) {
      emit(
        ProductError(e.toString()),
      );
    }
  }

  Future<void> _searchProducts(
    SearchProductsEvents event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());

    try {
      final products = await searchProducts(
        event.query,
      );

      final favouriteIds = await _getFavouriteIds();

      emit(
        ProductLoaded(
          products: products,
          hasMore: false,
          favouriteIds: favouriteIds,
        ),
      );
    } catch (e) {
      emit(
        ProductError(e.toString()),
      );
    }
  }

  Future<void> _loadCategories(
    LoadCategories event,
    Emitter<ProductState> emit,
  ) async {
    try {
      final categories = await getCategories();

      emit(
        CategoriesLoaded(categories),
      );
    } catch (e) {
      emit(
        ProductError(e.toString()),
      );
    }
  }

  Future<void> _filterByCategory(
    FilterProductsByCategory event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());

    try {
      final products = await getProductsByCategory(
        event.category,
      );

      final favouriteIds = await _getFavouriteIds();

      emit(
        ProductLoaded(
          products: products,
          hasMore: false,
          favouriteIds: favouriteIds,
        ),
      );
    } catch (e) {
      emit(
        ProductError(e.toString()),
      );
    }
  }

  Future<void> _loadDetails(
    LoadProductDetails event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductDetailsLoading());

    try {
      final product = await getProductDetails(
        event.productId,
      );

      emit(
        ProductDetailsLoaded(product),
      );
    } catch (e) {
      emit(
        ProductDetailsError(e.toString()),
      );
    }
  }

  Future<void> _toggleFavourite(
    ToggleFavourite event,
    Emitter<ProductState> emit,
  ) async {
    try {
      // Save/remove from SharedPreferences
      await toggleFavourite(event.productId);

      // Favourites page: list refresh karni zaroori hai
      if (state is FavouriteProductsLoaded) {
        final products = await getFavouriteProducts();
        emit(
          FavouriteProductsLoaded(
            products,
            favouriteIds: products.map((p) => p.id).toSet(),
          ),
        );
        return;
      }

      // Products page: state kuch bhi ho, last loaded list use karo
      final last = _lastLoaded;
      if (last != null) {
        final ids = Set<int>.from(last.favouriteIds);
        if (!ids.remove(event.productId)) {
          ids.add(event.productId);
        }

        emit(
          ProductLoaded(
            products: last.products,
            hasMore: last.hasMore,
            isLoadingMore: last.isLoadingMore,
            favouriteIds: ids,
          ),
        );
      }
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }


  Future<void> _loadFavourites(
    LoadFavouriteProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(FavouriteProductsLoading());

    try {
      final products = await getFavouriteProducts();

      final favouriteIds = products
          .map((product) => product.id)
          .toSet();

      emit(
        FavouriteProductsLoaded(
          products,
          favouriteIds: favouriteIds,
        ),
      );
    } catch (e) {
      emit(
        FavouriteProductsError(e.toString()),
      );
    }
  }
}