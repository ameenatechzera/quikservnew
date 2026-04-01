import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/features/products/domain/entities/fetch_product_entity.dart';
import 'package:quikservnew/features/products/presentation/bloc/products_cubit.dart';
import 'package:quikservnew/features/products/presentation/helper/product_share_helper.dart';
import 'package:quikservnew/features/products/presentation/screens/product_entry_screen.dart';

final ProductShareHelper helper = ProductShareHelper();

class ProductEntryWidget extends StatelessWidget {
  const ProductEntryWidget({
    super.key,
    required TextEditingController productNameController,
    required Map<String, FocusNode> focusNodes,
    required TextEditingController productNameSecondController,
    required this.height10,
  }) : _productNameController = productNameController,
       _focusNodes = focusNodes,
       _productNameSecondController = productNameSecondController;

  final TextEditingController _productNameController;
  final Map<String, FocusNode> _focusNodes;
  final TextEditingController _productNameSecondController;
  final Widget height10;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextFormField(
            controller: _productNameController,
            focusNode: _focusNodes['productName'],
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              isCollapsed:
                  !_focusNodes['productName']!.hasFocus &&
                  _productNameController.text.isEmpty,
              label: RichText(
                text: const TextSpan(
                  text: "Product Name",
                  style: TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                      text: " *",
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: TextFormField(
                  controller: _productNameSecondController,
                  focusNode: _focusNodes['productSecondName'],
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    isCollapsed:
                        !_focusNodes['productSecondName']!.hasFocus &&
                        _productNameSecondController.text.isEmpty,
                    labelText: "Product Second Name",
                    labelStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    // UI ONLY: no translate logic here
                  },
                  child: Container(
                    height: 40,
                    width: 30,
                    margin: const EdgeInsets.only(left: 8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.text_fields, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),

        height10,
      ],
    );
  }
}

class SalesRateWidget extends StatelessWidget {
  const SalesRateWidget({
    super.key,
    required TextEditingController salesRateController,
    required Map<String, FocusNode> focusNodes,
    required TextEditingController mrpController,
  }) : _salesRateController = salesRateController,
       _focusNodes = focusNodes,
       _mrpController = mrpController;

  final TextEditingController _salesRateController;
  final Map<String, FocusNode> _focusNodes;
  final TextEditingController _mrpController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _salesRateController,
              focusNode: _focusNodes['salesRate'],
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                isCollapsed:
                    !_focusNodes['salesRate']!.hasFocus &&
                    _salesRateController.text.isEmpty,
                label: RichText(
                  text: const TextSpan(
                    text: "Sales Rate",
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: " *",
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              controller: _mrpController,
              focusNode: _focusNodes['mrp'],
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: "MRP",
                labelStyle: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PurchaseRateWidget extends StatelessWidget {
  const PurchaseRateWidget({
    super.key,
    required TextEditingController purchaseRateController,
    required Map<String, FocusNode> focusNodes,
    required TextEditingController conversionRateController,
  }) : _purchaseRateController = purchaseRateController,
       _focusNodes = focusNodes,
       _conversionRateController = conversionRateController;

  final TextEditingController _purchaseRateController;
  final Map<String, FocusNode> _focusNodes;
  final TextEditingController _conversionRateController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _purchaseRateController,
              focusNode: _focusNodes['purchaseRate'],
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                isCollapsed:
                    !_focusNodes['purchaseRate']!.hasFocus &&
                    _purchaseRateController.text.isEmpty,
                labelText: "Purchase Cost",
                labelStyle: const TextStyle(fontSize: 14),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              controller: _conversionRateController,
              focusNode: _focusNodes['conversionRate'],
              enabled: false,
              decoration: const InputDecoration(
                labelText: "Conversion Rate",
                labelStyle: TextStyle(fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductImageUploaderWidget extends StatelessWidget {
  final File? pickedImage;
  final VoidCallback onAddTap;

  const ProductImageUploaderWidget({
    super.key,
    required this.pickedImage,
    required this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: SizedBox(
              width: kIsWeb ? 380 : 180,
              height: 190,
              child: Center(
                child: pickedImage == null
                    ? Icon(
                        Icons.image,
                        size: 80,
                        color: Theme.of(context).highlightColor,
                      )
                    : Image.file(pickedImage!, fit: BoxFit.cover),
              ),
            ),
          ),
          Positioned(
            right: -10,
            bottom: -5,
            child: CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.primary,
              child: IconButton(
                onPressed: onAddTap,
                icon: const Icon(Icons.add, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomAddButton extends StatelessWidget {
  const BottomAddButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
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
    );
  }
}

Widget filterCard(String title, String subtitle) {
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

Widget productTile(FetchProductDetails item, BuildContext context) {
  return InkWell(
    onTap: () {
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
    },
    child: ListTile(
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
                    onTap: () {
                      helper.shareProductToWhatsApp(
                        context: context,
                        item: item,
                      );
                    },
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
                  InkWell(
                    onTap: () {
                      showDeleteConfirmDialog(
                        context: context,
                        productId: int.parse(
                          item.productCode.toString(),
                        ), // ✅ ensure not null
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 25,
                        width: 25,
                        child: Icon(Icons.delete),
                      ),
                    ),
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
                priceCol(
                  label: "Sale Price",
                  value: item.salesPrice?.toString() ?? '0',
                ),
                priceCol(
                  label: "Purchase Price",
                  value: item.purchaseRate?.toString() ?? '0',
                ),
                stockCol(label: "In Stock", value: '0'),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget priceCol({required String label, required String value}) {
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
              child: Icon(Icons.currency_rupee, size: 17, color: Colors.black),
            ),
            TextSpan(
              text: " $value",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget stockCol({required String label, required String value}) {
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

void showDeleteConfirmDialog({
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
