import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/product_bloc.dart';
import '../bloc/product_event.dart';
import '../bloc/product_state.dart';

class CategoryFilter extends StatefulWidget {
  const CategoryFilter({super.key});

  @override
  State<CategoryFilter> createState() => _CategoryFilterState();
}

class _CategoryFilterState extends State<CategoryFilter> {
  final ScrollController _scroll = ScrollController();//horizaontal listview ko control krega

  String? selectedCategory;//currently konsi category selected he
  List<String> _categories = [];//api se category ayege aur list me save hogi

  bool _canLeft = false;
  bool _canRight = true;

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(LoadCategories());
    _scroll.addListener(_updateArrows);
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _updateArrows() {//ye check krega k left aur right scroll possible he
    if (!_scroll.hasClients) return;//ScrollController abhi ListView ke saath attached nahi hai, to function yahin stop.

    final p = _scroll.position;
    final left = p.pixels > 0;//Agar current position 0 se zyada hai:left scroll possible hai.
    final right = p.pixels < p.maxScrollExtent - 1;

    if (left != _canLeft || right != _canRight) {
      setState(() {
        _canLeft = left;
        _canRight = right;
      });
    }
  }

  void _scrollBy(double delta) {//Ye function list ko left/right move karega.
    if (!_scroll.hasClients) return;

    final target = (_scroll.offset + delta)
        .clamp(0.0, _scroll.position.maxScrollExtent);//ensure karta hai ke position:0 → maxScrollExtent

//ke bahar na jaye.

    _scroll.animateTo(
      target,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  Widget _arrow({
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        height: 34,
        width: 34,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFE8DED3)),
        ),
        child: Icon(
          icon,
          size: 20,
          color: enabled
              ? const Color(0xFF66534A)
              : const Color(0xFFD0C6BC),
        ),
      ),
    );
  }

  Widget _chip({//Ye category ka chip/button banata hai.
    required String label,//Chip ke andar text.
    required bool isSelected,//Ye batata hai category selected hai ya nahi.
    required VoidCallback onTap,//
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF66534A) : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFE8DED3)),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF66534A),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductBloc, ProductState>(
      listenWhen: (previous, current) => current is CategoriesLoaded,
      listener: (context, state) {
        if (state is CategoriesLoaded) {
          setState(() => _categories = state.categories);
        }
      },
      child: _categories.isEmpty
          ? const SizedBox()
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SizedBox(
                height: 42,
                child: Row(
                  children: [
                    _arrow(
                      icon: Icons.chevron_left,
                      enabled: _canLeft,
                      onTap: () => _scrollBy(-200),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: ListView.separated(
                        controller: _scroll,
                        scrollDirection: Axis.horizontal,
                        itemCount: _categories.length + 1,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return _chip(
                              label: 'All',
                              isSelected: selectedCategory == null,
                              onTap: () {
                                setState(() => selectedCategory = null);
                                context
                                    .read<ProductBloc>()
                                    .add(LoadProducts());
                              },
                            );
                          }

                          final category = _categories[index - 1];

                          return _chip(
                            label: category,
                            isSelected: selectedCategory == category,
                            onTap: () {
                              setState(() => selectedCategory = category);
                              context.read<ProductBloc>().add(
                                    FilterProductsByCategory(
                                      category: category,
                                    ),
                                  );
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 6),
                    _arrow(
                      icon: Icons.chevron_right,
                      enabled: _canRight,
                      onTap: () => _scrollBy(200),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}