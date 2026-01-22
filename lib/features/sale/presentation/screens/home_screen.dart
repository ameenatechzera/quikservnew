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
import 'package:quikservnew/features/sale/presentation/widgets/scroll_supportings.dart';
import 'package:quikservnew/features/sale/presentation/widgets/tabs.dart';
import 'package:quikservnew/features/sale/presentation/widgets/top_price_container_widget.dart';
import 'package:quikservnew/features/settings/presentation/screens/settings_dashboard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final CartManager cartManager;
  int _previousTabIndex = 0;

  /// ✅ SIMPLE ValueNotifier for top tabs (Dine-In, Takeaway, Delivery)
  final ValueNotifier<int> selectedSaleTab = ValueNotifier<int>(0);

  // Add this: Current tab index (0: Sales, 1: Dashboard, 2: Settings)
  int _currentTabIndex = 0;

  // Search controller
  final TextEditingController _searchController = TextEditingController();

  // ✅ Adjust if needed (match your real widget heights)
  final double _bottomBarHeight = 70; // CommomBottomBar height
  final double _cartBarHeight = 60; // cartBottomBar height
  final double _extraGap = 16;

  // Animation controller for menu toggle fade
  late AnimationController _menuAnimationController;
  late Animation<double> _menuFadeAnimation;
  // Add swipe gesture variables with drag/slide effect
  double _startX = 0;
  double _startY = 0;
  bool _isSwiping = false;
  double _swipeDistance = 0;
  final double _swipeThreshold = 100; // Increased for better visual feedback
  final double _maxSwipeDistance = 200; // Maximum visual drag distance
  double _dragOffset = 0; // For visual drag effect
  bool _swipeCompleted = false;

  // For drag handle visibility
  //bool _showDragHandle = true;
  final ValueNotifier<bool> _dragHandleVisible = ValueNotifier<bool>(true);

  double _contentBottomPadding(bool cartVisible) {
    return _bottomBarHeight +
        (cartVisible ? (_cartBarHeight + _extraGap) : _extraGap);
  }

  final Map<String, Uint8List> _imageCache = {};
  bool _imagesPreloaded = false;

  Uint8List? getProductImage({
    required String productCode,
    required String? imageString,
  }) {
    if (imageString == null || imageString.isEmpty) return null;

    if (_imageCache.containsKey(productCode)) {
      return _imageCache[productCode];
    }

    final bytes = decodeImage(imageString);
    if (bytes != null) {
      _imageCache[productCode] = bytes;
    }
    return bytes;
  }

  void preloadProductImages(List<FetchProductDetails> products) {
    for (final product in products) {
      final code = product.productCode;
      final img = product.productImageByte;

      if (code != null &&
          img != null &&
          img.isNotEmpty &&
          !_imageCache.containsKey(code)) {
        final bytes = decodeImage(img);
        if (bytes != null) {
          _imageCache[code] = bytes;
        }
      }
    }
  }

  @override
  void initState() {
    super
        .initState(); // ✅ Reset global status bar when entering Home (fix after login/splash)
    // Initialize menu animation controller
    _menuAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _menuFadeAnimation = CurvedAnimation(
      parent: _menuAnimationController,
      curve: Curves.easeInOut,
    );
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.theme,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
    cartManager = CartManager();
    requestBluetoothPermissions();

    // ✅ Load initial data ONCE (avoid calling inside build)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductCubit>().loadProductsFromLocal();
      context
          .read<CategoriesCubit>()
          .loadCategoriesFromLocal(); // ✅ init category in cubit
      context.read<SaleCubit>().resetCategory();
      // Start animation controller
      _menuAnimationController.forward();
    });
    _searchController.addListener(() {
      context.read<SaleCubit>().updateSearchQuery(_searchController.text);
    });
  }

  @override
  void dispose() {
    // Dispose all ValueNotifiers
    selectedSaleTab.dispose();
    showCartBar.dispose();
    _dragHandleVisible.dispose();
    // Dispose animation controller
    _menuAnimationController.dispose();
    _searchController.dispose();
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
      _previousTabIndex = _currentTabIndex;
      _currentTabIndex = index;
      // Reset search and menu mode when switching away from Sales tab
      if (index != 0) {
        final saleCubit = context.read<SaleCubit>();
        saleCubit.hideSearchBar();
        saleCubit.disableMenuMode();
        _searchController.clear();
        saleCubit.clearSearchQuery();
        saleCubit.resetCategory();
      } else {
        // ✅ When coming back to Home, show cartbar if cart has items
        showCartBar.value = cartManager.cartItems.value.isNotEmpty;
      }
    });
  }

  // Method to handle menu toggle with fade animation
  void _toggleMenuModeWithAnimation() {
    final saleCubit = context.read<SaleCubit>();
    final wasMenuMode = saleCubit.isMenuMode;

    // Start fade out animation
    _menuAnimationController.reverse().then((_) {
      // Toggle menu mode
      saleCubit.toggleMenuMode();

      if (saleCubit.isMenuMode) {
        // ✅ entering menu mode -> ensure categories are loaded
        context.read<CategoriesCubit>().loadCategoriesFromLocal();
        saleCubit.hideSearchBar();
        _searchController.clear();
        saleCubit.clearSearchQuery();
      }

      // ✅ IMPORTANT: when coming BACK from menu/category to home grid
      if (wasMenuMode) {
        saleCubit.resetCategory(); // set "All"
      }

      // FIX: Always ensure products are loaded for current mode
      context.read<ProductCubit>().loadProductsFromLocal();

      // Start fade in animation
      _menuAnimationController.forward();
    });
  }

  // Method to handle swipe gesture for menu mode toggle
  void _handleHorizontalSwipe(double dx) {
    final saleCubit = context.read<SaleCubit>();
    final isMenuMode = saleCubit.isMenuMode;

    // Swipe right to go to normal mode (from menu mode)
    if (!isMenuMode && dx > _swipeThreshold) {
      _swipeCompleted = true;
      _toggleMenuModeWithAnimation();
    }
    // Swipe left to go to menu mode (from normal mode)
    else if (isMenuMode && dx < -_swipeThreshold) {
      _swipeCompleted = true;
      _toggleMenuModeWithAnimation();
    } else {
      // Reset if swipe was cancelled
      _resetSwipeState();
    }
  }

  // Reset swipe state
  void _resetSwipeState() {
    setState(() {
      _isSwiping = false;
      _dragOffset = 0;
      _swipeCompleted = false;
    });
  }

  // Color for selected product grid - NO BORDERS
  Color _getProductGridColor(bool isSelected) {
    return isSelected
        ? AppColors
              .theme // Light green background for selected
        : const Color.fromARGB(255, 232, 229, 229); // Original gray
  }

  // Widget for swipe detection overlay with drag effect
  Widget _buildSwipeDetector(Widget child) {
    return Stack(
      children: [
        // The actual content with drag offset
        AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(_dragOffset, 0, 0),
          child: GestureDetector(
            onHorizontalDragStart: (details) {
              _startX = details.localPosition.dx;
              _startY = details.localPosition.dy;
              _isSwiping = false;
              _swipeDistance = 0;
              _dragOffset = 0;
              _swipeCompleted = false;

              // Hide drag handle when user starts dragging
              _dragHandleVisible.value = false;
            },
            onHorizontalDragUpdate: (details) {
              final dx = details.localPosition.dx - _startX;
              final dy = details.localPosition.dy - _startY;

              // Check if it's primarily a horizontal swipe (not vertical)
              if (!_isSwiping && dx.abs() > 10 && dx.abs() > dy.abs() * 2) {
                _isSwiping = true;
              }

              if (_isSwiping) {
                _swipeDistance = dx;

                // Calculate drag offset for visual effect (capped)
                final saleCubit = context.read<SaleCubit>();
                final isMenuMode = saleCubit.isMenuMode;

                // Normal mode: can only swipe left (negative dx) to enter menu mode
                // Menu mode: can only swipe right (positive dx) to return to normal
                if ((!isMenuMode && dx > 0) || (isMenuMode && dx < 0)) {
                  _dragOffset =
                      dx.clamp(
                        isMenuMode ? -_maxSwipeDistance : 0,
                        isMenuMode ? 0 : _maxSwipeDistance,
                      ) *
                      0.3; // Reduce factor for smoother visual

                  setState(() {});
                }
              }
            },
            onHorizontalDragEnd: (details) {
              if (_isSwiping && !_swipeCompleted) {
                _handleHorizontalSwipe(_swipeDistance);
              }
              // Animate back to position
              if (mounted) {
                setState(() {
                  _dragOffset = 0;
                  _isSwiping = false;
                });
              }

              // Show drag handle again after a delay
              Future.delayed(const Duration(seconds: 2), () {
                if (mounted && !_isSwiping) {
                  _dragHandleVisible.value = true;
                }
              });
            },
            onHorizontalDragCancel: () {
              _resetSwipeState();
              // Show drag handle again after a delay
              Future.delayed(const Duration(seconds: 0), () {
                if (mounted && !_isSwiping) {
                  _dragHandleVisible.value = true;
                }
              });
            },
            behavior: HitTestBehavior.translucent,
            child: child,
          ),
        ),
        // Drag handle (LEFT in normal mode, RIGHT in menu mode)
        BlocBuilder<SaleCubit, SaleState>(
          builder: (context, state) {
            final isMenuMode = context.read<SaleCubit>().isMenuMode;

            return Positioned(
              left: isMenuMode ? null : 0,
              right: isMenuMode ? 0 : null,
              top: 0,
              bottom: 0,
              child: ValueListenableBuilder<bool>(
                valueListenable: _dragHandleVisible,
                builder: (context, visible, _) {
                  if (!visible) return const SizedBox();

                  return IgnorePointer(
                    child: Container(
                      width: 24,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary.withOpacity(0.12),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 1.0],
                          begin: isMenuMode
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          end: isMenuMode
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 10,
                            height: 100,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(12),
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: Colors.black.withOpacity(0.1),
                              //     blurRadius: 2,
                              //     offset: const Offset(1, 0),
                              //   ),
                              // ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Icon(
                            isMenuMode
                                ? Icons.chevron_left
                                : Icons.chevron_right,
                            size: 26,
                            color: AppColors.primary.withOpacity(0.8),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),

        // Edge indicator for swipe direction (only shows during swipe)
        if (_isSwiping && _dragOffset.abs() > 20)
          Positioned(
            left: _dragOffset > 0 ? 16 : null,
            right: _dragOffset < 0 ? 16 : null,
            top: 0,
            bottom: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(
                  _dragOffset > 0 ? Icons.arrow_forward : Icons.arrow_back,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),

        // Progress indicator for swipe threshold (only shows during swipe)
        if (_isSwiping && _dragOffset.abs() > 0)
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 120,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Stack(
                  children: [
                    // Progress fill
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      width: (_dragOffset.abs() / _swipeThreshold * 120).clamp(
                        0,
                        120,
                      ),
                      height: 4,
                      decoration: BoxDecoration(
                        color: _dragOffset.abs() >= _swipeThreshold
                            ? Colors.green
                            : AppColors.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  // Added this method to build the Sales content
  Widget _buildSalesContent() {
    return Column(
      children: [
        // Top Tabs
        Container(
          height: 40,
          color: const Color(0xFFFFE38A),
          child: Padding(
            padding: const EdgeInsets.all(5),
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
                        _toggleMenuModeWithAnimation();
                        // final saleCubit = context.read<SaleCubit>();
                        // final wasMenuMode = saleCubit.isMenuMode;

                        // saleCubit
                        //     .toggleMenuMode(); // Clear search when switching modes
                        // if (saleCubit.isMenuMode) {
                        //   // ✅ entering menu mode -> refresh categories + products
                        //   context
                        //       .read<CategoriesCubit>()
                        //       .loadCategoriesFromLocal();
                        //   context.read<ProductCubit>().loadProductsFromLocal();
                        //   saleCubit.hideSearchBar();
                        //   _searchController.clear();
                        //   saleCubit.clearSearchQuery();
                        // }

                        // // ✅ IMPORTANT: when coming BACK from menu/category to home grid
                        // if (wasMenuMode) {
                        //   saleCubit.resetCategory(); // set "All"
                        //   context
                        //       .read<ProductCubit>()
                        //       .loadProductsFromLocal(); // reload all products
                        // }
                        // context.read<SaleCubit>().toggleMenuMode();

                        // // Clear search when switching modes
                        // if (context.read<SaleCubit>().isMenuMode) {
                        //   context.read<SaleCubit>().hideSearchBar();
                        //   _searchController.clear();
                        //   context.read<SaleCubit>().clearSearchQuery();
                        // }
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
                                products = state
                                    .products; // ✅ PRELOAD IMAGES ONLY ONCE (FIRST LOAD)
                                if (!_imagesPreloaded) {
                                  preloadProductImages(products);
                                  _imagesPreloaded = true;
                                }
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
                      //final saleCubit = context.read<SaleCubit>();
                      return IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: AppColors.red,
                          size: 20,
                        ),
                        onPressed: () {
                          // ✅ ALWAYS clear cart in normal mode
                          cartManager.clearCart();
                          showCartBar.value = false;
                          // if (saleCubit.isSearchBarVisible) {
                          //   // ✅ Close search bar using SaleCubit
                          //   saleCubit.hideSearchBar();
                          //   _searchController.clear();
                          //   saleCubit.clearSearchQuery();
                          //   return;
                          // }
                          // if (saleCubit.isMenuMode) {
                          //   saleCubit
                          //       .disableMenuMode(); // ✅ reset category and load all
                          //   saleCubit.resetCategory();
                          //   context
                          //       .read<ProductCubit>()
                          //       .loadProductsFromLocal();
                          //   return;
                          // }
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
          child: _buildSwipeDetector(
            BlocBuilder<SaleCubit, SaleState>(
              builder: (context, state) {
                final isMenuMode = context.read<SaleCubit>().isMenuMode;
                //final saleCubit = context.read<SaleCubit>();
                return FadeTransition(
                  opacity: _menuFadeAnimation,
                  child: isMenuMode
                      ? _buildMenuModeContent()
                      : _buildNormalModeContent(),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNormalModeContent() {
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

              final filteredProducts = _searchProducts(allProducts, query);

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
                    final screenWidth = MediaQuery.of(context).size.width;
                    final textScale = MediaQuery.of(context).textScaleFactor;

                    double maxWidthPerItem = screenWidth > 600 ? 180 : 160;
                    if (textScale > 1.2) maxWidthPerItem += 30;

                    double baseAspectRatio = screenWidth > 600 ? 0.8 : 0.71;
                    final childAspectRatio =
                        baseAspectRatio / textScale.clamp(1.08, 1.7);

                    double imageHeight = 120;
                    if (textScale > 1.0) {
                      imageHeight = 120 * textScale.clamp(1.0, 1.2);
                    }
                    return ValueListenableBuilder<bool>(
                      valueListenable: showCartBar,
                      builder: (context, cartVisible, _) {
                        final bottomPad = _contentBottomPadding(cartVisible);
                        return GridView.builder(
                          physics: const SoftBounceScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics(),
                          ),
                          padding: EdgeInsets.only(bottom: bottomPad),
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

                            return ValueListenableBuilder<List<CartItem>>(
                              valueListenable: cartManager.cartItems,
                              builder: (context, cartItems, _) {
                                bool isSelected = cartItems.any(
                                  (item) =>
                                      item.productCode == product.productCode,
                                );
                                final Uint8List? imageBytes = getProductImage(
                                  productCode: product.productCode!,
                                  imageString: product.productImageByte,
                                );
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
                                              productCode: product.productCode!,
                                              productName: product.productName!,
                                              qty: 1,
                                              oldQty: 0,
                                              salesRate:
                                                  double.tryParse(
                                                    product.salesPrice ?? '0',
                                                  ) ??
                                                  0.0,
                                              unitId: product.unitId.toString(),
                                              purchaseCost:
                                                  product.purchaseRate!,
                                              groupId: product.group_id,
                                              categoryId: product.categoryId!,
                                              productImage:
                                                  product.productImageByte!,
                                              excludeRate: '',
                                              subtotal: '0.0',
                                              vatId: product.vatId!.toString(),
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
                                        borderRadius: BorderRadius.circular(12),
                                        child: Container(
                                          color: _getProductGridColor(
                                            isSelected,
                                          ),
                                          // color: const Color.fromARGB(
                                          //   255,
                                          //   232,
                                          //   229,
                                          //   229,
                                          // ),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(
                                                  5.0,
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  child: SizedBox(
                                                    height: imageHeight,
                                                    child: imageBytes != null
                                                        ? RepaintBoundary(
                                                            child: Image.memory(
                                                              imageBytes,
                                                              key: ValueKey(
                                                                product
                                                                    .productCode,
                                                              ),
                                                              fit: BoxFit.cover,
                                                              gaplessPlayback:
                                                                  true,
                                                              frameBuilder:
                                                                  (
                                                                    context,
                                                                    child,
                                                                    frame,
                                                                    _,
                                                                  ) {
                                                                    return AnimatedOpacity(
                                                                      opacity:
                                                                          frame ==
                                                                              null
                                                                          ? 0
                                                                          : 1,
                                                                      duration: const Duration(
                                                                        milliseconds:
                                                                            500,
                                                                      ),
                                                                      child:
                                                                          child,
                                                                    );
                                                                  },
                                                            ),

                                                            // Image.memory(
                                                            //   imageBytes,
                                                            //   key: ValueKey(
                                                            //     product
                                                            //         .productCode,
                                                            //   ),
                                                            //   fit: BoxFit
                                                            //       .cover,
                                                            //   gaplessPlayback:
                                                            //       true,
                                                            // ),
                                                          )
                                                        : Image.asset(
                                                            "assets/images/freepik__the-style-is-candid-image-photography-with-natural__16410.jpeg",
                                                            fit: BoxFit.cover,
                                                          ),
                                                    // (() {
                                                    //   final Uint8List?
                                                    //   imageBytes =
                                                    //       decodeImage(
                                                    //         product
                                                    //             .productImageByte,
                                                    //       );

                                                    //   if (imageBytes !=
                                                    //       null) {
                                                    //     return Image.memory(
                                                    //       imageBytes,
                                                    //       fit: BoxFit
                                                    //           .cover,
                                                    //       gaplessPlayback:
                                                    //           true,
                                                    //     );
                                                    //   }

                                                    //   return Image.asset(
                                                    //     "assets/images/freepik__the-style-is-candid-image-photography-with-natural__16410.jpeg",
                                                    //     fit: BoxFit
                                                    //         .cover,
                                                    //   );
                                                    // })(),
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
                                                      CrossAxisAlignment.start,
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
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: productGroupBagde(
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
                                        valueListenable: cartManager.cartItems,
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
                                                    conversion_rate:
                                                        product.conversionRate!,
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
                                                      BorderRadius.circular(5),
                                                ),
                                                child: const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
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
                                                          cartItem!.productCode,
                                                        );
                                                  },
                                                  child: const SizedBox(
                                                    width: 30,
                                                    child: Center(
                                                      child: Icon(
                                                        Icons.remove,
                                                        size: 20,
                                                        color: AppColors.black,
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
                                                          cartItem!.productCode,
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
                                                        color: AppColors.black,
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
                                                  productImage:
                                                      product
                                                          .productImageByte ??
                                                      '',
                                                  excludeRate: '',
                                                  subtotal: '0.0',
                                                  vatId: product.vatId!
                                                      .toString(),
                                                  vatAmount: '0.0',
                                                  totalAmount: '0.00',
                                                  conversion_rate:
                                                      product.conversionRate!,
                                                  category:
                                                      product.categoryName!,
                                                  groupName: product.groupName,
                                                  product_description: '',
                                                ),
                                              );
                                              showCartBar.value = true;
                                            }
                                          },
                                        );
                                      },
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
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildMenuModeContent() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Categories
        SizedBox(
          width: 120,
          child: BlocBuilder<CategoriesCubit, CategoryState>(
            builder: (context, state) {
              if (state is CategoryLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is CategoryLoadedFromLocal) {
                return CategoryListWidget(categories: state.categories);
              }

              if (state is CategoryEmpty) {
                return const Center(child: Text("No categories in local DB"));
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
                  return const Center(child: CircularProgressIndicator());
                }

                if (products == null || products.isEmpty) {
                  return const Center(child: Text("No Products"));
                }
                // Apply search filter
                return BlocBuilder<SaleCubit, SaleState>(
                  builder: (context, state) {
                    // ✅ Get query from cubit
                    final query = context.read<SaleCubit>().searchQuery;

                    final filteredProducts = _searchProducts(products!, query);

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
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        final double screenWidth = constraints.maxWidth;
                        final double textScale = MediaQuery.of(
                          context,
                        ).textScaleFactor;

                        double maxItemWidth = screenWidth > 600 ? 200 : 160;
                        if (textScale > 1.0) {
                          maxItemWidth += 30 * (textScale.clamp(1.0, 1.6) - 1);
                        }

                        double baseAspectRatio = 0.68;
                        final double childAspectRatio =
                            baseAspectRatio / textScale.clamp(1.08, 1.6);

                        return ValueListenableBuilder<bool>(
                          valueListenable: showCartBar,
                          builder: (context, cartVisible, _) {
                            final bottomPad = _contentBottomPadding(
                              cartVisible,
                            );

                            return GridView.builder(
                              physics: const SoftBounceScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics(),
                              ),
                              padding: EdgeInsets.only(bottom: bottomPad),
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

                                return ValueListenableBuilder<List<CartItem>>(
                                  valueListenable: cartManager.cartItems,
                                  builder: (context, cartItems, _) {
                                    bool isSelected = cartItems.any(
                                      (item) =>
                                          item.productCode ==
                                          product.productCode,
                                    );
                                    final Uint8List? imageBytes =
                                        getProductImage(
                                          productCode: product.productCode!,
                                          imageString: product.productImageByte,
                                        );

                                    return Stack(
                                      children: [
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
                                                        product.salesPrice ??
                                                            '0',
                                                      ) ??
                                                      0.0,
                                                  unitId: product.unitId
                                                      .toString(),
                                                  purchaseCost:
                                                      product.purchaseRate ??
                                                      "0",
                                                  groupId: product.group_id,
                                                  categoryId:
                                                      product.categoryId!,
                                                  productImage:
                                                      product
                                                          .productImageByte ??
                                                      '',
                                                  excludeRate: '',
                                                  subtotal: '0.0',
                                                  vatId: product.vatId!
                                                      .toString(),
                                                  vatAmount: '0.0',
                                                  totalAmount: '0.00',
                                                  conversion_rate:
                                                      product.conversionRate!,
                                                  category:
                                                      product.categoryName!,
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
                                              width: double.infinity,
                                              color: _getProductGridColor(
                                                isSelected,
                                              ),
                                              // color:
                                              //     const Color.fromARGB(
                                              //       255,
                                              //       232,
                                              //       229,
                                              //       229,
                                              //     ),
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
                                                        child:
                                                            imageBytes != null
                                                            ? RepaintBoundary(
                                                                child:
                                                                    // Image.memory(
                                                                    //     imageBytes,
                                                                    //     key: ValueKey(
                                                                    //       product.productCode,
                                                                    //     ),
                                                                    //     fit: BoxFit.cover,
                                                                    //     gaplessPlayback: true,
                                                                    //   ),
                                                                    // )
                                                                    Image.memory(
                                                                      imageBytes,
                                                                      key: ValueKey(
                                                                        product
                                                                            .productCode,
                                                                      ),
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      gaplessPlayback:
                                                                          true,
                                                                      frameBuilder:
                                                                          (
                                                                            context,
                                                                            child,
                                                                            frame,
                                                                            _,
                                                                          ) {
                                                                            return AnimatedOpacity(
                                                                              opacity:
                                                                                  frame ==
                                                                                      null
                                                                                  ? 0
                                                                                  : 1,
                                                                              duration: const Duration(
                                                                                milliseconds: 120,
                                                                              ),
                                                                              child: child,
                                                                            );
                                                                          },
                                                                    ),
                                                              )
                                                            : Image.asset(
                                                                "assets/images/freepik__the-style-is-candid-image-photography-with-natural__16410.jpeg",
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),

                                                        //(() {
                                                        //     final Uint8List?
                                                        //     imageBytes =
                                                        //         decodeImage(
                                                        //           product.productImageByte,
                                                        //         );

                                                        //     if (imageBytes !=
                                                        //         null) {
                                                        //       return Image.memory(
                                                        //         imageBytes,
                                                        //         fit: BoxFit
                                                        //             .cover,
                                                        //       );
                                                        //     }

                                                        //     return Image.asset(
                                                        //       "assets/images/freepik__the-style-is-candid-image-photography-with-natural__16410.jpeg",
                                                        //       fit: BoxFit
                                                        //           .cover,
                                                        //     );
                                                        //   })(),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          8.0,
                                                        ),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Expanded(
                                                          flex: 5,
                                                          child: Text(
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
                                                        ),
                                                        const SizedBox(
                                                          width: 6,
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child:
                                                              productGroupBagde(
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

                                        // Add / Qty
                                        Padding(
                                          padding: EdgeInsets.only(
                                            top:
                                                90 * textScale.clamp(1.0, 1.15),
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

                                              if (cartItem == null) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    final items = cartManager
                                                        .cartItems
                                                        .value;
                                                    final exists = items.any(
                                                      (e) =>
                                                          e.productCode ==
                                                          product.productCode,
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
                                                          unitId: product.unitId
                                                              .toString(),
                                                          purchaseCost: product
                                                              .purchaseRate!,
                                                          groupId:
                                                              product.group_id,
                                                          categoryId: product
                                                              .categoryId!,
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
                                                          category: product
                                                              .categoryName!,
                                                          groupName:
                                                              product.groupName,
                                                          product_description:
                                                              '',
                                                        ),
                                                      );
                                                      showCartBar.value = true;
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
                                                      data:
                                                          MediaQuery.of(
                                                            context,
                                                          ).copyWith(
                                                            textScaleFactor:
                                                                1.0,
                                                          ),
                                                      child: Text(
                                                        cartItem.qty.toString(),
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

                                        ValueListenableBuilder<List<CartItem>>(
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
                                            } catch (_) {
                                              cartItem = null;
                                            }

                                            final String priceToShow =
                                                cartItem != null
                                                ? cartItem.salesRate
                                                      .toStringAsFixed(
                                                        2,
                                                      ) // ✅ edited price
                                                : (product.salesPrice ??
                                                      '0'); // default price

                                            return TopPriceContainer(
                                              price: priceToShow,
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
                                                      productImage:
                                                          product
                                                              .productImageByte ??
                                                          '',
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
                                                }
                                              },
                                            );
                                          },
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ScrollConfiguration(
        behavior: const AppScrollBehavior(),
        child: Scaffold(
          //backgroundColor: AppColors.theme,
          // appBar: AppBar(toolbarHeight: 20, backgroundColor: AppColors.theme),
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            bottom: false,
            child: Stack(
              children: [
                // ADD THIS - App bar that stays during transition
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 40,
                  // MediaQuery.of(context).padding.top + 40, // App bar height
                  child: Container(
                    color: AppColors.theme, // Same as your screen color
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 320),
                  reverseDuration: const Duration(milliseconds: 280),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  transitionBuilder: (child, animation) {
                    final bool isForward = _currentTabIndex > _previousTabIndex;

                    final beginOffset = isForward
                        ? const Offset(0.12, 0)
                        : const Offset(-0.12, 0);
                    final endOffset = isForward
                        ? const Offset(-0.12, 0)
                        : const Offset(0.12, 0);

                    final inSlide = Tween<Offset>(
                      begin: beginOffset,
                      end: Offset.zero,
                    ).animate(animation);
                    final outSlide = Tween<Offset>(
                      begin: Offset.zero,
                      end: endOffset,
                    ).animate(animation);

                    // AnimatedSwitcher uses the same animation for both incoming/outgoing.
                    // We detect which child is incoming by checking its key.
                    final bool isIncoming =
                        (child.key == ValueKey(_currentTabIndex));

                    final slideAnim = isIncoming ? inSlide : outSlide;

                    final fade = CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOut,
                    );

                    return FadeTransition(
                      opacity: fade,
                      child: SlideTransition(position: slideAnim, child: child),
                    );
                  },
                  child: KeyedSubtree(
                    key: ValueKey(
                      _currentTabIndex,
                    ), // ✅ IMPORTANT: key by tab index
                    child: _currentTabIndex == 0
                        ? _buildSalesContent()
                        : _currentTabIndex == 1
                        ? const DashboardContent()
                        : const SettingsScreen(),
                  ),
                ),

                // ✅ BOTTOM BAR (unchanged)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: MediaQuery.removeViewInsets(
                    context: context,
                    removeBottom: true,
                    child: CommomBottomBar(
                      currentTabIndex: _currentTabIndex,
                      onTabChanged: _switchTab,
                    ),
                  ),
                ),

                // ✅ CART BAR ONLY FOR HOME
                if (_currentTabIndex == 0)
                  ValueListenableBuilder<bool>(
                    valueListenable: showCartBar,
                    builder: (context, visible, _) {
                      if (!visible) return const SizedBox();
                      return Positioned(
                        left: 20,
                        right: 20,
                        bottom: 80,
                        child: MediaQuery.removeViewInsets(
                          context: context,
                          removeBottom: true,
                          child: cartBottomBar(context),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
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
