import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/product_bloc.dart';
import '../bloc/product_event.dart';
import '../bloc/product_state.dart';
import '../widgets/product_card.dart';
import 'product_details_page.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({super.key});

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  @override
  void initState() {
    super.initState();

    context.read<ProductBloc>().add(LoadFavouriteProducts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F3ED),
      appBar: AppBar(
        title: const Text(
          'Favourites',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF302A27),
          ),
        ),
        backgroundColor: const Color(0xFFF7F3ED),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF302A27)),
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        buildWhen: (previous, current) =>
            current is FavouriteProductsLoading ||
            current is FavouriteProductsLoaded ||
            current is FavouriteProductsError,
        builder: (context, state) {
          // Loading
          if (state is FavouriteProductsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error
          if (state is FavouriteProductsError) {
            return Center(
              child: Text(
                state.message,
                textAlign: TextAlign.center,
              ),
            );
          }

          // Favourite products loaded
          if (state is FavouriteProductsLoaded) {
            // Empty
            if (state.products.isEmpty) {
              return const Center(
                child: Text('No favourite products'),
              );
            }

            return GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.68,
              ),
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final product = state.products[index];

                return ProductCard(
                  product: product,
                  isFavourite: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailsPage(productId: product.id),
                      ),
                    );
                  },
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}