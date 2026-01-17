import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikservnew/core/navigation/app_navigator.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/core/utils/widgets/common_appbar.dart';
import 'package:quikservnew/features/products/domain/entities/fetch_product_entity.dart';
import 'package:quikservnew/features/products/presentation/bloc/products_cubit.dart';
import 'package:quikservnew/features/products/presentation/screens/product_entry_screen.dart';

class ProductListingScreen extends StatefulWidget {
  final bool showAppBar;
  const ProductListingScreen({super.key, this.showAppBar = true});

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  String categoryName = "All Categories";
  String groupName = "All Groups";

  @override
  void initState() {
    super.initState();
    // 🔹 Load products from local DB
    context.read<ProductCubit>().loadProductsFromLocal();
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
                    context.read<ProductCubit>().loadProductsFromLocal();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: AppColors.black),
                  onPressed: () {
                    AppNavigator.pushSlide(
                      context: context,
                      page: const ProductEntryUiOnlyScreen(
                        pageFrom: '',
                        productCode: '',
                      ),
                    );
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
                          onTap: () {},
                          child: _filterCard(categoryName, "Being Displayed"),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {},
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
                  child: BlocBuilder<ProductCubit, ProductsState>(
                    builder: (context, state) {
                      if (state is ProductLoading) {
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
                                  child: _productTile(item),
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
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {},
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
                    onSelected: (value) {},
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
}
