// import 'dart:convert';
// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:quikservnew/features/cart/data/models/cart_item_model.dart';
// import 'package:quikservnew/features/cart/domain/usecases/cart_manager.dart';
// import 'package:quikservnew/features/products/domain/entities/fetch_product_entity.dart';

// class ProductDialogContent extends StatelessWidget {
//   final FetchProductDetails product;
//   final CartManager cartManager;
//   const ProductDialogContent({
//     super.key,
//     required this.product,
//     required this.cartManager,
//   });

//   @override
//   Widget build(BuildContext context) {
//     // Decode image
//     Uint8List? imageBytes;
//     if (product.productImageByte != null &&
//         product.productImageByte!.isNotEmpty) {
//       try {
//         imageBytes = base64Decode(product.productImageByte!);
//       } catch (e) {
//         imageBytes = null;
//       }
//     }
//     final String productCode = product.productCode!;
//     return SizedBox(
//       child: Stack(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(18.0),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // ------ PRODUCT IMAGE ------
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(12),
//                   child:
//                       imageBytes != null
//                           ? Image.memory(
//                             imageBytes!,
//                             width: 100,
//                             height: 100,
//                             fit: BoxFit.cover,
//                           )
//                           : Image.asset(
//                             "assets/images/freepik__the-style-is-candid-image-photography-with-natural__16410.jpeg",
//                             // your image
//                             width: 100,
//                             height: 100,
//                             fit: BoxFit.cover,
//                           ),
//                 ),
//                 const SizedBox(width: 16),

//                 // ------ RIGHT SIDE CONTENT ------
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const SizedBox(height: 4),
//                       Text(
//                         product.productName ?? '',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                       const SizedBox(height: 8),

//                       // price + edit icon
//                       Row(
//                         children: [
//                           Text(
//                             '₹ ${product.salesPrice ?? '0'}',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           SizedBox(width: 8),
//                           Icon(Icons.edit, size: 16),
//                         ],
//                       ),

//                       Row(
//                         children: [
//                           // -------- QTY BOX --------
//                           // ---------- QTY CONTROLLER ----------
//                           ValueListenableBuilder<List<CartItem>>(
//                             valueListenable: cartManager.cartItems,
//                             builder: (context, cartItems, _) {
//                               CartItem? cartItem;

//                               try {
//                                 cartItem = cartItems.firstWhere(
//                                   (item) => item.productCode == productCode,
//                                 );
//                               } catch (_) {
//                                 cartItem = null;
//                               }

//                               final int qty = cartItem?.qty.toInt() ?? 0;
//                               return Container(
//                                 height: 40,
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 8,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(10),
//                                   border: Border.all(
//                                     color: Colors.grey.shade300,
//                                     width: 1.5,
//                                   ),
//                                 ),
//                                 child: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     const SizedBox(width: 4),

//                                     // ➖ MINUS
//                                     InkWell(
//                                       onTap:
//                                           qty > 0
//                                               ? () {
//                                                 cartManager.decrementQuantity(
//                                                   productCode,
//                                                 );
//                                               }
//                                               : null,
//                                       child: Icon(
//                                         Icons.remove,
//                                         size: 18,
//                                         color:
//                                             qty > 0
//                                                 ? Colors.black
//                                                 : Colors.grey,
//                                       ),
//                                     ),

//                                     const SizedBox(width: 12),

//                                     // 🔢 QTY
//                                     Text(
//                                       qty.toString().padLeft(2, '0'),
//                                       style: const TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),

//                                     const SizedBox(width: 12),

//                                     // ➕ PLUS
//                                     InkWell(
//                                       onTap: () {
//                                         if (cartItem == null) {
//                                           cartManager.addToCart(
//                                             CartItem(
//                                               lineNo: 0,
//                                               customerId: 1,
//                                               productCode: productCode,
//                                               productName: product.productName!,
//                                               qty: 1,
//                                               oldQty: 0,
//                                               salesRate:
//                                                   double.tryParse(
//                                                     product.salesPrice ?? '0',
//                                                   ) ??
//                                                   0,
//                                               unitId: product.unitId.toString(),
//                                               purchaseCost:
//                                                   product.purchaseRate!,
//                                               groupId: product.group_id,
//                                               categoryId: product.categoryId!,
//                                               productImage:
//                                                   product.productImageByte!,
//                                               excludeRate: '',
//                                               subtotal: '0.0',
//                                               vatId: product.vatId!.toString(),
//                                               vatAmount: '0.0',
//                                               totalAmount: '0.00',
//                                               conversion_rate:
//                                                   product.conversionRate!,
//                                               category: product.categoryName!,
//                                               groupName: product.groupName,
//                                               product_description: '',
//                                             ),
//                                           );
//                                         } else {
//                                           cartManager.incrementQuantity(
//                                             productCode,
//                                           );
//                                         }
//                                       },
//                                       child: const Icon(Icons.add, size: 18),
//                                     ),

//                                     const SizedBox(width: 4),
//                                     // SizedBox(width: 4),
//                                     // Icon(Icons.remove, size: 18),
//                                     // SizedBox(width: 12),
//                                     // Text(
//                                     //   '02',
//                                     //   style: TextStyle(
//                                     //     fontSize: 16,
//                                     //     fontWeight: FontWeight.w600,
//                                     //   ),
//                                     // ),
//                                     // SizedBox(width: 12),
//                                     // Icon(Icons.add, size: 18),
//                                     // SizedBox(width: 4),
//                                   ],
//                                 ),

//                               const SizedBox(width: 12),

//                               // -------- ADD TO CART BUTTON --------
//                               Expanded(
//                                 child: InkWell(
//                                   onTap: () {
//                                     // Add to cart
//                                     cartManager.addToCart(
//                                       CartItem(
//                                         lineNo: 0,
//                                         customerId: 1,
//                                         productCode: product.productCode!,
//                                         productName: product.productName!,
//                                         qty: 1,
//                                         oldQty: 0,
//                                         salesRate:
//                                             double.tryParse(
//                                               product.salesPrice ?? '0',
//                                             ) ??
//                                             0.0,
//                                         unitId: product.unitId.toString(),
//                                         purchaseCost: product.purchaseRate!,
//                                         groupId: product.group_id,
//                                         categoryId: product.categoryId!,
//                                         productImage: product.productImageByte!,
//                                         excludeRate: '',
//                                         subtotal: '0.0',
//                                         vatId: product.vatId!.toString(),
//                                         vatAmount: '0.0',
//                                         totalAmount: '0.00',
//                                         conversion_rate:
//                                             product.conversionRate!,
//                                         category: product.categoryName!,
//                                         groupName: product.groupName,
//                                         product_description: '',
//                                       ),
//                                     );

//                                     // Close dialog
//                                     Navigator.of(context).pop();
//                                   },
//                                   borderRadius: BorderRadius.circular(12),
//                                   child: Container(
//                                     height: 40,
//                                     decoration: BoxDecoration(
//                                       color: const Color(0xFFEAB307),
//                                       borderRadius: BorderRadius.circular(12),
//                                     ),
//                                     child: const Center(
//                                       child: Text(
//                                         'Add To Cart',
//                                         style: TextStyle(
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w700,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 8),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // ------ CLOSE (X) BUTTON ------
//           Positioned(
//             right: 10,
//             top: 10,
//             child: GestureDetector(
//               onTap: () => Navigator.of(context).pop(),
//               child: const Icon(Icons.close, color: Colors.red, size: 26),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:quikservnew/features/cart/data/models/cart_item_model.dart';
import 'package:quikservnew/features/cart/domain/usecases/cart_manager.dart';
import 'package:quikservnew/features/products/domain/entities/fetch_product_entity.dart';

class ProductDialogContent extends StatelessWidget {
  final FetchProductDetails product;
  final CartManager cartManager;

  const ProductDialogContent({
    super.key,
    required this.product,
    required this.cartManager,
  });

  @override
  Widget build(BuildContext context) {
    // Decode image
    Uint8List? imageBytes;
    if (product.productImageByte != null &&
        product.productImageByte!.isNotEmpty) {
      try {
        imageBytes = base64Decode(product.productImageByte!);
      } catch (_) {
        imageBytes = null;
      }
    }

    final String productCode = product.productCode!;

    return SizedBox(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------- IMAGE ----------
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child:
                      imageBytes != null
                          ? Image.memory(
                            imageBytes,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          )
                          : Image.asset(
                            "assets/images/freepik__the-style-is-candid-image-photography-with-natural__16410.jpeg",
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                ),

                const SizedBox(width: 16),

                // ---------- CONTENT ----------
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        product.productName ?? '',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          Text(
                            '₹ ${product.salesPrice ?? '0'}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.edit, size: 16),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          // ---------- QTY CONTROLLER ----------
                          ValueListenableBuilder<List<CartItem>>(
                            valueListenable: cartManager.cartItems,
                            builder: (context, cartItems, _) {
                              CartItem? cartItem;

                              try {
                                cartItem = cartItems.firstWhere(
                                  (item) => item.productCode == productCode,
                                );
                              } catch (_) {
                                cartItem = null;
                              }

                              final int qty = cartItem?.qty.toInt() ?? 0;

                              return Container(
                                height: 40,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(width: 4),

                                    // ➖ MINUS
                                    InkWell(
                                      onTap:
                                          qty > 0
                                              ? () {
                                                cartManager.decrementQuantity(
                                                  productCode,
                                                );
                                              }
                                              : null,
                                      child: Icon(
                                        Icons.remove,
                                        size: 18,
                                        color:
                                            qty > 0
                                                ? Colors.black
                                                : Colors.grey,
                                      ),
                                    ),

                                    const SizedBox(width: 12),

                                    // 🔢 QTY
                                    Text(
                                      qty.toString().padLeft(2, '0'),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),

                                    const SizedBox(width: 12),

                                    // ➕ PLUS
                                    InkWell(
                                      onTap: () {
                                        if (cartItem == null) {
                                          cartManager.addToCart(
                                            CartItem(
                                              lineNo: 0,
                                              customerId: 1,
                                              productCode: productCode,
                                              productName: product.productName!,
                                              qty: 1,
                                              oldQty: 0,
                                              salesRate:
                                                  double.tryParse(
                                                    product.salesPrice ?? '0',
                                                  ) ??
                                                  0,
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
                                        } else {
                                          cartManager.incrementQuantity(
                                            productCode,
                                          );
                                        }
                                      },
                                      child: const Icon(Icons.add, size: 18),
                                    ),

                                    const SizedBox(width: 4),
                                  ],
                                ),
                              );
                            },
                          ),

                          const SizedBox(width: 12),

                          // ---------- ADD TO CART ----------
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                cartManager.addToCart(
                                  CartItem(
                                    lineNo: 0,
                                    customerId: 1,
                                    productCode: productCode,
                                    productName: product.productName!,
                                    qty: 1,
                                    oldQty: 0,
                                    salesRate:
                                        double.tryParse(
                                          product.salesPrice ?? '0',
                                        ) ??
                                        0,
                                    unitId: product.unitId.toString(),
                                    purchaseCost: product.purchaseRate!,
                                    groupId: product.group_id,
                                    categoryId: product.categoryId!,
                                    productImage: product.productImageByte!,
                                    excludeRate: '',
                                    subtotal: '0.0',
                                    vatId: product.vatId!.toString(),
                                    vatAmount: '0.0',
                                    totalAmount: '0.00',
                                    conversion_rate: product.conversionRate!,
                                    category: product.categoryName!,
                                    groupName: product.groupName,
                                    product_description: '',
                                  ),
                                );
                                Navigator.of(context).pop();
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEAB307),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Add To Cart',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ---------- CLOSE ----------
          Positioned(
            right: 10,
            top: 10,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(Icons.close, color: Colors.red, size: 26),
            ),
          ),
        ],
      ),
    );
  }
}
