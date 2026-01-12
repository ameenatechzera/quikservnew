// import 'dart:convert';
// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:quikservnew/features/cart/data/models/cart_item_model.dart';
// import 'package:quikservnew/features/cart/domain/usecases/cart_manager.dart';
// import 'package:quikservnew/features/products/domain/entities/fetch_product_entity.dart';
// import 'package:quikservnew/features/sale/presentation/widgets/cart_bottom_bar.dart';

// class ProductDialogContent extends StatefulWidget {
//   final FetchProductDetails product;
//   final CartManager cartManager;

//   const ProductDialogContent({
//     super.key,
//     required this.product,
//     required this.cartManager,
//   });

//   @override
//   State<ProductDialogContent> createState() => _ProductDialogContentState();
// }

// class _ProductDialogContentState extends State<ProductDialogContent> {
//   late TextEditingController priceController;
//   bool isEditingPrice = false;

//   @override
//   void initState() {
//     super.initState();
//     priceController = TextEditingController(
//       text: widget.product.salesPrice ?? '0',
//     );
//   }

//   @override
//   void dispose() {
//     priceController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Decode image
//     Uint8List? imageBytes;
//     if (widget.product.productImageByte != null &&
//         widget.product.productImageByte!.isNotEmpty) {
//       try {
//         imageBytes = base64Decode(widget.product.productImageByte!);
//       } catch (_) {
//         imageBytes = null;
//       }
//     }

//     final String productCode = widget.product.productCode!;

//     return SizedBox(
//       child: Stack(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(18.0),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // ---------- IMAGE ----------
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(12),
//                   child: imageBytes != null
//                       ? Image.memory(
//                           imageBytes,
//                           width: 100,
//                           height: 100,
//                           fit: BoxFit.cover,
//                         )
//                       : Image.asset(
//                           "assets/images/freepik__the-style-is-candid-image-photography-with-natural__16410.jpeg",
//                           width: 100,
//                           height: 100,
//                           fit: BoxFit.cover,
//                         ),
//                 ),

//                 const SizedBox(width: 16),

//                 // ---------- CONTENT ----------
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const SizedBox(height: 4),
//                       Text(
//                         widget.product.productName ?? '',
//                         style: const TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),

//                       const SizedBox(height: 8),

//                       Row(
//                         children: [
//                           Text(
//                             widget.product.salesPrice ?? '0',
//                             style: const TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                          // ---------------- PRICE (INLINE EDIT) ----------------
//                       Row(
//                         children: [
//                           isEditingPrice
//                               ? SizedBox(
//                                   width: 80,
//                                   height: 30,
//                                   child: TextField(
//                                     controller: priceController,
//                                     keyboardType: TextInputType.number,
//                                     autofocus: true,
//                                     decoration: const InputDecoration(
//                                       isDense: true,
//                                       border: OutlineInputBorder(),
//                                     ),
//                                     onSubmitted: (_) {
//                                       setState(() {
//                                         isEditingPrice = false;
//                                       });
//                                     },
//                                   ),
//                                 )
//                               : Text(
//                                   priceController.text,
//                                   style: const TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),

//                           const SizedBox(width: 8),

//                           InkWell(
//                             onTap: () {
//                               setState(() {
//                                 isEditingPrice = !isEditingPrice;
//                               });
//                             },
//                             child: Icon(
//                               isEditingPrice
//                                   ? Icons.check
//                                   : Icons.edit,
//                               size: 14,
//                             ),
//                           ),
//                         ],
//                       ),

//                       const SizedBox(height: 12),

//                       Row(
//                         children: [
//                           // ---------- QTY CONTROLLER ----------
//                           ValueListenableBuilder<List<CartItem>>(
//                             valueListenable: widget.cartManager.cartItems,
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
//                                       onTap: qty > 0
//                                           ? () {
//                                               widget.cartManager
//                                                   .decrementQuantity(
//                                                     productCode,
//                                                   );
//                                             }
//                                           : null,
//                                       child: Icon(
//                                         Icons.remove,
//                                         size: 18,
//                                         color: qty > 0
//                                             ? Colors.black
//                                             : Colors.grey,
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
//                                           widget.cartManager.addToCart(
//                                             _buildCartItem(
//                                               qty: 1,
//                                               productCode: productCode,
//                                             ),
//                                           );
//                                         } else {
//                                           widget.cartManager.incrementQuantity(
//                                             productCode,
//                                           );
//                                         }
//                                       },
//                                       child: const Icon(Icons.add, size: 18),
//                                     ),

//                                     const SizedBox(width: 4),
//                                   ],
//                                 ),
//                               );
//                             },
//                           ),

//                           const SizedBox(width: 12),

//                           // ---------- ADD TO CART ----------
//                           Expanded(
//                             child: InkWell(
//                               onTap: () {
//                                 widget.cartManager.addToCart(
//                                   _buildCartItem(
//                                     qty: 1,
//                                     productCode: productCode,
//                                   ),
//                                 );
//                                 showCartBar.value = true;
//                                 Navigator.of(context).pop();
//                               },
//                               borderRadius: BorderRadius.circular(12),
//                               child: Container(
//                                 height: 40,
//                                 decoration: BoxDecoration(
//                                   color: const Color(0xFFEAB307),
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 child: const Center(
//                                   child: Text(
//                                     'Add To Cart',
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w700,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // ---------- CLOSE ----------
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
//   }// ---------------- CART ITEM BUILDER ----------------
//   CartItem _buildCartItem({
//     required int qty,
//     required String productCode,
//   }) {
//     return CartItem(
//       lineNo: 0,
//       customerId: 1,
//       productCode: productCode,
//       productName: widget.product.productName!,
//       qty: double.parse(qty),
//       oldQty: 0,
//       salesRate:
//           double.tryParse(priceController.text) ?? 0,
//       unitId: widget.product.unitId.toString(),
//       purchaseCost: widget.product.purchaseRate!,
//       groupId: widget.product.group_id,
//       categoryId: widget.product.categoryId!,
//       productImage: widget.product.productImageByte!,
//       excludeRate: '',
//       subtotal: '0.0',
//       vatId: widget.product.vatId!.toString(),
//       vatAmount: '0.0',
//       totalAmount: '0.00',
//       conversion_rate: widget.product.conversionRate!,
//       category: widget.product.categoryName!,
//       groupName: widget.product.groupName,
//       product_description: '',
//     );
//   }
// }
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:quikservnew/features/cart/data/models/cart_item_model.dart';
import 'package:quikservnew/features/cart/domain/usecases/cart_manager.dart';
import 'package:quikservnew/features/products/domain/entities/fetch_product_entity.dart';
import 'package:quikservnew/features/sale/presentation/widgets/cart_bottom_bar.dart';

class ProductDialogContent extends StatefulWidget {
  final FetchProductDetails product;
  final CartManager cartManager;

  const ProductDialogContent({
    super.key,
    required this.product,
    required this.cartManager,
  });

  @override
  State<ProductDialogContent> createState() => _ProductDialogContentState();
}

class _ProductDialogContentState extends State<ProductDialogContent> {
  TextEditingController priceController = TextEditingController();
  bool isEditingPrice = false;

  @override
  void initState() {
    super.initState();
    // priceController = TextEditingController(
    //   text: widget.product.salesPrice ?? '0',
    // );
    final cartItems = widget.cartManager.cartItems.value;

    CartItem? cartItem;
    try {
      cartItem = cartItems.firstWhere(
        (item) => item.productCode == widget.product.productCode,
      );
    } catch (_) {
      cartItem = null;
    }

    priceController.text = cartItem != null
        ? cartItem.salesRate.toStringAsFixed(2)
        : (widget.product.salesPrice ?? '0');
  }

  @override
  void dispose() {
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ---------------- IMAGE DECODE ----------------
    Uint8List? imageBytes;
    if (widget.product.productImageByte != null &&
        widget.product.productImageByte!.isNotEmpty) {
      try {
        imageBytes = base64Decode(widget.product.productImageByte!);
      } catch (_) {
        imageBytes = null;
      }
    }

    final String productCode = widget.product.productCode!;

    return SizedBox(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------------- IMAGE ----------------
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: imageBytes != null
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

                // ---------------- CONTENT ----------------
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 4),

                      // PRODUCT NAME
                      Text(
                        widget.product.productName ?? '',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // ---------------- PRICE (INLINE EDIT) ----------------
                      Row(
                        children: [
                          isEditingPrice
                              ? SizedBox(
                                  width: 80,
                                  height: 40,
                                  child: TextField(
                                    controller: priceController,
                                    keyboardType: TextInputType.number,
                                    autofocus: true,
                                    decoration: const InputDecoration(
                                      isDense: true,
                                      border: OutlineInputBorder(),
                                    ),
                                    onSubmitted: (_) {
                                      setState(() {
                                        isEditingPrice = false;
                                      });
                                    },
                                  ),
                                )
                              : Text(
                                  priceController.text,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                          const SizedBox(width: 8),

                          InkWell(
                            onTap: () {
                              setState(() {
                                isEditingPrice = !isEditingPrice;
                              });
                            },
                            child: Icon(
                              isEditingPrice ? Icons.check : Icons.edit,
                              size: 14,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          // ---------------- QTY CONTROLLER ----------------
                          ValueListenableBuilder<List<CartItem>>(
                            valueListenable: widget.cartManager.cartItems,
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
                                      onTap: qty > 0
                                          ? () {
                                              widget.cartManager
                                                  .decrementQuantity(
                                                    productCode,
                                                  );
                                            }
                                          : null,
                                      child: Icon(
                                        Icons.remove,
                                        size: 18,
                                        color: qty > 0
                                            ? Colors.black
                                            : Colors.grey,
                                      ),
                                    ),

                                    const SizedBox(width: 12),

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
                                          widget.cartManager.addToCart(
                                            _buildCartItem(
                                              qty: 1,
                                              productCode: productCode,
                                            ),
                                          );
                                        } else {
                                          widget.cartManager.incrementQuantity(
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

                          // ---------------- ADD TO CART ----------------
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                widget.cartManager.addToCart(
                                  _buildCartItem(
                                    qty: 1,
                                    productCode: productCode,
                                  ),
                                );
                                showCartBar.value = true;
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

          // ---------------- CLOSE ----------------
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

  // ---------------- CART ITEM BUILDER ----------------
  CartItem _buildCartItem({required int qty, required String productCode}) {
    return CartItem(
      lineNo: 0,
      customerId: 1,
      productCode: productCode,
      productName: widget.product.productName!,
      qty: double.parse(qty.toString()),
      oldQty: 0,
      salesRate: double.tryParse(priceController.text) ?? 0,
      unitId: widget.product.unitId.toString(),
      purchaseCost: widget.product.purchaseRate!,
      groupId: widget.product.group_id,
      categoryId: widget.product.categoryId!,
      productImage: widget.product.productImageByte!,
      excludeRate: '',
      subtotal: '0.0',
      vatId: widget.product.vatId!.toString(),
      vatAmount: '0.0',
      totalAmount: '0.00',
      conversion_rate: widget.product.conversionRate!,
      category: widget.product.categoryName!,
      groupName: widget.product.groupName,
      product_description: '',
    );
  }
}
