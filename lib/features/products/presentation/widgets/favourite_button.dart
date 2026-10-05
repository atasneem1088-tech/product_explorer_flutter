import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/product_bloc.dart';
import '../bloc/product_event.dart';

class FavouriteButton extends StatelessWidget {
  final int productId;

  const FavouriteButton({
    super.key,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,

      onTap: () {
        context.read<ProductBloc>().add(
          ToggleFavourite(
            productId: productId,
          ),
        );
      },

      child: Container(
        height: 40,
        width: 40,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),

        child: const Icon(
          Icons.favorite_border,
        ),
      ),
    );
  }
}