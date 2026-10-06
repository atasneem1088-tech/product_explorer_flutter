
import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  final String message;

  const EmptyWidget({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFE8DED3),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.shopping_bag_outlined,
              size: 38,
              color: Color(0xFF66534A),
            ),
          ),

          const SizedBox(height: 18),

          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF302A27),
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Try searching for something else.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF817872),
            ),
          ),
        ],
      ),
    );
  }
}

