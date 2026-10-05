import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/products/data/datasources/favourite_local_datasource.dart';
import 'features/products/data/datasources/product_remote_datasource.dart';
import 'features/products/data/repositories/product_repository_impl.dart';

import 'features/products/domain/repositories/product_repository.dart';

import 'features/products/domain/usecases/get_categories.dart';
import 'features/products/domain/usecases/get_favourite_products.dart';
import 'features/products/domain/usecases/get_products.dart';
import 'features/products/domain/usecases/get_products_by_category.dart';
import 'features/products/domain/usecases/get_product_details.dart';
import 'features/products/domain/usecases/search_products.dart';
import 'features/products/domain/usecases/toggle_favourite.dart';

import 'features/products/presentation/bloc/product_bloc.dart';
import 'features/products/presentation/pages/products_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sharedPreferences =
      await SharedPreferences.getInstance();

  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://dummyjson.com',
    ),
  );

  final remoteDataSource = ProductRemoteDataSource(
    dio: dio,
  );

  final localDataSource = FavouriteLocalDataSource(
    preferences: sharedPreferences,
  );

  final ProductRepository productRepository =
      ProductRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );

  runApp(
    MyApp(
      productRepository: productRepository,
    ),
  );
}

class MyApp extends StatelessWidget {
  final ProductRepository productRepository;

  const MyApp({
    super.key,
    required this.productRepository,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductBloc(
        getProducts: GetProducts(
          repository: productRepository,
        ),

        getCategories: GetCategories(
          repository: productRepository,
        ),

        searchProducts: SearchProducts(
          productRepository,
        ),

        getProductDetails: GetProductDetails(
          repository: productRepository,
        ),

        getProductsByCategory: GetProductsByCategory(
          repository: productRepository,
        ),

        toggleFavourite: ToggleFavourite(
          repository: productRepository,
        ),

        getFavouriteProducts: GetFavouriteProducts(
          repository: productRepository,
        ),
      ),

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Product Explorer',
        home: const ProductsPage(),
      ),
    );
  }
}