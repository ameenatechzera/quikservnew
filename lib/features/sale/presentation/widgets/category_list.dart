import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikservnew/features/category/domain/entities/fetch_categories_entity.dart';
import 'package:quikservnew/features/products/presentation/bloc/products_cubit.dart';
import 'package:quikservnew/features/sale/presentation/bloc/sale_cubit.dart';
import 'package:quikservnew/features/sale/presentation/widgets/scroll_supportings.dart';

class CategoryListWidget extends StatelessWidget {
  final List<FetchCategoryDetailsEntity> categories;
  final double bottomPadding;
  final ScrollController controller;
  const CategoryListWidget({
    super.key,
    required this.categories,
    required this.controller,
    this.bottomPadding = 0,
  });

  @override
  Widget build(BuildContext context) {
    final List<FetchCategoryDetailsEntity> displayCategories = [
      FetchCategoryDetailsEntity(
        categoryId: 0,
        categoryName: 'All',
        categoryImage: null,
        branchId: null,
        createdDate: null,
        createdUser: null,
        modifiedDate: null,
        modifiedUser: null,
      ),
      ...categories,
    ];

    return BlocBuilder<SaleCubit, SaleState>(
      builder: (context, saleState) {
        final selectedId = context.read<SaleCubit>().selectedCategoryId;

        return ListView.builder(
          controller: controller,
          physics: const SoftBounceScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          padding: EdgeInsets.only(bottom: bottomPadding),

          itemCount: displayCategories.length,
          itemBuilder: (context, index) {
            final category = displayCategories[index];
            final bool isSelected = category.categoryId == selectedId;

            return GestureDetector(
              onTap: () {
                final productCubit = context.read<ProductCubit>();
                final saleCubit = context.read<SaleCubit>();

                final id = category.categoryId ?? 0;
                final name = category.categoryName ?? "All";

                // ✅ update cubit (instead of ValueNotifier)
                saleCubit.selectCategory(id, name);
                // selectedCategoryId.value = category.categoryId!;
                // selectedCategoryName.value = category.categoryName ?? "All";

                if (category.categoryId == 0) {
                  productCubit.loadProductsFromLocal();
                } else {
                  productCubit.loadProductsByCategory(category.categoryId!);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? Colors.black : Colors.transparent,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Center(
                  child: Text(
                    category.categoryName ?? "",
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
