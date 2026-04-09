import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/features/cart/data/models/cart_item_model.dart';
import 'package:quikservnew/features/cart/domain/usecases/cart_manager.dart';
import 'package:quikservnew/features/category/presentation/bloc/category_cubit.dart';
import 'package:quikservnew/features/products/domain/entities/fetch_product_entity.dart';
import 'package:quikservnew/features/products/presentation/bloc/products_cubit.dart';
import 'package:quikservnew/features/sale/presentation/bloc/sale_cubit.dart';
import 'package:quikservnew/features/sale/presentation/widgets/product_dialog.dart';

Uint8List? decodeImage(String? base64String) {
  if (base64String == null || base64String.isEmpty) return null;
  try {
    return base64Decode(base64String);
  } catch (e) {
    return null;
  }
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: ProductDialogContent(product: product, cartManager: cartManager),
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

Future<bool> showCloseConfirmationDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.exit_to_app_rounded,
                size: 38,
                color: AppColors.primary,
              ),

              const SizedBox(height: 12),

              const Text(
                "Exit Application",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              const Text(
                "Are you sure you want to exit the app?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),

              const SizedBox(height: 22),

              Row(
                children: [
                  /// Cancel
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(dialogContext, false);
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  /// Exit
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(dialogContext, true);
                      },
                      child: const Text(
                        "Exit",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );

  return result ?? false;
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

double contentBottomPadding({
  required bool cartVisible,
  required double bottomBarHeight,
  required double cartBarHeight,
  required double extraGap,
}) {
  return bottomBarHeight +
      (cartVisible ? (cartBarHeight + extraGap) : extraGap);
}

final Map<String, Uint8List> imageCache = {};
Uint8List? getProductImage({
  required String productCode,
  required String? imageString,
}) {
  if (imageString == null || imageString.isEmpty) return null;

  if (imageCache.containsKey(productCode)) {
    return imageCache[productCode];
  }

  final bytes = decodeImage(imageString);
  if (bytes != null) {
    imageCache[productCode] = bytes;
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
        !imageCache.containsKey(code)) {
      final bytes = decodeImage(img);
      if (bytes != null) {
        imageCache[code] = bytes;
      }
    }
  }
}
// Future<void> _checkAndShowExpiryWarningOnceDaily() async {
//   try {
//     final prefs = await SharedPreferences.getInstance();

//     ///  CALL REGISTER API ONCE PER DAY

//     final today = DateTime.now();
//     final todayKey =
//         "${today.year.toString().padLeft(4, '0')}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

//     final lastApiCall = prefs.getString('subscription_api_last_called');

//     //if (lastApiCall != todayKey) {
//     final code = await SharedPreferenceHelper().getSubscriptionCode();

//     if (code.isNotEmpty) {
//       await context.read<RegisterCubit>().registerServer(
//         RegisterServerRequest(slno: code),
//       );
//     }

//     await prefs.setString('subscription_api_last_called', todayKey);
//     //}

//     // ✅ Get expiry from your SharedPreferenceHelper
//     final expiryString = await SharedPreferenceHelper().getExpiryDate();

//     // If no expiry stored, do nothing (or you can treat as expired)
//     if (expiryString.isEmpty || expiryString.trim().isEmpty) return;

//     final expiry = DateTime.parse(expiryString);

//     // Compare date-only (ignore time)
//     final todayDate = DateTime(today.year, today.month, today.day);

//     final expDate = DateTime(expiry.year, expiry.month, expiry.day);

//     final daysLeft = expDate.difference(todayDate).inDays;

//     // ✅ Show only when within 7 days before expiry (1..7)
//     if (daysLeft < 1 || daysLeft > 7) return;

//     // ✅ "Once per day" guard using SharedPreferences
//     final lastShown = prefs.getString(
//       'expiry_warning_last_shown',
//     ); // yyyy-mm-dd

//     if (lastShown == todayKey) return; // already shown today

//     await prefs.setString('expiry_warning_last_shown', todayKey);

//     if (!mounted) return;
//     _showExpirySoonDialog(daysLeft: daysLeft, expiryDate: expDate);
//   } catch (e) {
//     debugPrint("Expiry check error: $e");
//   }
// }

// void _showExpirySoonDialog({
//   required int daysLeft,
//   required DateTime expiryDate,
// }) {
//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (_) => AlertDialog(
//       title: Row(
//         children: [
//           Icon(Icons.warning, color: Color(0xFFFFC107)),
//           Text("Subscription Expiring "),
//         ],
//       ),
//       content: Text(
//         "Your subscription will expire in $daysLeft day(s).\n\nPlease renew to avoid interruption.",
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: const Text("OK"),
//         ),
//       ],
//     ),
//   );
// }

List<FetchProductDetails> searchProducts(
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

void handleGridTap({
  required BuildContext context,
  required int itemTapBehavior,
  required FetchProductDetails product,
  required CartManager cartManager,
  required ValueNotifier<bool> showCartBar,
}) {
  if (itemTapBehavior == 2) {
    showProductDialog(context, product, cartManager);
    return;
  }

  final items = cartManager.cartItems.value;
  final exists = items.any((e) => e.productCode == product.productCode);

  if (exists) {
    cartManager.incrementQuantity(product.productCode!);
  } else {
    cartManager.addToCart(
      CartItem(
        lineNo: 0,
        customerId: 1,
        productCode: product.productCode!,
        productName: product.productName!,
        qty: 1,
        oldQty: 0,
        salesRate: double.tryParse(product.salesPrice ?? '0') ?? 0.0,
        unitId: product.unitId.toString(),
        purchaseCost: product.purchaseRate ?? '0',
        groupId: product.group_id,
        categoryId: product.categoryId!,
        productImage: product.productImageByte ?? '',
        excludeRate: '',
        subtotal: '0.0',
        vatId: product.vatId?.toString() ?? '0',
        vatAmount: '0.0',
        totalAmount: '0.00',
        conversion_rate: product.conversionRate ?? '0',
        category: product.categoryName ?? '',
        groupName: product.groupName,
        product_description: '',
      ),
    );
    showCartBar.value = true;
  }
}

void toggleMenuModeWithAnimation({
  required BuildContext context,
  required AnimationController menuAnimationController,
  required TextEditingController searchController,
}) {
  final saleCubit = context.read<SaleCubit>();
  final wasMenuMode = saleCubit.isMenuMode;

  // Start fade out animation
  menuAnimationController.reverse().then((_) {
    // Toggle menu mode
    saleCubit.toggleMenuMode();

    if (saleCubit.isMenuMode) {
      // ✅ entering menu mode -> ensure categories are loaded
      context.read<CategoriesCubit>().loadCategoriesFromLocal();
      saleCubit.hideSearchBar();
      searchController.clear();
      saleCubit.clearSearchQuery();
    }

    // ✅ IMPORTANT: when coming BACK from menu/category to home grid
    if (wasMenuMode) {
      saleCubit.resetCategory(); // set "All"
    }

    // FIX: Always ensure products are loaded for current mode
    context.read<ProductCubit>().loadProductsFromLocal();

    // Start fade in animation
    menuAnimationController.forward();
  });
}
