import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/features/cart/data/models/cart_item_model.dart';
import 'package:quikservnew/features/cart/domain/usecases/cart_manager.dart';
import 'package:quikservnew/features/category/presentation/bloc/category_cubit.dart';
import 'package:quikservnew/features/products/domain/entities/fetch_product_entity.dart';
import 'package:quikservnew/features/products/presentation/bloc/products_cubit.dart';
import 'package:quikservnew/features/sale/presentation/bloc/sale_cubit.dart';
import 'package:quikservnew/features/sale/presentation/widgets/dashboard_content.dart';
import 'package:quikservnew/features/sale/presentation/widgets/cart_bottom_bar.dart';
import 'package:quikservnew/features/sale/presentation/widgets/category_list.dart';
import 'package:quikservnew/features/sale/presentation/widgets/common_bottom_bar.dart';
import 'package:quikservnew/features/sale/presentation/widgets/custom_search_icon.dart';
import 'package:quikservnew/features/sale/presentation/widgets/product_dialog.dart';
import 'package:quikservnew/features/sale/presentation/widgets/tabs.dart';
import 'package:quikservnew/features/sale/presentation/widgets/top_price_container_widget.dart';
import 'package:quikservnew/features/settings/presentation/screens/settings_dashboard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final CartManager cartManager;

  /// ✅ Category selection state (same as MenuScreen)
  // final ValueNotifier<int> selectedCategoryId = ValueNotifier<int>(0);
  // final ValueNotifier<String> selectedCategoryName = ValueNotifier<String>(
  //   'All',
  // );

  /// ✅ SIMPLE ValueNotifier for top tabs (Dine-In, Takeaway, Delivery)
  final ValueNotifier<int> selectedSaleTab = ValueNotifier<int>(0);

  // Add this: Current tab index (0: Sales, 1: Dashboard, 2: Settings)
  int _currentTabIndex = 0;

  // Search controller
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    cartManager = CartManager();
    requestBluetoothPermissions();

    // ✅ Load initial data ONCE (avoid calling inside build)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductCubit>().loadProductsFromLocal();
      context
          .read<CategoriesCubit>()
          .loadCategoriesFromLocal(); // ✅ init category in cubit
      context.read<SaleCubit>().resetCategory();
    });
    _searchController.addListener(() {
      context.read<SaleCubit>().updateSearchQuery(_searchController.text);
    });
  }

  @override
  void dispose() {
    // Dispose all ValueNotifiers
    selectedSaleTab.dispose();
    //  showSearchBar.dispose();
    showCartBar.dispose();
    //showMenuMode.dispose();
    // selectedCategoryId.dispose();
    // selectedCategoryName.dispose();
    _searchController.dispose();
    //_searchQuery.dispose();
    super.dispose();
  }

  // Method to filter products based on search query - PRODUCT NAME ONLY
  List<FetchProductDetails> _searchProducts(
    List<FetchProductDetails> products,
    String query,
  ) {
    if (query.isEmpty) return products;

    final lowercaseQuery = query.toLowerCase().trim();

    // Remove all spaces from query for space-insensitive search
    final queryWithoutSpaces = lowercaseQuery.replaceAll(' ', '');

    return products.where((product) {
      final productName = product.productName?.toLowerCase() ?? '';

      // Check 1: Direct contains in product name (with original spaces)
      if (productName.contains(lowercaseQuery)) {
        return true;
      }

      // Check 2: Space-insensitive search (remove spaces from product name)
      final productNameWithoutSpaces = productName.replaceAll(' ', '');
      if (productNameWithoutSpaces.contains(queryWithoutSpaces)) {
        return true;
      }

      // Check 3: Multi-word search (for queries with spaces)
      if (lowercaseQuery.contains(' ')) {
        final queryWords = lowercaseQuery
            .split(' ')
            .where((word) => word.isNotEmpty)
            .toList();

        // Check if ALL query words appear in the product name
        return queryWords.every((word) => productName.contains(word));
      }

      return false;
    }).toList();
  }

  // Added this method to handle tab switching
  void _switchTab(int index) {
    setState(() {
      _currentTabIndex = index;
      // Reset search and menu mode when switching away from Sales tab
      if (index != 0) {
        final saleCubit = context.read<SaleCubit>();
        saleCubit.hideSearchBar();
        saleCubit.disableMenuMode();
        _searchController.clear();
        saleCubit.clearSearchQuery();

        // ✅ reset category selection too
        saleCubit.resetCategory();
      }
    });
  }

  // Added this method to build the Sales content
  Widget _buildSalesContent() {
    return Column(
      children: [
        // Top Tabs
        Container(
          color: const Color(0xFFFFE38A),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: ValueListenableBuilder<int>(
              valueListenable: selectedSaleTab,
              builder: (context, selectedIndex, _) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildTab(
                      context,
                      "Dine-In",
                      selectedIndex == 0,
                      () => selectedSaleTab.value = 0,
                    ),
                    buildTab(
                      context,
                      "Takeaway",
                      selectedIndex == 1,
                      () => selectedSaleTab.value = 1,
                    ),
                    buildTab(
                      context,
                      "Delivery",
                      selectedIndex == 2,
                      () => selectedSaleTab.value = 2,
                    ),
                  ],
                );
              },
            ),
          ),
        ),

        // Top row (menu/search/close) – same row works for both modes
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: BlocBuilder<SaleCubit, SaleState>(
            builder: (context, state) {
              final saleCubit = context.read<SaleCubit>();
              final isMenuMode = context.read<SaleCubit>().isMenuMode;
              return Row(
                children: [
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: AppColors.black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        context.read<SaleCubit>().toggleMenuMode();

                        // Clear search when switching modes
                        if (context.read<SaleCubit>().isMenuMode) {
                          context.read<SaleCubit>().hideSearchBar();
                          _searchController.clear();
                          context.read<SaleCubit>().clearSearchQuery();
                        }
                      },
                      child: Center(
                        child: Icon(
                          isMenuMode ? Icons.arrow_back : Icons.menu,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // ✅ Title changes based on mode
                  Expanded(
                    child: isMenuMode
                        ? BlocBuilder<ProductCubit, ProductsState>(
                            builder: (context, state) {
                              int count = 0;
                              List<FetchProductDetails> products = [];

                              if (state is ProductSuccess) {
                                products = state.products.productDetails ?? [];
                              } else if (state is ProductsByCategoryLoaded) {
                                products = state.products;
                              } else if (state is ProductLoadedFromLocal) {
                                products = state.products;
                              }
                              // Apply search filter
                              // ✅ Get query from cubit
                              final query = context
                                  .read<SaleCubit>()
                                  .searchQuery;
                              products = _searchProducts(products, query);
                              count = products.length;
                              final catName = saleCubit.selectedCategoryName;
                              return Text("$catName ($count)");
                            },
                          )
                        : BlocBuilder<SaleCubit, SaleState>(
                            builder: (context, state) {
                              // ✅ Get query from cubit
                              final query = context
                                  .read<SaleCubit>()
                                  .searchQuery;
                              return BlocBuilder<ProductCubit, ProductsState>(
                                builder: (context, state) {
                                  int count = 0;
                                  if (state is ProductLoadedFromLocal) {
                                    final filteredProducts = _searchProducts(
                                      state.products,
                                      query,
                                    );
                                    count = filteredProducts.length;
                                  }
                                  return Text(
                                    query.isEmpty
                                        ? "All ($count)"
                                        : "Search Results ($count)",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  );
                                },
                              );
                            },
                          ),
                  ),

                  // ✅ Search Icon Button - Now using SaleCubit
                  BlocBuilder<SaleCubit, SaleState>(
                    builder: (context, state) {
                      return IconButton(
                        icon: CustomSearchIcon(
                          size: 22,
                          color: AppColors.black,
                        ),
                        onPressed: () {
                          // ✅ Using SaleCubit toggle method instead of ValueNotifier
                          context.read<SaleCubit>().toggleSearchBar();

                          // Clear search when closing search bar
                          if (!context.read<SaleCubit>().isSearchBarVisible) {
                            _searchController.clear();
                            context.read<SaleCubit>().clearSearchQuery();
                          }
                        },
                      );
                    },
                  ),

                  // ✅ Close button - Now using SaleCubit
                  BlocBuilder<SaleCubit, SaleState>(
                    builder: (context, state) {
                      final saleCubit = context.read<SaleCubit>();
                      return IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: AppColors.red,
                          size: 20,
                        ),
                        onPressed: () {
                          if (saleCubit.isSearchBarVisible) {
                            // ✅ Close search bar using SaleCubit
                            saleCubit.hideSearchBar();
                            _searchController.clear();
                            saleCubit.clearSearchQuery();
                          } else if (saleCubit.isMenuMode) {
                            saleCubit
                                .disableMenuMode(); // ✅ reset category and load all
                            saleCubit.resetCategory();
                            context
                                .read<ProductCubit>()
                                .loadProductsFromLocal();
                          }
                        },
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),

        // ✅ Search bar - Now using SaleCubit
        BlocBuilder<SaleCubit, SaleState>(
          builder: (context, state) {
            final isSearchVisible = context
                .read<SaleCubit>()
                .isSearchBarVisible;
            final searchQuery = context
                .read<SaleCubit>()
                .searchQuery; // ✅ Get query from cubit

            if (!isSearchVisible) return const SizedBox();

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "Search by product name",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: CustomSearchIcon(size: 22, color: Colors.grey),
                  ),
                  suffixIcon: searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                            context.read<SaleCubit>().clearSearchQuery();
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: Colors.grey[200],
                  filled: true,
                ),
                onChanged: (value) {},
              ),
            );
          },
        ),

        // // Search bar (show in BOTH modes when search is active)
        // ValueListenableBuilder<bool>(
        //   valueListenable: showSearchBar,
        //   builder: (context, searchVisible, _) {
        //     if (!searchVisible) return const SizedBox();

        //     return Padding(
        //       padding: const EdgeInsets.symmetric(horizontal: 12),
        //       child: TextField(
        //         controller: _searchController,
        //         autofocus: true,
        //         decoration: InputDecoration(
        //           hintText: "Search by product name",
        //           prefixIcon: Padding(
        //             padding: const EdgeInsets.all(10.0),
        //             child: CustomSearchIcon(size: 22, color: Colors.grey),
        //           ),
        //           suffixIcon: _searchQuery.value.isNotEmpty
        //               ? IconButton(
        //                   icon: const Icon(Icons.clear, color: Colors.grey),
        //                   onPressed: () {
        //                     _searchController.clear();
        //                     _searchQuery.value = '';
        //                   },
        //                 )
        //               : null,
        //           border: OutlineInputBorder(
        //             borderRadius: BorderRadius.circular(12),
        //             borderSide: BorderSide.none,
        //           ),
        //           fillColor: Colors.grey[200],
        //           filled: true,
        //         ),
        //         onChanged: (value) {
        //           _searchQuery.value = value.trim();
        //         },
        //       ),
        //     );
        //   },
        // ),

        // ✅ MAIN BODY SWITCH (NO ANIMATION / NO PAGE)
        Expanded(
          child: BlocBuilder<SaleCubit, SaleState>(
            builder: (context, state) {
              final isMenuMode = context.read<SaleCubit>().isMenuMode;
              final saleCubit = context.read<SaleCubit>();
              if (isMenuMode) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Categories
                    SizedBox(
                      width: 120,
                      child: BlocBuilder<CategoriesCubit, CategoryState>(
                        builder: (context, state) {
                          if (state is CategoryLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (state is CategoryLoadedFromLocal) {
                            return CategoryListWidget(
                              categories: state.categories,
                            );
                          }

                          if (state is CategoryEmpty) {
                            return const Center(
                              child: Text("No categories in local DB"),
                            );
                          }

                          if (state is CategoryError) {
                            return Center(child: Text(state.error));
                          }

                          return const SizedBox();
                        },
                      ),
                    ),

                    // Right Products Grid
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: BlocBuilder<ProductCubit, ProductsState>(
                          builder: (context, state) {
                            List<FetchProductDetails>? products;

                            if (state is ProductSuccess) {
                              products = state.products.productDetails;
                            } else if (state is ProductsByCategoryLoaded) {
                              products = state.products;
                            } else if (state is ProductLoadedFromLocal) {
                              products = state.products;
                            }

                            if (state is ProductLoading ||
                                state is ProductsByCategoryLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            if (products == null || products.isEmpty) {
                              return const Center(child: Text("No Products"));
                            }
                            // Apply search filter
                            return BlocBuilder<SaleCubit, SaleState>(
                              builder: (context, state) {
                                // ✅ Get query from cubit
                                final query = context
                                    .read<SaleCubit>()
                                    .searchQuery;

                                final filteredProducts = _searchProducts(
                                  products!,
                                  query,
                                );

                                if (filteredProducts.isEmpty &&
                                    query.isNotEmpty) {
                                  return Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.search_off,
                                          size: 60,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          "No products found",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        if (query.isNotEmpty)
                                          Text(
                                            "Search: '$query'",
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                }
                                return LayoutBuilder(
                                  builder: (context, constraints) {
                                    final double screenWidth =
                                        constraints.maxWidth;
                                    final double textScale = MediaQuery.of(
                                      context,
                                    ).textScaleFactor;

                                    double maxItemWidth = screenWidth > 600
                                        ? 200
                                        : 160;
                                    if (textScale > 1.0) {
                                      maxItemWidth +=
                                          30 * (textScale.clamp(1.0, 1.6) - 1);
                                    }

                                    double baseAspectRatio = 0.68;
                                    final double childAspectRatio =
                                        baseAspectRatio /
                                        textScale.clamp(1.0, 1.6);

                                    return GridView.builder(
                                      itemCount: filteredProducts.length,
                                      gridDelegate:
                                          SliverGridDelegateWithMaxCrossAxisExtent(
                                            maxCrossAxisExtent: maxItemWidth,
                                            childAspectRatio: childAspectRatio,
                                            crossAxisSpacing: 5,
                                            mainAxisSpacing: 5,
                                          ),
                                      itemBuilder: (context, index) {
                                        final product = filteredProducts[index];

                                        return Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: Container(
                                                width: double.infinity,
                                                color: const Color.fromARGB(
                                                  255,
                                                  232,
                                                  229,
                                                  229,
                                                ),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            5.0,
                                                          ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                        child: SizedBox(
                                                          height:
                                                              120 *
                                                              textScale.clamp(
                                                                1.0,
                                                                1.2,
                                                              ),
                                                          child: (() {
                                                            final Uint8List?
                                                            imageBytes =
                                                                decodeImage(
                                                                  product
                                                                      .productImageByte,
                                                                );

                                                            if (imageBytes !=
                                                                null) {
                                                              return Image.memory(
                                                                imageBytes,
                                                                fit: BoxFit
                                                                    .cover,
                                                              );
                                                            }

                                                            return Image.asset(
                                                              "assets/images/freepik__the-style-is-candid-image-photography-with-natural__16410.jpeg",
                                                              fit: BoxFit.cover,
                                                            );
                                                          })(),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            8.0,
                                                          ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            product.productName ??
                                                                "Product",
                                                            maxLines: 2,
                                                            style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                          Text(
                                                            product.groupName,
                                                            style:
                                                                const TextStyle(
                                                                  fontSize: 10,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),

                                            // Add / Qty
                                            Padding(
                                              padding: EdgeInsets.only(
                                                top:
                                                    90 *
                                                    textScale.clamp(1.0, 1.15),
                                                left: 10,
                                                right: 10,
                                              ),
                                              child: ValueListenableBuilder<List<CartItem>>(
                                                valueListenable:
                                                    cartManager.cartItems,
                                                builder: (context, cartItems, _) {
                                                  CartItem? cartItem;
                                                  try {
                                                    cartItem = cartItems
                                                        .firstWhere(
                                                          (item) =>
                                                              item.productCode ==
                                                              product
                                                                  .productCode,
                                                        );
                                                  } catch (e) {
                                                    cartItem = null;
                                                  }

                                                  if (cartItem == null) {
                                                    return GestureDetector(
                                                      onTap: () {
                                                        final items =
                                                            cartManager
                                                                .cartItems
                                                                .value;
                                                        final exists = items.any(
                                                          (e) =>
                                                              e.productCode ==
                                                              product
                                                                  .productCode,
                                                        );

                                                        if (exists) {
                                                          cartManager
                                                              .incrementQuantity(
                                                                product
                                                                    .productCode!,
                                                              );
                                                        } else {
                                                          cartManager.addToCart(
                                                            CartItem(
                                                              lineNo: 0,
                                                              customerId: 1,
                                                              productCode: product
                                                                  .productCode!,
                                                              productName: product
                                                                  .productName!,
                                                              qty: 1,
                                                              oldQty: 0,
                                                              salesRate:
                                                                  double.tryParse(
                                                                    product.salesPrice ??
                                                                        '0',
                                                                  ) ??
                                                                  0.0,
                                                              unitId: product
                                                                  .unitId
                                                                  .toString(),
                                                              purchaseCost: product
                                                                  .purchaseRate!,
                                                              groupId: product
                                                                  .group_id,
                                                              categoryId: product
                                                                  .categoryId!,
                                                              productImage: product
                                                                  .productImageByte!,
                                                              excludeRate: '',
                                                              subtotal: '0.0',
                                                              vatId: product
                                                                  .vatId!
                                                                  .toString(),
                                                              vatAmount: '0.0',
                                                              totalAmount:
                                                                  '0.00',
                                                              conversion_rate:
                                                                  product
                                                                      .conversionRate!,
                                                              category: product
                                                                  .categoryName!,
                                                              groupName: product
                                                                  .groupName,
                                                              product_description:
                                                                  '',
                                                            ),
                                                          );
                                                          showCartBar.value =
                                                              true;
                                                        }
                                                      },
                                                      child: Container(
                                                        height: 30,
                                                        decoration: BoxDecoration(
                                                          color: const Color(
                                                            0xFFEAB307,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                5,
                                                              ),
                                                        ),
                                                        child: const Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              Icons.add,
                                                              size: 15,
                                                            ),
                                                            SizedBox(width: 4),
                                                            Text(
                                                              'Add',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  }

                                                  return Container(
                                                    height: 30,
                                                    width: 120,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            5,
                                                          ),
                                                      border: Border.all(
                                                        color:
                                                            AppColors.primary,
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            cartManager
                                                                .decrementQuantity(
                                                                  cartItem!
                                                                      .productCode,
                                                                );
                                                          },
                                                          child: const SizedBox(
                                                            width: 30,
                                                            child: Center(
                                                              child: Icon(
                                                                Icons.remove,
                                                                size: 20,
                                                                color: AppColors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        MediaQuery(
                                                          data:
                                                              MediaQuery.of(
                                                                context,
                                                              ).copyWith(
                                                                textScaleFactor:
                                                                    1.0,
                                                              ),
                                                          child: Text(
                                                            cartItem.qty
                                                                .toString(),
                                                            style:
                                                                const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            cartManager
                                                                .incrementQuantity(
                                                                  cartItem!
                                                                      .productCode,
                                                                );
                                                          },
                                                          child: Container(
                                                            width: 30,
                                                            color: const Color(
                                                              0xFFffeeb7,
                                                            ),
                                                            child: const Center(
                                                              child: Icon(
                                                                Icons.add,
                                                                size: 20,
                                                                color: AppColors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),

                                            TopPriceContainer(
                                              price: product.salesPrice,
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              }

              // ================= NORMAL HOME GRID (your existing) =================
              return BlocBuilder<ProductCubit, ProductsState>(
                builder: (context, state) {
                  if (state is ProductLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ProductLoadedFromLocal) {
                    final allProducts = state.products;

                    if (allProducts.isEmpty) {
                      return const Center(child: Text("No products available"));
                    }

                    return BlocBuilder<SaleCubit, SaleState>(
                      builder: (context, state) {
                        // ✅ Get query from cubit
                        final query = context.read<SaleCubit>().searchQuery;

                        final filteredProducts = _searchProducts(
                          allProducts,
                          query,
                        );

                        if (filteredProducts.isEmpty && query.isNotEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.search_off,
                                  size: 60,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "No products found",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                if (query.isNotEmpty)
                                  Text(
                                    "Search: '$query'",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }

                        final products = filteredProducts;

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final screenWidth = MediaQuery.of(
                                context,
                              ).size.width;
                              final textScale = MediaQuery.of(
                                context,
                              ).textScaleFactor;

                              double maxWidthPerItem = screenWidth > 600
                                  ? 180
                                  : 160;
                              if (textScale > 1.2) maxWidthPerItem += 30;

                              double baseAspectRatio = screenWidth > 600
                                  ? 0.8
                                  : 0.71;
                              final childAspectRatio =
                                  baseAspectRatio / textScale.clamp(1.0, 1.7);

                              double imageHeight = 120;
                              if (textScale > 1.0) {
                                imageHeight = 120 * textScale.clamp(1.0, 1.2);
                              }

                              return GridView.builder(
                                itemCount: products.length,
                                gridDelegate:
                                    SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: maxWidthPerItem,
                                      childAspectRatio: childAspectRatio,
                                      crossAxisSpacing: 5,
                                      mainAxisSpacing: 5,
                                    ),
                                itemBuilder: (context, index) {
                                  final product = products[index];

                                  return Stack(
                                    children: [
                                      // ================= MAIN CARD =================
                                      GestureDetector(
                                        onTap: () {
                                          final items =
                                              cartManager.cartItems.value;
                                          final exists = items.any(
                                            (e) =>
                                                e.productCode ==
                                                product.productCode,
                                          );

                                          if (exists) {
                                            cartManager.incrementQuantity(
                                              product.productCode!,
                                            );
                                          } else {
                                            cartManager.addToCart(
                                              CartItem(
                                                lineNo: 0,
                                                customerId: 1,
                                                productCode:
                                                    product.productCode!,
                                                productName:
                                                    product.productName!,
                                                qty: 1,
                                                oldQty: 0,
                                                salesRate:
                                                    double.tryParse(
                                                      product.salesPrice ?? '0',
                                                    ) ??
                                                    0.0,
                                                unitId: product.unitId
                                                    .toString(),
                                                purchaseCost:
                                                    product.purchaseRate!,
                                                groupId: product.group_id,
                                                categoryId: product.categoryId!,
                                                productImage:
                                                    product.productImageByte!,
                                                excludeRate: '',
                                                subtotal: '0.0',
                                                vatId: product.vatId!
                                                    .toString(),
                                                vatAmount: '0.0',
                                                totalAmount: '0.00',
                                                conversion_rate:
                                                    product.conversionRate!,
                                                category: product.categoryName!,
                                                groupName: product.groupName,
                                                product_description: '',
                                              ),
                                            );
                                            showCartBar.value = true;
                                          }
                                        },
                                        onLongPress: () => showProductDialog(
                                          context,
                                          product,
                                          cartManager,
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child: Container(
                                            color: const Color.fromARGB(
                                              255,
                                              232,
                                              229,
                                              229,
                                            ),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                    5.0,
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                    child: SizedBox(
                                                      height: imageHeight,
                                                      child: (() {
                                                        final Uint8List?
                                                        imageBytes = decodeImage(
                                                          product
                                                              .productImageByte,
                                                        );

                                                        if (imageBytes !=
                                                            null) {
                                                          return Image.memory(
                                                            imageBytes,
                                                            fit: BoxFit.cover,
                                                          );
                                                        }

                                                        return Image.asset(
                                                          "assets/images/freepik__the-style-is-candid-image-photography-with-natural__16410.jpeg",
                                                          fit: BoxFit.cover,
                                                        );
                                                      })(),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 4,
                                                      ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Expanded(
                                                        flex: 5,
                                                        child: Text(
                                                          product.productName!,
                                                          maxLines: 2,
                                                          softWrap: true,
                                                          style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 11,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child:
                                                            productGroupBagde(
                                                              context,
                                                              product.groupName,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),

                                      // ================= ADD / QTY OVERLAY =================
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 90,
                                          left: 10,
                                          right: 10,
                                        ),
                                        child: ValueListenableBuilder<List<CartItem>>(
                                          valueListenable:
                                              cartManager.cartItems,
                                          builder: (context, cartItems, _) {
                                            CartItem? cartItem;

                                            try {
                                              cartItem = cartItems.firstWhere(
                                                (item) =>
                                                    item.productCode ==
                                                    product.productCode,
                                              );
                                            } catch (e) {
                                              cartItem = null;
                                            }

                                            // ---------- ADD BUTTON ----------
                                            if (cartItem == null) {
                                              return GestureDetector(
                                                onTap: () {
                                                  cartManager.addToCart(
                                                    CartItem(
                                                      lineNo: 0,
                                                      customerId: 1,
                                                      productCode:
                                                          product.productCode!,
                                                      productName:
                                                          product.productName!,
                                                      qty: 1,
                                                      oldQty: 0,
                                                      salesRate:
                                                          double.tryParse(
                                                            product.salesPrice ??
                                                                '0',
                                                          ) ??
                                                          0.0,
                                                      unitId: product.unitId
                                                          .toString(),
                                                      purchaseCost:
                                                          product.purchaseRate!,
                                                      groupId: product.group_id,
                                                      categoryId:
                                                          product.categoryId!,
                                                      productImage: product
                                                          .productImageByte!,
                                                      excludeRate: '',
                                                      subtotal: '0.0',
                                                      vatId: product.vatId!
                                                          .toString(),
                                                      vatAmount: '0.0',
                                                      totalAmount: '0.00',
                                                      conversion_rate: product
                                                          .conversionRate!,
                                                      category:
                                                          product.categoryName!,
                                                      groupName:
                                                          product.groupName,
                                                      product_description: '',
                                                    ),
                                                  );
                                                  showCartBar.value = true;
                                                },
                                                child: Container(
                                                  height: 30,
                                                  width: 200,
                                                  decoration: BoxDecoration(
                                                    color: AppColors.primary,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          5,
                                                        ),
                                                  ),
                                                  child: const Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(Icons.add, size: 15),
                                                      SizedBox(width: 4),
                                                      Text(
                                                        'Add',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }

                                            // ---------- QTY CONTROLLER ----------
                                            return Container(
                                              height: 30,
                                              width: 120,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                border: Border.all(
                                                  color: AppColors.primary,
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      cartManager
                                                          .decrementQuantity(
                                                            cartItem!
                                                                .productCode,
                                                          );
                                                    },
                                                    child: const SizedBox(
                                                      width: 30,
                                                      child: Center(
                                                        child: Icon(
                                                          Icons.remove,
                                                          size: 20,
                                                          color:
                                                              AppColors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  MediaQuery(
                                                    data: MediaQuery.of(context)
                                                        .copyWith(
                                                          textScaleFactor: 1.0,
                                                        ),
                                                    child: Text(
                                                      (cartItem.qty % 1 == 0)
                                                          ? cartItem.qty
                                                                .toInt()
                                                                .toString()
                                                          : cartItem.qty
                                                                .toString(),
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      cartManager
                                                          .incrementQuantity(
                                                            cartItem!
                                                                .productCode,
                                                          );
                                                    },
                                                    child: Container(
                                                      width: 30,
                                                      color: const Color(
                                                        0xFFffeeb7,
                                                      ),
                                                      child: const Center(
                                                        child: Icon(
                                                          Icons.add,
                                                          size: 20,
                                                          color:
                                                              AppColors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),

                                      // ================= PRICE BADGE =================
                                      // TopPriceContainer(
                                      //   price: product.salesPrice,
                                      // ),
                                      ValueListenableBuilder<List<CartItem>>(
                                        valueListenable: cartManager.cartItems,
                                        builder: (context, cartItems, _) {
                                          CartItem? cartItem;
                                          try {
                                            cartItem = cartItems.firstWhere(
                                              (item) =>
                                                  item.productCode ==
                                                  product.productCode,
                                            );
                                          } catch (_) {
                                            cartItem = null;
                                          }

                                          final String priceToShow =
                                              cartItem != null
                                              ? cartItem.salesRate
                                                    .toStringAsFixed(2)
                                              : (product.salesPrice ?? '0');

                                          return TopPriceContainer(
                                            price: priceToShow,
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        );
                      },
                    );
                  }
                  return const SizedBox();
                },
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Show content based on current tab
            if (_currentTabIndex == 0)
              _buildSalesContent()
            else if (_currentTabIndex == 1)
              DashboardContent() // Your existing DashboardScreen
            else
              SettingsScreen(), // Your existing PrinterSettingsScreen
            // Bottom bar (always visible)
            CommomBottomBar(
              currentTabIndex: _currentTabIndex,
              onTabChanged: _switchTab,
            ), // CART BAR (same)
            ValueListenableBuilder<bool>(
              valueListenable: showCartBar,
              builder: (context, visible, _) {
                if (!visible) return const SizedBox();
                return Positioned(
                  left: 20,
                  right: 20,
                  bottom: 80,
                  child: cartBottomBar(context),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Uint8List? decodeImage(String? base64String) {
    if (base64String == null || base64String.isEmpty) return null;
    try {
      return base64Decode(base64String);
    } catch (e) {
      return null;
    }
  }

  Widget productGroupBagde(BuildContext context, String? groupName) {
    String firstLetter = "?";
    if (groupName != null && groupName.trim().isNotEmpty) {
      firstLetter = groupName.trim()[0].toUpperCase();
    }

    final textScale = MediaQuery.of(context).textScaleFactor;
    final double badgeSize = (16 * textScale).clamp(16.0, 30.0);
    final double fontSize = (9 * textScale).clamp(9.0, 16.0);

    return Container(
      width: badgeSize,
      height: badgeSize,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        firstLetter,
        style: TextStyle(
          color: AppColors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          height: 1,
        ),
      ),
    );
  }

  void showProductDialog(
    BuildContext context,
    FetchProductDetails product,
    CartManager cartManager,
  ) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 24,
          ),
          child: ProductDialogContent(
            product: product,
            cartManager: cartManager,
          ),
        );
      },
    );
  }

  Future<void> requestBluetoothPermissions() async {
    if (await Permission.bluetoothConnect.isDenied) {
      await Permission.bluetoothConnect.request();
    }

    if (await Permission.bluetoothScan.isDenied) {
      await Permission.bluetoothScan.request();
    }

    if (await Permission.location.isDenied) {
      await Permission.location.request();
    }
  }
}
