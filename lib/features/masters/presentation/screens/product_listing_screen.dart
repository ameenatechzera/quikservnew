import 'package:flutter/material.dart';
import 'package:quikservnew/core/navigation/app_navigator.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/features/masters/presentation/screens/product_entry_screen.dart';

class ProductListingScreen extends StatefulWidget {
  final bool showAppBar;
  const ProductListingScreen({super.key, this.showAppBar = true});

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  // --------- STATIC DATA (UI ONLY) ----------
  final List<Map<String, dynamic>> listItems = [
    {
      "productName": "FRESH LIME",
      "categoryName": "Juices",
      "salesPrice": "15.00",
      "purchaseRate": "0.00",
      "stock": "0",
    },
    {
      "productName": "PINAPPLE LIME",
      "categoryName": "Juices",
      "salesPrice": "20.00",
      "purchaseRate": "0.00",
      "stock": "0",
    },
    {
      "productName": "MINT LIME",
      "categoryName": "Juices",
      "salesPrice": "20.00",
      "purchaseRate": "0.00",
      "stock": "0",
    },
    {
      "productName": "TEA",
      "categoryName": "Juices",
      "salesPrice": "15.00",
      "purchaseRate": "0.00",
      "stock": "0",
    },
  ];

  String categoryName = "All Categories";
  String groupName = "All Groups";

  // Colors (match your look)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: widget.showAppBar
          ? AppBar(
              backgroundColor: AppColors.theme,
              elevation: 0,

              title: const Text(
                "Products",
                style: TextStyle(
                  color: AppColors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh, color: AppColors.black),
                  onPressed: () {
                    // UI only
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: AppColors.black),
                  onPressed: () {
                    AppNavigator.pushSlide(
                      context: context,
                      page: ProductEntryUiOnlyScreen(
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
                  padding: const EdgeInsets.only(
                    left: 8.0,
                    right: 8.0,
                    top: 8.0,
                    bottom: 8.0,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            // UI only (open bottom sheet later)
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
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
                                      categoryName,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: Text("Being Displayed"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            // UI only (open bottom sheet later)
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
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
                                        groupName,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Text("Being Displayed"),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // -------- LIST / EMPTY ----------
                Expanded(
                  child: listItems.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(
                            left: 8.0,
                            right: 8.0,
                            top: 10.0,
                          ),
                          child: Container(
                            color: Colors.white,
                            width: double.infinity,
                            child: const Center(
                              child: Text(
                                "No products to list...",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(
                            left: 8.0,
                            right: 8.0,
                            bottom: 60,
                          ),
                          child: ListView.builder(
                            itemCount: listItems.length,
                            itemBuilder: (context, index) {
                              final item = listItems[index];

                              return SizedBox(
                                height: 130,
                                child: Card(
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: ListTile(
                                    tileColor: Colors.white,
                                    contentPadding: EdgeInsets.zero,
                                    title: Column(
                                      children: [
                                        // ---- TOP ROW ----
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 8.0,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    item["productName"],
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    item["categoryName"],
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                      color: AppColors.primary,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    // UI only share
                                                  },
                                                  child: const Padding(
                                                    padding: EdgeInsets.all(
                                                      8.0,
                                                    ),
                                                    child: Icon(
                                                      Icons.reply,
                                                      size: 26,
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                ),
                                                PopupMenuButton<String>(
                                                  icon: const Icon(
                                                    Icons.more_vert,
                                                    size: 20,
                                                  ),
                                                  onSelected: (value) {
                                                    // UI only
                                                  },
                                                  itemBuilder: (context) => [
                                                    const PopupMenuItem(
                                                      value: "edit",
                                                      height: 30,
                                                      child: Center(
                                                        child: Text("Edit"),
                                                      ),
                                                    ),
                                                    const PopupMenuItem(
                                                      value: "delete",
                                                      height: 30,
                                                      child: Center(
                                                        child: Text(
                                                          "Delete",
                                                          style: TextStyle(
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                  constraints:
                                                      const BoxConstraints(
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
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            _priceCol(
                                              label: "Sale Price",
                                              value: item["salesPrice"],
                                            ),
                                            _priceCol(
                                              label: "Purchase Price",
                                              value: item["purchaseRate"],
                                            ),
                                            _stockCol(
                                              label: "In Stock",
                                              value: item["stock"],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
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
                onTap: () {
                  // UI only (navigate later)
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
