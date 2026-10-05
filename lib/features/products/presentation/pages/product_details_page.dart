
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/product.dart';
import '../bloc/product_bloc.dart';
import '../bloc/product_event.dart';
import '../bloc/product_state.dart';

class ProductDetailsPage extends StatefulWidget {
  final int productId; // jis product ki details chahiye uski id

  const ProductDetailsPage({
    super.key,
    required this.productId,
  });

  @override
  State<ProductDetailsPage> createState() =>
      _ProductDetailsPageState();
}

class _ProductDetailsPageState
    extends State<ProductDetailsPage> {
  @override
  void initState() {
    super.initState();

    context.read<ProductBloc>().add(
      LoadProductDetails(
        productId: widget.productId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F3ED),

      // ============================================================
      // APP BAR
      // ============================================================

      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F3ED),
        elevation: 0,
        foregroundColor: const Color(0xFF302A27),
        title: const Text(
          'Product Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF302A27),
          ),
        ),
      ),

      // ============================================================
      // BODY
      // ============================================================

      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {

          // ================= LOADING =================

          if (state is ProductDetailsLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF66534A),
              ),
            );
          }

          // ================= ERROR =================

          if (state is ProductDetailsError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF817872),
                  ),
                ),
              ),
            );
          }

          // ================= PRODUCT LOADED =================

          if (state is ProductDetailsLoaded) {
            final product = state.product;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  // ============================================================
                  // IMAGE
                  // ============================================================

                  Container(
                    height: 330,
                    width: double.infinity,
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8DED3),
                      borderRadius:
                          BorderRadius.circular(24),
                    ),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(24),
                      child: Image.network(
                        product.thumbnail,
                        fit: BoxFit.contain,
                        errorBuilder:
                            (context, error, stackTrace) {
                          return const Center(
                            child: Icon(
                              Icons
                                  .image_not_supported_outlined,
                              size: 50,
                              color: Color(0xFF817872),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // ============================================================
                  // CONTENT
                  // ============================================================

                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      4,
                      20,
                      30,
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [

                        // ================= CATEGORY =================

                        Text(
                          product.category,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF817872),
                          ),
                        ),

                        const SizedBox(height: 6),

                        // ================= TITLE =================

                        Text(
                          product.title,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF302A27),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // ================= RATING + STOCK =================

                        Row(
                          children: [

                            const Icon(
                              Icons.star,
                              size: 19,
                              color: Color(0xFFB79B84),
                            ),

                            const SizedBox(width: 5),

                            Text(
                              product.rating.toString(),
                              style: const TextStyle(
                                fontWeight:
                                    FontWeight.w600,
                                color: Color(0xFF66534A),
                              ),
                            ),

                            const SizedBox(width: 18),

                            Container(
                              padding:
                                  const EdgeInsets
                                      .symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    const Color(0xFFE8DED3),
                                borderRadius:
                                    BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${product.stock} in stock',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color:
                                      Color(0xFF66534A),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        // ================= PRICE =================

                        Text(
                          '\$${product.price}',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF66534A),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ============================================================
                        // DESCRIPTION
                        // ============================================================

                        const Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF302A27),
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          product.description,
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.6,
                            color: Color(0xFF817872),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ============================================================
                        // PRODUCT INFORMATION
                        // ============================================================

                        const Text(
                          'Product Information',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF302A27),
                          ),
                        ),

                        const SizedBox(height: 12),

                        _InfoTile(
                          title: 'Brand',
                          value: product.brand,
                        ),

                        _InfoTile(
                          title: 'SKU',
                          value: product.sku,
                        ),

                        _InfoTile(
                          title: 'Availability',
                          value:
                              product.availabilityStatus,
                        ),

                        _InfoTile(
                          title: 'Shipping',
                          value:
                              product.shippingInformation,
                        ),

                        _InfoTile(
                          title: 'Warranty',
                          value:
                              product.warrantyInformation,
                        ),

                        _InfoTile(
                          title: 'Return Policy',
                          value:
                              product.returnPolicy,
                        ),

                        const SizedBox(height: 18),

                        // ============================================================
                        // REVIEWS
                        // ============================================================

                        const Text(
                          'Reviews',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF302A27),
                          ),
                        ),

                        const SizedBox(height: 12),

                        SizedBox(
                          height: 145,
                          child: product.reviews.isEmpty
                              ? const Center(
                                  child: Text(
                                    'No reviews available',
                                    style: TextStyle(
                                      color:
                                          Color(0xFF817872),
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  scrollDirection:
                                      Axis.horizontal,
                                  itemCount:
                                      product.reviews.length,
                                  itemBuilder:
                                      (context, index) {

                                    final review =
                                        product.reviews[index];

                                    return _ReviewCard(
                                      review: review,
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          // ================= INITIAL =================

          return const Center(
            child: Text(
              'Loading product...',
              style: TextStyle(
                color: Color(0xFF817872),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ============================================================
// INFO TILE
// ============================================================

class _InfoTile extends StatelessWidget {
  final String title;
  final String value;

  const _InfoTile({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [

          SizedBox(
            width: 100,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF66534A),
              ),
            ),
          ),

          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF817872),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// REVIEW CARD
// ============================================================

class _ReviewCard extends StatelessWidget {
  final Review review;

  const _ReviewCard({
    required this.review,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [

          // ================= RATING =================

          Row(
            children: [

              const Icon(
                Icons.star,
                size: 18,
                color: Color(0xFFB79B84),
              ),

              const SizedBox(width: 5),

              Text(
                review.rating.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF66534A),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // ================= COMMENT =================

          Text(
            review.comment,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              height: 1.4,
              color: Color(0xFF817872),
            ),
          ),

          const SizedBox(height: 10),

          // ================= REVIEWER =================

          Text(
            review.reviewerName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF302A27),
            ),
          ),
        ],
      ),
    );
  }
}

