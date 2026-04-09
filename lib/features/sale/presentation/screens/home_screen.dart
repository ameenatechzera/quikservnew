import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
import 'package:quikservnew/features/sale/presentation/widgets/homescreen_widgets.dart';
import 'package:quikservnew/features/sale/presentation/widgets/scroll_supportings.dart';
import 'package:quikservnew/features/sale/presentation/widgets/tabs.dart';
import 'package:quikservnew/features/sale/presentation/widgets/top_price_container_widget.dart';
import 'package:quikservnew/features/settings/presentation/screens/settings_dashboard.dart';
import 'package:quikservnew/services/shared_preference_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final CartManager cartManager;
  int _previousTabIndex = 0;
  final ValueNotifier<int> selectedSaleTab = ValueNotifier<int>(0);
  int _currentTabIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  final double _bottomBarHeight = 70;
  final double _cartBarHeight = 60;
  final double _extraGap = 24;
  late AnimationController _menuAnimationController;
  late Animation<double> _menuFadeAnimation;
  double _startX = 0;
  double _startY = 0;
  bool _isSwiping = false;
  double _swipeDistance = 0;
  final double _swipeThreshold = 100; // Increased for better visual feedback
  final double _maxSwipeDistance = 200; // Maximum visual drag distance
  double _dragOffset = 0; // For visual drag effect
  bool _swipeCompleted = false;
  final SharedPreferenceHelper helper = SharedPreferenceHelper();
  final ValueNotifier<bool> _dragHandleVisible = ValueNotifier<bool>(true);
  // ✅ LIVE setting value
  int _itemTapBehavior = 1;
  late final VoidCallback _itemTapListener;
  final ScrollController _categoryScrollController = ScrollController();
  bool _didAutoScrollForCart = false;
  bool _imagesPreloaded = false;

  @override
  void initState() {
    super.initState();
    _itemTapListener = () {
      if (!mounted) return;
      setState(() {
        _itemTapBehavior = itemTapBehaviorNotifier.value;
      });
    };
    itemTapBehaviorNotifier.addListener(_itemTapListener);
    // ✅ Load initial saved value (also syncs notifier)
    helper.getItemTapBehavior();
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
    itemTapBehaviorNotifier.removeListener(_itemTapListener);
    // Dispose all ValueNotifiers
    selectedSaleTab.dispose();
    showCartBar.dispose();
    _dragHandleVisible.dispose();
    // Dispose animation controller
    _menuAnimationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Added this method to handle tab switching
  void _switchTab(int index) {
    print('swichHARIS');
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
        context.read<ProductCubit>().loadProductsFromLocal();
        showCartBar.value = cartManager.cartItems.value.isNotEmpty;
      }
    });
  }

  // Method to handle swipe gesture for menu mode toggle
  void _handleHorizontalSwipe(double dx) {
    final saleCubit = context.read<SaleCubit>();
    final isMenuMode = saleCubit.isMenuMode;

    // Swipe right to go to normal mode (from menu mode)
    if (!isMenuMode && dx > _swipeThreshold) {
      _swipeCompleted = true;
      toggleMenuModeWithAnimation(
        context: context,
        menuAnimationController: _menuAnimationController,
        searchController: _searchController,
      );
    }
    // Swipe left to go to menu mode (from normal mode)
    else if (isMenuMode && dx < -_swipeThreshold) {
      _swipeCompleted = true;
      toggleMenuModeWithAnimation(
        context: context,
        menuAnimationController: _menuAnimationController,
        searchController: _searchController,
      );
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
                        toggleMenuModeWithAnimation(
                          context: context,
                          menuAnimationController: _menuAnimationController,
                          searchController: _searchController,
                        );
                      },
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/icons/menuicon.svg',
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
                              products = searchProducts(products, query);
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
                                    final filteredProducts = searchProducts(
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
                      return IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: AppColors.red,
                          size: 20,
                        ),
                        onPressed: () {
                          cartManager.clearCart();
                          showCartBar.value = false;
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
        // ✅ MAIN BODY SWITCH (NO ANIMATION / NO PAGE)
        Expanded(
          child: _buildSwipeDetector(
            BlocBuilder<SaleCubit, SaleState>(
              builder: (context, state) {
                final isMenuMode = context.read<SaleCubit>().isMenuMode;
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

              final filteredProducts = searchProducts(allProducts, query);

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
                        final bottomPad = contentBottomPadding(
                          cartVisible: cartVisible,
                          bottomBarHeight: _bottomBarHeight,
                          cartBarHeight: _cartBarHeight,
                          extraGap: _extraGap,
                        );
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
                                      onTap: () => handleGridTap(
                                        context: context,
                                        itemTapBehavior: _itemTapBehavior,
                                        product: product,
                                        cartManager: cartManager,
                                        showCartBar: showCartBar,
                                      ),
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
                                                          )
                                                        : Image.asset(
                                                            "assets/images/freepik__the-style-is-candid-image-photography-with-natural__16410.jpeg",
                                                            fit: BoxFit.cover,
                                                          ),
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
                                                        product.purchaseRate ??
                                                        '0',
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

                                          onTap: () => handleGridTap(
                                            context: context,
                                            itemTapBehavior: _itemTapBehavior,
                                            product: product,
                                            cartManager: cartManager,
                                            showCartBar: showCartBar,
                                          ),
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
                return ValueListenableBuilder(
                  valueListenable: showCartBar,
                  builder: (context, cartVisible, child) {
                    final bottomPad = contentBottomPadding(
                      cartVisible: cartVisible,
                      bottomBarHeight: _bottomBarHeight,
                      cartBarHeight: _cartBarHeight,
                      extraGap: _extraGap,
                    );

                    // ✅ Auto scroll ONLY ONCE when cart becomes visible
                    if (cartVisible && !_didAutoScrollForCart) {
                      _didAutoScrollForCart = true;

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (!_categoryScrollController.hasClients) return;

                        _categoryScrollController.animateTo(
                          _categoryScrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeOut,
                        );
                      });
                    }

                    // ✅ Reset when cart hides (so next time it can auto scroll again)
                    if (!cartVisible && _didAutoScrollForCart) {
                      _didAutoScrollForCart = false;
                    }
                    return CategoryListWidget(
                      categories: state.categories,
                      controller: _categoryScrollController,
                      bottomPadding: bottomPad,
                    );
                  },
                );
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

                    final filteredProducts = searchProducts(products!, query);

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
                            final bottomPad = contentBottomPadding(
                              cartVisible: cartVisible,
                              bottomBarHeight: _bottomBarHeight,
                              cartBarHeight: _cartBarHeight,
                              extraGap: _extraGap,
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
                                          // ✅ LIVE TAP BEHAVIOR
                                          onTap: () => handleGridTap(
                                            context: context,
                                            itemTapBehavior: _itemTapBehavior,
                                            product: product,
                                            cartManager: cartManager,
                                            showCartBar: showCartBar,
                                          ),
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
                                                                child: Image.memory(
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
                                                                            milliseconds:
                                                                                120,
                                                                          ),
                                                                          child:
                                                                              child,
                                                                        );
                                                                      },
                                                                ),
                                                              )
                                                            : Image.asset(
                                                                "assets/images/freepik__the-style-is-candid-image-photography-with-natural__16410.jpeg",
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
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
                                                          purchaseCost:
                                                              product
                                                                  .purchaseRate ??
                                                              "0",
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

                                              // ✅ LIVE TAP BEHAVIOR
                                              onTap: () => handleGridTap(
                                                context: context,
                                                itemTapBehavior:
                                                    _itemTapBehavior,
                                                product: product,
                                                cartManager: cartManager,
                                                showCartBar: showCartBar,
                                              ),
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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _handleBackButton();
      },
      child: ScrollConfiguration(
        behavior: const AppScrollBehavior(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: BlocListener<ProductCubit, ProductsState>(
              listener: (context, state) {
                if (state is SaveProductSuccess || state is ProductSuccess) {
                  context.read<ProductCubit>().loadProductsFromLocal();
                }
              },
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 40,
                    child: Container(color: AppColors.theme),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 320),
                    reverseDuration: const Duration(milliseconds: 280),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    transitionBuilder: (child, animation) {
                      final bool isForward =
                          _currentTabIndex > _previousTabIndex;

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

                      final bool isIncoming =
                          (child.key == ValueKey(_currentTabIndex));

                      final slideAnim = isIncoming ? inSlide : outSlide;

                      final fade = CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOut,
                      );

                      return FadeTransition(
                        opacity: fade,
                        child: SlideTransition(
                          position: slideAnim,
                          child: child,
                        ),
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
                          : SettingsScreen(),
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
      ),
    );
  }

  Future<void> _handleBackButton() async {
    final shouldClose = await showCloseConfirmationDialog(context);
    if (shouldClose) {
      SystemNavigator.pop();
    }
  }
}
