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
import 'package:quikservnew/features/sale/presentation/widgets/cart_bottom_bar.dart';
import 'package:quikservnew/features/sale/presentation/widgets/category_list.dart';
import 'package:quikservnew/features/sale/presentation/widgets/common_bottom_bar.dart';
import 'package:quikservnew/features/sale/presentation/widgets/custom_search_icon.dart';
import 'package:quikservnew/features/sale/presentation/widgets/product_dialog.dart';
import 'package:quikservnew/features/sale/presentation/widgets/tabs.dart';
import 'package:quikservnew/features/sale/presentation/widgets/top_price_container_widget.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ValueNotifier<bool> showSearchBar = ValueNotifier(false);
  final ValueNotifier<bool> showCartBar = ValueNotifier(false);

  /// ✅ THIS controls your requirement
  final ValueNotifier<bool> showMenuMode = ValueNotifier(false);

  /// ✅ Category selection state (same as MenuScreen)
  final ValueNotifier<int> selectedCategoryId = ValueNotifier<int>(0);
  final ValueNotifier<String> selectedCategoryName = ValueNotifier<String>(
    'All',
  );
  // Search controller
  final TextEditingController _searchController = TextEditingController();
  final ValueNotifier<String> _searchQuery = ValueNotifier<String>('');

  @override
  void initState() {
    super.initState();
    requestBluetoothPermissions();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFFffeeb7),
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
    ); // Listen to search controller changes
    _searchController.addListener(() {
      _searchQuery.value = _searchController.text.trim();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchQuery.dispose();
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

  @override
  Widget build(BuildContext context) {
    final CartManager cartManager = CartManager();

    // Load initial data (keeping your style)
    context.read<ProductCubit>().loadProductsFromLocal();
    context.read<CategoriesCubit>().loadCategoriesFromLocal();

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Top Tabs
                Container(
                  color: const Color(0xFFffeeb7),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: BlocBuilder<SaleCubit, SaleState>(
                      builder: (context, state) {
                        final selectedIndex = context
                            .read<SaleCubit>()
                            .selectedTabIndex;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buildTab(
                              context,
                              "Dine-In",
                              selectedIndex == 0,
                              () => context.read<SaleCubit>().selectTab(0),
                            ),
                            buildTab(
                              context,
                              "Takeaway",
                              selectedIndex == 1,
                              () => context.read<SaleCubit>().selectTab(1),
                            ),
                            buildTab(
                              context,
                              "Delivery",
                              selectedIndex == 2,
                              () => context.read<SaleCubit>().selectTab(2),
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
                  child: ValueListenableBuilder<bool>(
                    valueListenable: showMenuMode,
                    builder: (context, menuVisible, _) {
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
                                // ✅ Toggle between normal grid & menu mode
                                showMenuMode.value = !showMenuMode.value;

                                // Clear search when switching modes
                                if (showMenuMode.value) {
                                  showSearchBar.value = false;
                                  _searchController.clear();
                                  _searchQuery.value = '';
                                }
                              },
                              child: Center(
                                child: Icon(
                                  menuVisible ? Icons.arrow_back : Icons.menu,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),

                          // ✅ Title changes based on mode
                          Expanded(
                            child: menuVisible
                                ? BlocBuilder<ProductCubit, ProductsState>(
                                    builder: (context, state) {
                                      int count = 0;
                                      List<FetchProductDetails> products = [];

                                      if (state is ProductSuccess) {
                                        products =
                                            state.products.productDetails ?? [];
                                      } else if (state
                                          is ProductsByCategoryLoaded) {
                                        products = state.products;
                                      } else if (state
                                          is ProductLoadedFromLocal) {
                                        products = state.products;
                                      }
                                      // Apply search filter
                                      products = _searchProducts(
                                        products,
                                        _searchQuery.value,
                                      );
                                      count = products.length;
                                      return ValueListenableBuilder<String>(
                                        valueListenable: selectedCategoryName,
                                        builder: (context, name, _) {
                                          return Text("$name ($count)");
                                        },
                                      );
                                    },
                                  )
                                : ValueListenableBuilder<String>(
                                    valueListenable: _searchQuery,
                                    builder: (context, query, _) {
                                      return BlocBuilder<
                                        ProductCubit,
                                        ProductsState
                                      >(
                                        builder: (context, state) {
                                          int count = 0;
                                          if (state is ProductLoadedFromLocal) {
                                            final filteredProducts =
                                                _searchProducts(
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

                          IconButton(
                            icon: CustomSearchIcon(
                              size: 22,
                              color: AppColors.black,
                            ),
                            onPressed: () {
                              showSearchBar.value = !showSearchBar.value;
                              if (!showSearchBar.value) {
                                // Clear search when closing search bar
                                _searchController.clear();
                                _searchQuery.value = '';
                              }
                            },
                          ),

                          IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: AppColors.red,
                              size: 20,
                            ),
                            onPressed: () {
                              // ✅ close menu mode if open, otherwise do nothing
                              if (showSearchBar.value) {
                                // Close search bar if open
                                showSearchBar.value = false;
                                _searchController.clear();
                                _searchQuery.value = '';
                              } else if (showMenuMode.value) {
                                // Close menu mode if open
                                showMenuMode.value = false;
                              }
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),

                // Search bar (show in BOTH modes when search is active)
                ValueListenableBuilder<bool>(
                  valueListenable: showSearchBar,
                  builder: (context, searchVisible, _) {
                    if (!searchVisible) return const SizedBox();

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: "Search by product name",
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: CustomSearchIcon(
                              size: 22,
                              color: Colors.grey,
                            ),
                          ),
                          suffixIcon: _searchQuery.value.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.clear,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    _searchController.clear();
                                    _searchQuery.value = '';
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
                        onChanged: (value) {
                          _searchQuery.value = value.trim();
                        },
                      ),
                    );
                  },
                ),

                // ✅ MAIN BODY SWITCH (NO ANIMATION / NO PAGE)
                Expanded(
                  child: ValueListenableBuilder<bool>(
                    valueListenable: showMenuMode,
                    builder: (context, menuVisible, _) {
                      // ================= MENU MODE (Category + Products) =================
                      if (menuVisible) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left Categories
                            SizedBox(
                              width: 120,
                              child:
                                  BlocBuilder<CategoriesCubit, CategoryState>(
                                    builder: (context, state) {
                                      if (state is CategoryLoading) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }

                                      if (state is CategoryLoadedFromLocal) {
                                        return CategoryListWidget(
                                          categories: state.categories,
                                          selectedCategoryId:
                                              selectedCategoryId,
                                          selectedCategoryName:
                                              selectedCategoryName,
                                        );
                                      }

                                      if (state is CategoryEmpty) {
                                        return const Center(
                                          child: Text(
                                            "No categories in local DB",
                                          ),
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
                                    } else if (state
                                        is ProductsByCategoryLoaded) {
                                      products = state.products;
                                    } else if (state
                                        is ProductLoadedFromLocal) {
                                      products = state.products;
                                    }

                                    if (state is ProductLoading ||
                                        state is ProductsByCategoryLoading) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }

                                    if (products == null || products.isEmpty) {
                                      return const Center(
                                        child: Text("No Products"),
                                      );
                                    }
                                    // Apply search filter
                                    return ValueListenableBuilder<String>(
                                      valueListenable: _searchQuery,
                                      builder: (context, query, _) {
                                        final filteredProducts =
                                            _searchProducts(products!, query);

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
                                            final double textScale =
                                                MediaQuery.of(
                                                  context,
                                                ).textScaleFactor;

                                            double maxItemWidth =
                                                screenWidth > 600 ? 200 : 160;
                                            if (textScale > 1.0) {
                                              maxItemWidth +=
                                                  30 *
                                                  (textScale.clamp(1.0, 1.6) -
                                                      1);
                                            }

                                            double baseAspectRatio = 0.68;
                                            final double childAspectRatio =
                                                baseAspectRatio /
                                                textScale.clamp(1.0, 1.6);

                                            return GridView.builder(
                                              itemCount: products!.length,
                                              gridDelegate:
                                                  SliverGridDelegateWithMaxCrossAxisExtent(
                                                    maxCrossAxisExtent:
                                                        maxItemWidth,
                                                    childAspectRatio:
                                                        childAspectRatio,
                                                    crossAxisSpacing: 5,
                                                    mainAxisSpacing: 5,
                                                  ),
                                              itemBuilder: (context, index) {
                                                final product =
                                                    products![index];

                                                return Stack(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                      child: Container(
                                                        width: double.infinity,
                                                        color:
                                                            const Color.fromARGB(
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
                                                                      textScale
                                                                          .clamp(
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
                                                                      fit: BoxFit
                                                                          .cover,
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
                                                                      fontSize:
                                                                          12,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    product
                                                                        .groupName,
                                                                    style: const TextStyle(
                                                                      fontSize:
                                                                          10,
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
                                                            textScale.clamp(
                                                              1.0,
                                                              1.15,
                                                            ),
                                                        left: 10,
                                                        right: 10,
                                                      ),
                                                      child: ValueListenableBuilder<List<CartItem>>(
                                                        valueListenable:
                                                            cartManager
                                                                .cartItems,
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

                                                          if (cartItem ==
                                                              null) {
                                                            return GestureDetector(
                                                              onTap: () {
                                                                cartManager.addToCart(
                                                                  CartItem(
                                                                    lineNo: 0,
                                                                    customerId:
                                                                        1,
                                                                    productCode:
                                                                        product
                                                                            .productCode!,
                                                                    productName:
                                                                        product
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
                                                                    purchaseCost:
                                                                        product
                                                                            .purchaseRate!,
                                                                    groupId: product
                                                                        .group_id,
                                                                    categoryId:
                                                                        product
                                                                            .categoryId!,
                                                                    productImage:
                                                                        product
                                                                            .productImageByte!,
                                                                    excludeRate:
                                                                        '',
                                                                    subtotal:
                                                                        '0.0',
                                                                    vatId: product
                                                                        .vatId!
                                                                        .toString(),
                                                                    vatAmount:
                                                                        '0.0',
                                                                    totalAmount:
                                                                        '0.00',
                                                                    conversion_rate:
                                                                        product
                                                                            .conversionRate!,
                                                                    category:
                                                                        product
                                                                            .categoryName!,
                                                                    groupName:
                                                                        product
                                                                            .groupName,
                                                                    product_description:
                                                                        '',
                                                                  ),
                                                                );
                                                                showCartBar
                                                                        .value =
                                                                    true;
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
                                                                    SizedBox(
                                                                      width: 4,
                                                                    ),
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

                                                          return Container(
                                                            height: 30,
                                                            width: 120,
                                                            decoration: BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    5,
                                                                  ),
                                                              border: Border.all(
                                                                color: AppColors
                                                                    .primary,
                                                              ),
                                                            ),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                InkWell(
                                                                  onTap: () {
                                                                    cartManager.decrementQuantity(
                                                                      cartItem!
                                                                          .productCode,
                                                                    );
                                                                  },
                                                                  child: const SizedBox(
                                                                    width: 30,
                                                                    child: Center(
                                                                      child: Icon(
                                                                        Icons
                                                                            .remove,
                                                                        size:
                                                                            20,
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
                                                                    style: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ),
                                                                InkWell(
                                                                  onTap: () {
                                                                    cartManager.incrementQuantity(
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
                                                                        Icons
                                                                            .add,
                                                                        size:
                                                                            20,
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
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (state is ProductLoadedFromLocal) {
                            final allProducts = state.products;

                            if (allProducts.isEmpty) {
                              return const Center(
                                child: Text("No products available"),
                              );
                            }

                            return ValueListenableBuilder<String>(
                              valueListenable: _searchQuery,
                              builder: (context, query, _) {
                                final filteredProducts = _searchProducts(
                                  allProducts,
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
                                      if (textScale > 1.2)
                                        maxWidthPerItem += 30;

                                      double baseAspectRatio = screenWidth > 600
                                          ? 0.8
                                          : 0.71;
                                      final childAspectRatio =
                                          baseAspectRatio /
                                          textScale.clamp(1.0, 1.7);

                                      double imageHeight = 120;
                                      if (textScale > 1.0) {
                                        imageHeight =
                                            120 * textScale.clamp(1.0, 1.2);
                                      }

                                      return GridView.builder(
                                        itemCount: products.length,
                                        gridDelegate:
                                            SliverGridDelegateWithMaxCrossAxisExtent(
                                              maxCrossAxisExtent:
                                                  maxWidthPerItem,
                                              childAspectRatio:
                                                  childAspectRatio,
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
                                                onLongPress: () =>
                                                    showProductDialog(
                                                      context,
                                                      product,
                                                      cartManager,
                                                    ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
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
                                                                  imageHeight,
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
                                                                  fit: BoxFit
                                                                      .cover,
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
                                                                  product
                                                                      .productName!,
                                                                  maxLines: 2,
                                                                  softWrap:
                                                                      true,
                                                                  style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        11,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 1,
                                                                child: productGroupBagde(
                                                                  context,
                                                                  product
                                                                      .groupName,
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

                                                    // ---------- ADD BUTTON ----------
                                                    if (cartItem == null) {
                                                      return GestureDetector(
                                                        onTap: () {
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
                                                        },
                                                        child: Container(
                                                          height: 30,
                                                          width: 200,
                                                          decoration: BoxDecoration(
                                                            color: AppColors
                                                                .primary,
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
                                                              SizedBox(
                                                                width: 4,
                                                              ),
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

                                                    // ---------- QTY CONTROLLER ----------
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
                                                                  color:
                                                                      AppColors
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
                                                              (cartItem.qty %
                                                                          1 ==
                                                                      0)
                                                                  ? cartItem.qty
                                                                        .toInt()
                                                                        .toString()
                                                                  : cartItem.qty
                                                                        .toString(),
                                                              style: const TextStyle(
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
                                                              color:
                                                                  const Color(
                                                                    0xFFffeeb7,
                                                                  ),
                                                              child: const Center(
                                                                child: Icon(
                                                                  Icons.add,
                                                                  size: 20,
                                                                  color:
                                                                      AppColors
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

                                              // ================= PRICE BADGE =================
                                              TopPriceContainer(
                                                price: product.salesPrice,
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

                      //                     return BlocBuilder<ProductCubit, ProductsState>(
                      //                       builder: (context, state) {
                      //                         if (state is ProductLoading) {
                      //                           return const Center(
                      //                             child: CircularProgressIndicator(),
                      //                           );
                      //                         } else if (state is ProductLoadedFromLocal) {
                      //                           final products = state.products;

                      //                           if (products.isEmpty) {
                      //                             return const Center(
                      //                               child: Text("No products available"),
                      //                             );
                      //                           }

                      //                           return Padding(
                      //                             padding: const EdgeInsets.all(8.0),
                      //                             child: LayoutBuilder(
                      //                               builder: (context, constraints) {
                      //                                 final screenWidth =
                      //                                     MediaQuery.of(context).size.width;
                      //                                 final textScale =
                      //                                     MediaQuery.of(context).textScaleFactor;

                      //                                 double maxWidthPerItem =
                      //                                     screenWidth > 600 ? 180 : 160;
                      //                                 if (textScale > 1.2) maxWidthPerItem += 30;

                      //                                 double baseAspectRatio =
                      //                                     screenWidth > 600 ? 0.8 : 0.75;
                      //                                 final childAspectRatio =
                      //                                     baseAspectRatio /
                      //                                     textScale.clamp(1.0, 1.7);

                      //                                 double imageHeight = 120;
                      //                                 if (textScale > 1.0) {
                      //                                   imageHeight =
                      //                                       120 * textScale.clamp(1.0, 1.2);
                      //                                 }

                      //                                 return GridView.builder(
                      //                                   itemCount: products.length,
                      //                                   gridDelegate:
                      //                                       SliverGridDelegateWithMaxCrossAxisExtent(
                      //                                         maxCrossAxisExtent: maxWidthPerItem,
                      //                                         childAspectRatio: childAspectRatio,
                      //                                         crossAxisSpacing: 5,
                      //                                         mainAxisSpacing: 5,
                      //                                       ),
                      //                                   itemBuilder: (context, index) {
                      //                                     final product = products[index];

                      //                                     return Stack(
                      //                                       children: [
                      //                                         GestureDetector(
                      //                                           onTap: () {
                      //                                             cartManager.addToCart(
                      //                                               CartItem(
                      //                                                 lineNo: 0,
                      //                                                 customerId: 1,
                      //                                                 productCode:
                      //                                                     product.productCode!,
                      //                                                 productName:
                      //                                                     product.productName!,
                      //                                                 qty: 1,
                      //                                                 oldQty: 0,
                      //                                                 salesRate:
                      //                                                     double.tryParse(
                      //                                                       product.salesPrice ??
                      //                                                           '0',
                      //                                                     ) ??
                      //                                                     0.0,
                      //                                                 unitId:
                      //                                                     product.unitId.toString(),
                      //                                                 purchaseCost:
                      //                                                     product.purchaseRate!,
                      //                                                 groupId: product.group_id,
                      //                                                 categoryId:
                      //                                                     product.categoryId!,
                      //                                                 productImage:
                      //                                                     product.productImageByte!,
                      //                                                 excludeRate: '',
                      //                                                 subtotal: '0.0',
                      //                                                 vatId:
                      //                                                     product.vatId!.toString(),
                      //                                                 vatAmount: '0.0',
                      //                                                 totalAmount: '0.00',
                      //                                                 conversion_rate:
                      //                                                     product.conversionRate!,
                      //                                                 category:
                      //                                                     product.categoryName!,
                      //                                                 groupName: product.groupName,
                      //                                                 product_description: '',
                      //                                               ),
                      //                                             );
                      //                                             showCartBar.value = true;
                      //                                           },
                      //                                           onLongPress:
                      //                                               () => showProductDialog(
                      //                                                 context,
                      //                                                 product,
                      //                                                 cartManager,
                      //                                               ),
                      //                                           child: ClipRRect(
                      //                                             borderRadius:
                      //                                                 BorderRadius.circular(12),
                      //                                             child: Container(
                      //                                               color: const Color.fromARGB(
                      //                                                 255,
                      //                                                 232,
                      //                                                 229,
                      //                                                 229,
                      //                                               ),
                      //                                               child: Column(
                      //                                                 children: [
                      //                                                   Padding(
                      //                                                     padding:
                      //                                                         const EdgeInsets.all(
                      //                                                           5.0,
                      //                                                         ),
                      //                                                     child: ClipRRect(
                      //                                                       borderRadius:
                      //                                                           BorderRadius.circular(
                      //                                                             12,
                      //                                                           ),
                      //                                                       child: SizedBox(
                      //                                                         height: imageHeight,
                      //                                                         child:
                      //                                                             (() {
                      //                                                               final Uint8List?
                      //                                                               imageBytes =
                      //                                                                   decodeImage(
                      //                                                                     product
                      //                                                                         .productImageByte,
                      //                                                                   );

                      //                                                               if (imageBytes !=
                      //                                                                   null) {
                      //                                                                 return Image.memory(
                      //                                                                   imageBytes,
                      //                                                                   fit:
                      //                                                                       BoxFit
                      //                                                                           .cover,
                      //                                                                 );
                      //                                                               }

                      //                                                               return Image.asset(
                      //                                                                 "assets/images/freepik__the-style-is-candid-image-photography-with-natural__16410.jpeg",
                      //                                                                 fit:
                      //                                                                     BoxFit
                      //                                                                         .cover,
                      //                                                               );
                      //                                                             })(),
                      //                                                       ),
                      //                                                     ),
                      //                                                   ),
                      //                                                   Padding(
                      //                                                     padding:
                      //                                                         const EdgeInsets.symmetric(
                      //                                                           horizontal: 8,
                      //                                                           vertical: 4,
                      //                                                         ),
                      //                                                     child: Row(
                      //                                                       mainAxisAlignment:
                      //                                                           MainAxisAlignment
                      //                                                               .spaceBetween,
                      //                                                       crossAxisAlignment:
                      //                                                           CrossAxisAlignment
                      //                                                               .start,
                      //                                                       children: [
                      //                                                         Expanded(
                      //                                                           flex: 2,
                      //                                                           child: Text(
                      //                                                             product
                      //                                                                 .productName!,
                      //                                                             maxLines: 2,
                      //                                                             softWrap: true,
                      //                                                             style: const TextStyle(
                      //                                                               fontWeight:
                      //                                                                   FontWeight
                      //                                                                       .w600,
                      //                                                               fontSize: 11,
                      //                                                               overflow:
                      //                                                                   TextOverflow
                      //                                                                       .ellipsis,
                      //                                                             ),
                      //                                                           ),
                      //                                                         ),
                      //                                                         Expanded(
                      //                                                           flex: 1,
                      //                                                           child:
                      //                                                               productGroupBagde(
                      //                                                                 context,
                      //                                                                 product
                      //                                                                     .groupName,
                      //                                                               ),
                      //                                                         ),
                      //                                                       ],
                      //                                                     ),
                      //                                                   ),
                      //                                                 ],
                      //                                               ),
                      //                                             ),
                      //                                           ),
                      //                                         ),

                      //                                         TopPriceContainer(
                      //                                           price: product.salesPrice,
                      //                                         ),
                      //                                       ],
                      //                                     );
                      //                                   },
                      //                                 );
                      //                               },
                      //                             ),
                      //                           );
                      //                         }

                      //                         return const SizedBox();
                      //                       },
                      //                     );
                    },
                  ),
                ),

                // CART BAR (same)
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

                CommomBottomBar(),
              ],
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
