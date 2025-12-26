import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/features/cart/data/models/cart_item_model.dart';
import 'package:quikservnew/features/cart/domain/usecases/cart_manager.dart';
import 'package:quikservnew/features/cart/presentation/widgets/cart_item_row.dart';
import 'package:quikservnew/features/cart/presentation/widgets/payment_option.dart';
import 'package:quikservnew/features/cart/presentation/widgets/summary_row.dart';
import 'package:quikservnew/features/sale/domain/parameters/sale_save_request_parameter.dart';
import 'package:quikservnew/features/sale/presentation/bloc/sale_cubit.dart';

class CartScreen extends StatelessWidget {
  CartScreen({super.key});

  /// 🔹 UI-only payment selection
  final ValueNotifier<String> selectedPayment = ValueNotifier<String>('Cash');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          title: const Text('Cart'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: SafeArea(
          child: BlocConsumer<SaleCubit, SaleState>(
            listener: (context, state) {
              if (state is SaleSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Sale Saved! Invoice: ${state.response.details?.invoiceNo}',
                    ),
                    backgroundColor: AppColors.green,
                  ),
                );
                CartManager().clearCart();
                Navigator.pop(context);
              } else if (state is SaleError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${state.error}')),
                );
              }
            },
            builder: (context, state) {
              final items = CartManager().cartItems.value;

              if (items.isEmpty) {
                return const Center(child: Text("Your cart is empty"));
              }

              return Column(
                children: [
                  Expanded(
                    child: ValueListenableBuilder<List<CartItem>>(
                      valueListenable: CartManager().cartItems,
                      builder: (context, items, _) {
                        if (items.isEmpty) {
                          return const Center(
                            child: Text("Your cart is empty"),
                          );
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index];
                            return CartItemRow(item: item, index: index + 1);
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        bottomNavigationBar: ValueListenableBuilder<List<CartItem>>(
          valueListenable: CartManager().cartItems,
          builder: (context, items, _) {
            // 🔹 Always calculate dynamically
            double subTotal = items.fold(
              0.0,
              (sum, item) => sum + item.totalPrice,
            );
            double discount = 0;
            double tax = subTotal * 0.01;
            double total = subTotal - discount + tax;

            return BlocBuilder<SaleCubit, SaleState>(
              builder: (context, state) {
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.white),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Payment summary
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: const Text(
                          'Payment',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF4D7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            summaryRow(
                              'Sub Total :',
                              '₹ ${subTotal.toStringAsFixed(2)}',
                            ),
                            const SizedBox(height: 4),
                            summaryRow(
                              'Discount :',
                              '₹ ${discount.toStringAsFixed(2)}',
                            ),
                            const SizedBox(height: 4),
                            summaryRow('Tax :', '₹ ${tax.toStringAsFixed(2)}'),
                            const Divider(height: 16),
                            summaryRow(
                              'Total :',
                              '₹ ${total.toStringAsFixed(2)}',
                              isBold: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Payment Options
                      ValueListenableBuilder(
                        valueListenable: selectedPayment,
                        builder: (context, payment, _) {
                          return Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    selectedPayment.value = 'Cash';
                                  },
                                  child: PaymentOption(
                                    title: 'Cash',
                                    subtitle: '',
                                    selected: payment == 'Cash',
                                    icon: Icons.money,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => selectedPayment.value = 'Card',
                                  child: PaymentOption(
                                    title: 'Card',
                                    subtitle: '',
                                    selected: payment == 'Card',
                                    icon: Icons.credit_card,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    selectedPayment.value = 'Multi';
                                    _showMultiPaymentModal(context);
                                  },
                                  child: PaymentOption(
                                    title: 'Multi',
                                    subtitle: '',
                                    selected: payment == 'Multi',
                                    icon: Icons.dashboard_customize_outlined,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 12),

                      // Confirm Sale Button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child:
                            state is SaleLoading
                                ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                                : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFEAB307),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 0,
                                  ),
                                  onPressed: () {
                                    // Build SaveSaleRequest from cart
                                    final request = SaveSaleRequest(
                                      invoiceDate:
                                          DateTime.now()
                                              .toIso8601String()
                                              .split('T')
                                              .first,
                                      invoiceTime:
                                          DateTime.now()
                                              .toIso8601String()
                                              .split('T')
                                              .last
                                              .split('.')
                                              .first,
                                      ledgerId: 1,
                                      subTotal: subTotal,
                                      discountAmount: discount,
                                      vatAmount: tax,
                                      grandTotal: total,
                                      cashLedgerId: 1,
                                      cashAmount: total, // simple example
                                      cardLedgerId: 0,
                                      cardAmount: 0,
                                      creditAmount: 0,
                                      tableId: 1,
                                      supplierId: null,
                                      cashierId: 1,
                                      orderMasterId: 10,
                                      billStatus: '',
                                      salesType: '',
                                      billTokenNo: 22,
                                      createdUser: 1,
                                      branchId: 1,
                                      totalTax: tax,
                                      salesDetails:
                                          items
                                              .map(
                                                (e) => SaleDetail(
                                                  productCode: e.productCode,
                                                  productName: e.productName,
                                                  qty:
                                                      (e.qty as num)
                                                          .toInt(), // safer
                                                  unitId:
                                                      double.parse(
                                                        e.unitId,
                                                      ).toInt(), // safer if unitId is string
                                                  // qty: int.parse(e.qty.toString()),
                                                  // unitId: int.parse(e.unitId),
                                                  purchaseCost: double.parse(
                                                    e.purchaseCost,
                                                  ),
                                                  salesRate: e.salesRate,
                                                  excludeRate: e.salesRate,
                                                  subtotal: e.totalPrice,
                                                  vatId: 1,
                                                  vatAmount: tax / items.length,
                                                  totalAmount:
                                                      e.totalPrice +
                                                      (tax / items.length),
                                                  conversionRate: 1,
                                                ),
                                              )
                                              .toList(),
                                    );

                                    // Trigger cubit
                                    context.read<SaleCubit>().saveSale(request);
                                  },
                                  child: const Text(
                                    'Confirm Sale',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _showMultiPaymentModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Multi Payment',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),

              /// 🔹 Cash row
              Row(
                children: [
                  const SizedBox(width: 160, child: Text('Cash')),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Amount',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              /// 🔹 Card row
              Row(
                children: [
                  const SizedBox(width: 160, child: Text('Card')),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Amount',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// 🔹 Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEAB307),
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('OK'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
