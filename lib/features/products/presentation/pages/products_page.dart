import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/product_bloc.dart';
import '../bloc/product_event.dart';
import '../bloc/product_state.dart';
import '../widgets/category_filter.dart';
import '../widgets/empty_widget.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/product_card.dart';
import '../widgets/search_bar.dart';
import 'favourites_page.dart';
import 'product_details_page.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    context.read<ProductBloc>().add(
      LoadProducts(),
    );

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        context.read<ProductBloc>().add(
          LoadMoreProducts(),
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F3ED),

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                20,
                20,
                8,
              ),

              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                children: [

                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: const [

                      Text(
                        'Discover',

                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF817872),
                        ),
                      ),

                      SizedBox(height: 4),

                      Text(
                        'Find your products',

                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF302A27),
                        ),
                      ),
                    ],
                  ),

                  GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FavouritesPage(),
                        ),
                      );

                      // Wapas aane par hearts refresh karo
                      if (context.mounted) {
                        context.read<ProductBloc>().add(LoadProducts());
                      }
                    },
                    child: Container(
                      height: 46,
                      width: 46,

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(15),
                      ),

                      child: const Icon(
                        Icons.favorite_border,
                        color: Color(0xFF66534A),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SearchBarWidget(),

            const SizedBox(height: 4),

            const CategoryFilter(),

            const SizedBox(height: 16),

            Expanded(
              child: BlocBuilder<ProductBloc, ProductState>(
                buildWhen: (previous, current) =>
                    current is ProductLoading ||
                    current is ProductLoaded ||
                    current is ProductError,

                builder: (context, state) {

                  if (state is ProductLoading) {
                    return const LoadingWidget();
                  }

                  if (state is ProductError) {
                    return ProductErrorWidget(
                      message: state.message,
                    );
                  }

                  if (state is ProductLoaded) {

                    if (state.products.isEmpty) {
                      return const EmptyWidget(
                        message: 'No products found',
                      );
                    }

                    return GridView.builder(
                      controller: _scrollController,

                      padding: const EdgeInsets.fromLTRB(
                        16,
                        0,
                        16,
                        20,
                      ),

                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 0.68,
                      ),

                      itemCount: state.products.length,

                      itemBuilder: (context, index) {

                        final product =
                            state.products[index];

                        return ProductCard(
                          product: product,
                          isFavourite: state.favouriteIds.contains(product.id),

                          onTap: () {
                            Navigator.push(
                              context,

                              MaterialPageRoute(
                                builder: (context) =>
                                    ProductDetailsPage(
                                  productId: product.id,
                                ),
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
            ),
          ],
        ),
      ),
    );
  }
}