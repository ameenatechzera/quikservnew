import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/core/utils/widgets/app_toast.dart';
import 'package:quikservnew/core/utils/widgets/common_appbar.dart';
import 'package:quikservnew/features/category/presentation/bloc/category_cubit.dart';
import 'package:quikservnew/features/products/domain/entities/fetch_product_entity.dart';
import 'package:quikservnew/features/products/presentation/bloc/products_cubit.dart';
import 'package:quikservnew/features/products/presentation/screens/product_entry_screen.dart';
import 'package:quikservnew/features/products/presentation/widgets/category_bottomsheet.dart';
import 'package:quikservnew/features/products/presentation/widgets/group_bottomsheet.dart';

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
    _categoryController.text = categoryName; // "All Categories"
    _groupController.text = groupName;
    // 🔹 Load products from local DB

    context
        .read<ProductCubit>()
        .fetchProducts(); // ✅ ensure categories are loaded for bottomsheet
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
                                  context.read<ProductCubit>().fetchProducts();
                                } else {
                                  context
                                      .read<ProductCubit>()
                                      .loadProductsByCategory(id);
                                }
                              },
                              includeAllCategory: true,
                            );
                          },
                          child: _filterCard(categoryName, "Being Displayed"),
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
                            child: _filterCard(groupName, "Being Displayed"),
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
                        // ✅ reload local DB after save
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
                      } else if (state is ProductSuccess) {
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
                                  child: _productTile(item),
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
                                  child: _productTile(item),
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
                                  child: _productTile(item),
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
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ProductEntryUiOnlyScreen(
                        pageFrom: "list",
                        //productCode: "",
                        product: null,
                      ),
                    ),
                  );

                  if (result == true) {
                    context.read<ProductCubit>().fetchProducts();
                  }
                },
                child: SizedBox(
                  height: 55,
                  width: 200,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    elevation: 10,
                    color: AppColors.primary,
                    child: const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Add New Product",
                              style: TextStyle(
                                fontSize: 15,
                                color: AppColors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Icon(Icons.add, color: AppColors.black),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterCard(String title, String subtitle) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      elevation: 5,
      shadowColor: Colors.grey.withOpacity(0.5),
      color: Colors.white,
      child: Container(
        height: 110,
        padding: const EdgeInsets.only(left: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(padding: const EdgeInsets.all(4.0), child: Text(subtitle)),
          ],
        ),
      ),
    );
  }

  Widget _productTile(FetchProductDetails item) {
    return ListTile(
      tileColor: Colors.white,
      contentPadding: EdgeInsets.zero,
      title: Column(
        children: [
          // ---- TOP ROW ----
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.productName ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      item.categoryName ?? '',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 25,
                        width: 25,
                        child: Image.asset(
                          "assets/icons/forwardicon.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, size: 20),
                    onSelected: (value) {
                      if (value == "edit") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductEntryUiOnlyScreen(
                              pageFrom: '',
                              product: item,
                              // 👈 pass selected product
                            ),
                          ),
                        );
                      }
                      if (value == "delete") {
                        _showDeleteConfirmDialog(
                          context: context,
                          productId: int.parse(
                            item.productCode.toString(),
                          ), // ✅ ensure not null
                        );
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: "edit",
                        height: 30,
                        child: Center(child: Text("Edit")),
                      ),
                      const PopupMenuItem(
                        value: "delete",
                        height: 30,
                        child: Center(
                          child: Text(
                            "Delete",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                    ],
                    constraints: const BoxConstraints(
                      minWidth: 100,
                      maxWidth: 120,
                    ),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ],
          ),
          // ---- BOTTOM 3 COLS ----
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _priceCol(
                  label: "Sale Price",
                  value: item.salesPrice?.toString() ?? '0',
                ),
                _priceCol(
                  label: "Purchase Price",
                  value: item.purchaseRate?.toString() ?? '0',
                ),
                _stockCol(label: "In Stock", value: '0'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceCol({required String label, required String value}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(label, style: const TextStyle(fontSize: 13)),
        ),
        RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 20, color: Colors.black),
            children: [
              const WidgetSpan(
                child: Icon(
                  Icons.currency_rupee,
                  size: 17,
                  color: Colors.black,
                ),
              ),
              TextSpan(
                text: " $value",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _stockCol({required String label, required String value}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(label, style: const TextStyle(fontSize: 13)),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ],
    );
  }

  void _showDeleteConfirmDialog({
    required BuildContext context,
    required int productId,
  }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Product"),
        content: const Text("Are you sure you want to delete this product?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              context.read<ProductCubit>().deleteProduct(productId);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
