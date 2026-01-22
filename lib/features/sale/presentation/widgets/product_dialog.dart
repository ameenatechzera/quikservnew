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
  final TextEditingController qtyController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  bool isEditingPrice = false;
  bool isEditingQty = false;
  int localQty = 0;

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
    // ✅ load existing cart qty as initial display (but DO NOT change cart until Add To Cart)
    localQty = cartItem?.qty.toInt() ?? 0;
    qtyController.text = localQty.toString();

    priceController.text = cartItem != null
        ? cartItem.salesRate.toStringAsFixed(2)
        : (widget.product.salesPrice ?? '0');
  }

  @override
  void dispose() {
    priceController.dispose();
    qtyController.dispose();
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
                                      final txt = priceController.text.trim();
                                      final val = double.tryParse(txt);

                                      if (txt.isEmpty ||
                                          val == null ||
                                          val <= 0) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Please enter a valid price',
                                            ),
                                          ),
                                        );
                                        // // ✅ keep editing + reselect
                                        // setState(() => isEditingPrice = true);
                                        priceController.selection =
                                            TextSelection(
                                              baseOffset: 0,
                                              extentOffset:
                                                  priceController.text.length,
                                            );
                                        return;
                                      }

                                      setState(() => isEditingPrice = false);
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
                              if (isEditingPrice) {
                                // ✅ validate before closing edit
                                final txt = priceController.text.trim();
                                final val = double.tryParse(txt);

                                if (txt.isEmpty || val == null || val <= 0) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Please enter a valid price',
                                      ),
                                    ),
                                  );
                                  // // keep edit mode + select all
                                  // setState(() => isEditingPrice = true);
                                  priceController.selection = TextSelection(
                                    baseOffset: 0,
                                    extentOffset: priceController.text.length,
                                  );
                                  return;
                                }

                                setState(() => isEditingPrice = false);
                              } else {
                                setState(() => isEditingPrice = true);
                                WidgetsBinding.instance.addPostFrameCallback((
                                  _,
                                ) {
                                  priceController.selection = TextSelection(
                                    baseOffset: 0,
                                    extentOffset: priceController.text.length,
                                  );
                                });
                              }
                              // setState(() {
                              //   isEditingPrice = !isEditingPrice;
                              //   if (isEditingPrice) {
                              //     // Select full price text
                              //     priceController.selection = TextSelection(
                              //       baseOffset: 0,
                              //       extentOffset: priceController.text.length,
                              //     );
                              //   }
                              // });
                            },
                            child: Icon(
                              isEditingPrice ? Icons.check : Icons.edit,
                              size: 14,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Row(
                      //   children: [
                      //     // ---------------- QTY CONTROLLER ----------------
                      //     ValueListenableBuilder<List<CartItem>>(
                      //       valueListenable: widget.cartManager.cartItems,
                      //       builder: (context, cartItems, _) {
                      //         CartItem? cartItem;

                      //         try {
                      //           cartItem = cartItems.firstWhere(
                      //             (item) => item.productCode == productCode,
                      //           );
                      //         } catch (_) {
                      //           cartItem = null;
                      //         }

                      //         final int qty = cartItem?.qty.toInt() ?? 0;

                      //         return Container(
                      //           height: 40,
                      //           padding: const EdgeInsets.symmetric(
                      //             horizontal: 8,
                      //           ),
                      //           decoration: BoxDecoration(
                      //             color: Colors.white,
                      //             borderRadius: BorderRadius.circular(10),
                      //             border: Border.all(
                      //               color: Colors.grey.shade300,
                      //               width: 1.5,
                      //             ),
                      //           ),
                      //           child: Row(
                      //             mainAxisSize: MainAxisSize.min,
                      //             children: [
                      //               const SizedBox(width: 4),

                      //               // ➖ MINUS
                      //               InkWell(
                      //                 onTap: qty > 0
                      //                     ? () {
                      //                         widget.cartManager
                      //                             .decrementQuantity(
                      //                               productCode,
                      //                             );
                      //                       }
                      //                     : null,
                      //                 child: Icon(
                      //                   Icons.remove,
                      //                   size: 18,
                      //                   color: qty > 0
                      //                       ? Colors.black
                      //                       : Colors.grey,
                      //                 ),
                      //               ),

                      //               const SizedBox(width: 12),

                      //               // Text(
                      //               //   qty.toString().padLeft(2, '0'),
                      //               //   style: const TextStyle(
                      //               //     fontSize: 16,
                      //               //     fontWeight: FontWeight.w600,
                      //               //   ),
                      //               // ),
                      //               // ✅ TYPE QTY (LOCAL ONLY)
                      //               SizedBox(
                      //                 width: 44,
                      //                 height: 34,
                      //                 child: isEditingQty
                      //                     ? Focus(
                      //                         onFocusChange: (hasFocus) {
                      //                           if (!hasFocus) {
                      //                             final typed =
                      //                                 int.tryParse(
                      //                                   qtyController.text
                      //                                       .trim(),
                      //                                 ) ??
                      //                                 localQty;
                      //                             setState(() {
                      //                               localQty = typed < 0
                      //                                   ? 0
                      //                                   : typed;
                      //                               qtyController.text =
                      //                                   localQty.toString();
                      //                               isEditingQty = false;
                      //                             });
                      //                           }
                      //                         },
                      //                         child: TextField(
                      //                           controller: qtyController,
                      //                           autofocus: true,
                      //                           textAlign: TextAlign.center,
                      //                           keyboardType:
                      //                               TextInputType.number,
                      //                           decoration:
                      //                               const InputDecoration(
                      //                                 isDense: true,
                      //                                 contentPadding:
                      //                                     EdgeInsets.symmetric(
                      //                                       vertical: 8,
                      //                                       horizontal: 6,
                      //                                     ),
                      //                                 border:
                      //                                     OutlineInputBorder(),
                      //                               ),
                      //                           onSubmitted: (_) {
                      //                             FocusScope.of(
                      //                               context,
                      //                             ).unfocus();
                      //                           },
                      //                         ),
                      //                       )
                      //                     : InkWell(
                      //                         onTap: () {
                      //                           setState(() {
                      //                             isEditingQty = true;
                      //                             qtyController.selection =
                      //                                 TextSelection(
                      //                                   baseOffset: 0,
                      //                                   extentOffset:
                      //                                       qtyController
                      //                                           .text
                      //                                           .length,
                      //                                 );
                      //                           });
                      //                         },
                      //                         child: Center(
                      //                           child: Text(
                      //                             localQty.toString().padLeft(
                      //                               2,
                      //                               '0',
                      //                             ),
                      //                             style: const TextStyle(
                      //                               fontSize: 16,
                      //                               fontWeight: FontWeight.w600,
                      //                             ),
                      //                           ),
                      //                         ),
                      //                       ),
                      //               ),
                      //               const SizedBox(width: 12),

                      //               // ➕ PLUS
                      //               InkWell(
                      //                 onTap: () {
                      //                   if (cartItem == null) {
                      //                     widget.cartManager.addToCart(
                      //                       _buildCartItem(
                      //                         qty: 1,
                      //                         productCode: productCode,
                      //                       ),
                      //                     );
                      //                   } else {
                      //                     widget.cartManager.incrementQuantity(
                      //                       productCode,
                      //                     );
                      //                   }
                      //                 },
                      //                 child: const Icon(Icons.add, size: 18),
                      //               ),

                      //               const SizedBox(width: 4),
                      //             ],
                      //           ),
                      //         );
                      //       },
                      //     ),

                      //     const SizedBox(width: 12),
                      Row(
                        children: [
                          // ---------------- QTY (LOCAL ONLY) ----------------
                          Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
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

                                // ➖ MINUS (LOCAL ONLY)
                                InkWell(
                                  onTap: localQty > 0
                                      ? () {
                                          setState(() {
                                            localQty -= 1;
                                            qtyController.text = localQty
                                                .toString();
                                          });
                                        }
                                      : null,
                                  child: Icon(
                                    Icons.remove,
                                    size: 18,
                                    color: localQty > 0
                                        ? Colors.black
                                        : Colors.grey,
                                  ),
                                ),

                                const SizedBox(width: 10),

                                // ✅ TYPE QTY (LOCAL ONLY)
                                SizedBox(
                                  width: 44,
                                  height: 34,
                                  child: isEditingQty
                                      ? Focus(
                                          onFocusChange: (hasFocus) {
                                            if (!hasFocus) {
                                              final typed =
                                                  int.tryParse(
                                                    qtyController.text.trim(),
                                                  ) ??
                                                  localQty;
                                              setState(() {
                                                localQty = typed < 0
                                                    ? 0
                                                    : typed;
                                                qtyController.text = localQty
                                                    .toString();
                                                isEditingQty = false;
                                              });
                                            }
                                          },
                                          child: TextField(
                                            controller: qtyController,
                                            autofocus: true,
                                            textAlign: TextAlign.center,
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
                                              isDense: true,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                    vertical: 8,
                                                    horizontal: 6,
                                                  ),
                                              border: OutlineInputBorder(),
                                            ),
                                            onSubmitted: (_) {
                                              FocusScope.of(context).unfocus();
                                            },
                                          ),
                                        )
                                      : InkWell(
                                          onTap: () {
                                            setState(() {
                                              isEditingQty = true;
                                              qtyController
                                                  .selection = TextSelection(
                                                baseOffset: 0,
                                                extentOffset:
                                                    qtyController.text.length,
                                              );
                                            });
                                          },
                                          child: Center(
                                            child: Text(
                                              localQty.toString().padLeft(
                                                2,
                                                '0',
                                              ),
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                ),

                                const SizedBox(width: 10),

                                // ➕ PLUS (LOCAL ONLY)
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      localQty += 1;
                                      qtyController.text = localQty.toString();
                                    });
                                  },
                                  child: const Icon(Icons.add, size: 18),
                                ),

                                const SizedBox(width: 4),
                              ],
                            ),
                          ),

                          const SizedBox(width: 12),
                          // ---------------- ADD TO CART ----------------
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                // commit typed qty into localQty just in case user didn't unfocus
                                final typed =
                                    int.tryParse(qtyController.text.trim()) ??
                                    localQty;
                                localQty = typed < 0 ? 0 : typed;
                                qtyController.text = localQty.toString();

                                if (localQty == 0) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Please select quantity'),
                                    ),
                                  );
                                  return;
                                }

                                final cartItems =
                                    widget.cartManager.cartItems.value;

                                CartItem? cartItem;
                                try {
                                  cartItem = cartItems.firstWhere(
                                    (item) => item.productCode == productCode,
                                  );
                                } catch (_) {
                                  cartItem = null;
                                }

                                // final int qty = cartItem?.qty.toInt() ?? 0;
                                // ✅ Parse the edited price
                                final editedPrice =
                                    double.tryParse(
                                      priceController.text.trim(),
                                    ) ??
                                    double.tryParse(
                                      widget.product.salesPrice ?? '0',
                                    ) ??
                                    0.0;
                                if (cartItem == null) {
                                  // ✅ add ONLY on button click
                                  widget.cartManager.addToCart(
                                    _buildCartItem(
                                      qty: localQty,
                                      productCode: productCode,
                                      price: editedPrice,
                                    ),
                                  );
                                } else {
                                  widget.cartManager.removeFromCart(
                                    productCode,
                                  );

                                  widget.cartManager.addToCart(
                                    _buildCartItem(
                                      qty: localQty,
                                      productCode: productCode,
                                      price: editedPrice,
                                    ),
                                  );

                                  // // ✅ adjust ONLY on button click
                                  // final currentQty = cartItem.qty.toInt();

                                  // if (localQty > currentQty) {
                                  //   for (
                                  //     int i = 0;
                                  //     i < (localQty - currentQty);
                                  //     i++
                                  //   ) {
                                  //     widget.cartManager.incrementQuantity(
                                  //       productCode,
                                  //     );
                                  //   }
                                  // } else if (localQty < currentQty) {
                                  //   for (
                                  //     int i = 0;
                                  //     i < (currentQty - localQty);
                                  //     i++
                                  //   ) {
                                  //     widget.cartManager.decrementQuantity(
                                  //       productCode,
                                  //     );
                                  //   }
                                  // }

                                  // If you also need to update price for existing cart item,
                                  // do it in your cartManager (if you have a method).
                                  // Right now we keep your existing API.
                                }

                                showCartBar.value = true;
                                Navigator.of(context).pop();
                              },

                              // onTap: () {
                              //   widget.cartManager.addToCart(
                              //     _buildCartItem(
                              //       qty: 1,
                              //       productCode: productCode,
                              //     ),
                              //   );
                              //   showCartBar.value = true;
                              //   Navigator.of(context).pop();
                              // },
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
  CartItem _buildCartItem({
    required int qty,
    required String productCode,
    required double price,
  }) {
    return CartItem(
      lineNo: 0,
      customerId: 1,
      productCode: productCode,
      productName: widget.product.productName!,
      qty: double.parse(qty.toString()),
      oldQty: 0,
      salesRate: price,
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
