import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/core/utils/widgets/app_toast.dart';
import 'package:quikservnew/core/utils/widgets/common_appbar.dart';
import 'package:quikservnew/features/category/presentation/bloc/category_cubit.dart';
import 'package:quikservnew/features/products/presentation/bloc/products_cubit.dart';
import 'package:quikservnew/features/products/presentation/screens/product_entry_screen.dart';
import 'package:quikservnew/features/products/presentation/widgets/category_bottomsheet.dart';
import 'package:quikservnew/features/products/presentation/widgets/group_bottomsheet.dart';
import 'package:quikservnew/features/products/presentation/widgets/product_entry_widget.dart';

class ProductListingScreen extends StatefulWidget {
  final bool showAppBar;

  const ProductListingScreen({super.key, this.showAppBar = true});

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  String categoryName = "All Categories";
  String groupName = "All Groups";
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _groupController = TextEditingController();
  int? selectedCategoryId;
  int? selectedGroupId;
  @override
  void initState() {
    super.initState();
    _categoryController.text = categoryName;
    _groupController.text = groupName;
    context.read<ProductCubit>().loadProductsFromLocal();
    context.read<CategoriesCubit>().loadCategoriesFromLocal();
  }

  @override
  void dispose() {
    _categoryController.dispose();
    _groupController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: widget.showAppBar
          ? CommonAppBar(
              title: "Products",
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh, color: AppColors.black),
                  onPressed: () {
                    context.read<ProductCubit>().fetchProducts();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: AppColors.black),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ProductEntryUiOnlyScreen(
                          pageFrom: "list",
                          product: null,
                        ),
                      ),
                    );
                    if (result == true) {
                      context.read<ProductCubit>().fetchProducts();
                    }
                  },
                ),
              ],
            )
          : null,
      body: Stack(
        children: [
          Container(
            color: const Color(0xFFF2F2F2),
            child: Column(
              children: [
                // -------- TOP FILTER CARDS ----------
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            await showCategoryBottomSheet(
                              context: context,
                              categoryController: _categoryController,
                              onSelected: (id, name) {
                                setState(() {
                                  selectedCategoryId = id;
                                  categoryName = name;
                                });
                                // ✅ if All Categories selected (id == 0), load all
                                if (id == 0) {
                                  context
                                      .read<ProductCubit>()
                                      .loadProductsFromLocal();
                                  //context.read<ProductCubit>().fetchProducts();
                                } else {
                                  context
                                      .read<ProductCubit>()
                                      .loadProductsByCategory(id);
                                }
                              },
                              includeAllCategory: true,
                            );
                          },
                          child: filterCard(categoryName, "Being Displayed"),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            await showGroupBottomSheet(
                              context: context,
                              groupController: _groupController,
                              includeAllGroup: true,
                              onSelected: (id, name) {
                                setState(() {
                                  selectedGroupId = id;
                                  groupName = name;
                                });

                                // ✅ All Groups
                                if (id == 0) {
                                  context
                                      .read<ProductCubit>()
                                      .loadProductsFromLocal();
                                } else {
                                  context
                                      .read<ProductCubit>()
                                      .loadProductsByGroup(id);
                                }
                              },
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: filterCard(groupName, "Being Displayed"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // -------- PRODUCT LIST ----------
                Expanded(
                  child: BlocConsumer<ProductCubit, ProductsState>(
                    listener: (context, state) {
                      if (state is SaveProductSuccess) {
                        context.read<ProductCubit>().fetchProducts();
                      }
                      if (state is ProductDeleted) {
                        showAnimatedToast(
                          context,
                          message: "Product deleted successfully",
                          isSuccess: true,
                        );
                      }

                      if (state is ProductDeleteError) {
                        showAnimatedToast(
                          context,
                          message: state.error,
                          isSuccess: false,
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is ProductLoading ||
                          state is ProductsByCategoryLoading ||
                          state is ProductsByGroupLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is ProductLoadedFromLocal) {
                        final products = state.products;
                        if (products.isEmpty) {
                          return const Center(
                            child: Text(
                              "No products to list...",
                              style: TextStyle(color: Colors.red, fontSize: 15),
                            ),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.only(
                            left: 8,
                            right: 8,
                            bottom: 60,
                          ),
                          child: ListView.builder(
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              final item = products[index];
                              return SizedBox(
                                height: 130,
                                child: Card(
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: productTile(item, context),
                                ),
                              );
                            },
                          ),
                        );
                      } //  category products
                      if (state is ProductsByCategoryLoaded) {
                        final list = state.products;

                        return Padding(
                          padding: const EdgeInsets.only(
                            left: 8,
                            right: 8,
                            bottom: 60,
                          ),
                          child: ListView.builder(
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              final item = list[index];
                              return SizedBox(
                                height: 130,
                                child: Card(
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: productTile(item, context),
                                ),
                              );
                            },
                          ),
                        );
                      }

                      //  Category empty
                      if (state is ProductsByCategoryEmpty) {
                        return const Center(
                          child: Text(
                            "No products in this category",
                            style: TextStyle(color: Colors.red, fontSize: 15),
                          ),
                        );
                      }
                      // GROUP PRODUCTS
                      if (state is ProductsByGroupLoaded) {
                        final list = state.products;

                        return Padding(
                          padding: const EdgeInsets.only(
                            left: 8,
                            right: 8,
                            bottom: 60,
                          ),
                          child: ListView.builder(
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              final item = list[index];
                              return SizedBox(
                                height: 130,
                                child: Card(
                                  elevation: 1,
                                  child: productTile(item, context),
                                ),
                              );
                            },
                          ),
                        );
                      }

                      if (state is ProductsByGroupEmpty) {
                        return const Center(
                          child: Text(
                            "No products in this group",
                            style: TextStyle(color: Colors.red, fontSize: 15),
                          ),
                        );
                      } // 🔥 SERVER SUCCESS STATE
                      else if (state is ProductSuccess) {
                        final products = state.products;

                        if (products.productDetails!.isEmpty) {
                          return const Center(
                            child: Text(
                              "No products to list...",
                              style: TextStyle(color: Colors.red, fontSize: 15),
                            ),
                          );
                        }

                        return Padding(
                          padding: const EdgeInsets.only(
                            left: 8,
                            right: 8,
                            bottom: 60,
                          ),
                          child: ListView.builder(
                            itemCount: products.productDetails!.length,
                            itemBuilder: (context, index) {
                              final item = products.productDetails![index];
                              return SizedBox(
                                height: 130,
                                child: Card(
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: productTile(item, context),
                                ),
                              );
                            },
                          ),
                        );
                      } else if (state is ProductFailure) {
                        return Center(
                          child: Text(
                            "Error: ${state.error}",
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),

          // -------- BOTTOM ADD BUTTON ----------
          BottomAddButton(),
        ],
      ),
    );
  }
}
