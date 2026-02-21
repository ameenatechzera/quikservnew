import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/core/utils/widgets/app_snackbar.dart';
import 'package:quikservnew/core/utils/widgets/app_toast.dart';
import 'package:quikservnew/core/utils/widgets/common_appbar.dart';
import 'package:quikservnew/features/authentication/domain/parameters/deviceRegisterRequest.dart';
import 'package:quikservnew/features/authentication/domain/parameters/register_server_params.dart';
import 'package:quikservnew/features/authentication/presentation/bloc/registercubit/register_cubit.dart';
import 'package:quikservnew/features/cart/data/models/cart_item_model.dart';
import 'package:quikservnew/features/cart/domain/usecases/cart_manager.dart';
import 'package:quikservnew/features/cart/presentation/widgets/cart_item_row.dart';
import 'package:quikservnew/features/cart/presentation/widgets/payment_option.dart';
import 'package:quikservnew/features/cart/presentation/widgets/summary_row.dart';
import 'package:quikservnew/features/sale/domain/parameters/sale_save_request_parameter.dart';
import 'package:quikservnew/features/sale/presentation/bloc/sale_cubit.dart';
import 'package:quikservnew/features/salesReport/domain/parameters/salesDetails_request_parameter.dart';
import 'package:quikservnew/features/salesReport/presentation/widgets/print_thermal.dart';
import 'package:quikservnew/services/shared_preference_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final ValueNotifier<String> selectedPayment = ValueNotifier<String>('Cash');

  final ValueNotifier<double> multiCashAmount = ValueNotifier<double>(0);

  final ValueNotifier<double> multiCardAmount = ValueNotifier<double>(0);
  final SharedPreferenceHelper helper = SharedPreferenceHelper();
  TextEditingController expiredStatusController = TextEditingController();
  final _deviceIdController = TextEditingController();
  @override
  void initState() {
    expiredStatusController.text = 'false';
    //getDeviceId();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowExpiryWarningOnceDaily();
    });
    super.initState();
    _loadDefaultPayment();
  }

  /// 🔹 Load default payment from SharedPreferences
  Future<void> _loadDefaultPayment() async {
    final int savedPayment = await helper
        .getPaymentOption(); // 0 = Cash, 1 = Card

    if (savedPayment == 0) {
      selectedPayment.value = 'Cash';
    } else if (savedPayment == 1) {
      selectedPayment.value = 'Card';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: const CommonAppBar(title: "Cart"),
        body: SafeArea(
          child: BlocListener<RegisterCubit, RegisterState>(
            listener: (context, state) async {
              if (state is RegisterSuccess) {
                print('reached');
                // showAppSnackBar(context, "Reached");
                await _handleExpiryWarning();
              }
              if (state is DeviceRegisterSuccess) {
                if (state.registerResponse.data?.result == true) {
                  final code = await SharedPreferenceHelper().getSubscriptionCode();
                    await context.read<RegisterCubit>().registerServer(
                      RegisterServerRequest(slno: code),
                    );
                } else {
                  showNotRegisteredDialog(context);
                }
              }
            },
            child: BlocConsumer<SaleCubit, SaleState>(
              listener: (context, state) async {
                if (state is SalesDetailsFetchSuccess) {
                  print('responseFromSales ${state.response}');
                  Navigator.pop(context);

                  String selectedPrinter = (await SharedPreferenceHelper()
                      .loadSelectedPrinterSize())!;
                  if(selectedPrinter.length>1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PrintPage(
                              pageFrom: 'SalesReport',
                              // sales: saleList.first,
                              sales: state.response,
                            ),
                      ),
                    );
                  }
                  else{
                    Navigator.pop(context);
                  }
                  // Navigator.pop(context);
                }
                if (state is SaleSuccess) {
                  showAnimatedToast(
                    context,
                    message:
                        'Sale Saved! Invoice: ${state.response.details?.invoiceNo}',
                    isSuccess: true,
                  );
                  await SharedPreferenceHelper().setCurrentDate(
                    state.response.details?.currentDate,
                  );
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(
                  //     content: Text(
                  //       'Sale Saved! Invoice: ${state.response.details?.invoiceNo}',
                  //     ),
                  //     backgroundColor: AppColors.green,
                  //   ),
                  // );
                  CartManager().clearCart();
                  final branchId = await SharedPreferenceHelper().getBranchId();
                  print('reachedHHHHHHHHHHHHHHHH');
                  context.read<SaleCubit>().fetchSalesDetailsByMasterId(
                    FetchSalesDetailsRequest(
                      branchId: branchId,
                      SalesMasterId: state.response.details!.salesMasterId
                          .toString(),
                    ),
                  );
                } else if (state is SaleError) {
                  showAnimatedToast(
                    context,
                    message: 'Error: ${state.error}',
                    isSuccess: false,
                  );
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(content: Text('Error: ${state.error}')),
                  // );
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
        ),
        bottomNavigationBar: ValueListenableBuilder<List<CartItem>>(
          valueListenable: CartManager().cartItems,
          builder: (context, cartItems, _) {
            return FutureBuilder<Map<String, dynamic>>(
              future: _calculateTotals(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox(
                    height: 100,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final totals = snapshot.data!;
                final subTotal = totals['subTotal'] as double;
                final discount = totals['discount'] as double;
                final tax = totals['tax'] as double;
                final total = totals['total'] as double;
                final vatType = totals['vatType'] as String?;

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
                                  subTotal.toStringAsFixed(2),
                                ),
                                const SizedBox(height: 4),
                                summaryRow(
                                  'Discount :',
                                  discount.toStringAsFixed(2),
                                ),
                                const SizedBox(height: 4),
                                // Will Show tax label based on vatType
                                if (tax > 0)
                                  summaryRow(
                                    '${_getTaxLabel(vatType)} :',
                                    tax.toStringAsFixed(2),
                                  ),
                                //summaryRow('Tax :', '₹ ${tax.toStringAsFixed(2)}'),
                                const Divider(height: 16),
                                summaryRow(
                                  'Total :',
                                  total.toStringAsFixed(2),
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
                                        // ✅ clear multi values when leaving Multi
                                        multiCashAmount.value = 0;
                                        multiCardAmount.value = 0;
                                        selectedPayment.value = 'Cash';
                                      },
                                      child: PaymentOption(
                                        title: 'Cash',
                                        subtitle: '',
                                        selected: payment == 'Cash',
                                        icon: Icons.money,
                                        amount: payment == 'Cash' ? total : 0,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        // ✅ clear multi values when leaving Multi
                                        multiCashAmount.value = 0;
                                        multiCardAmount.value = 0;

                                        selectedPayment.value = 'Card';
                                      },
                                      child: PaymentOption(
                                        title: 'Card',
                                        subtitle: '',
                                        selected: payment == 'Card',
                                        icon: Icons.credit_card,
                                        amount: payment == 'Card' ? total : 0,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        final prevPayment =
                                            selectedPayment.value;
                                        _showMultiPaymentModal(
                                          context,
                                          total: total,
                                          prevPayment: prevPayment,
                                          onCancel: () {
                                            // ✅ go back to previous selection
                                            selectedPayment.value = prevPayment;
                                          },
                                          onOk: () {
                                            // ✅ set Multi only when user confirms
                                            selectedPayment.value = 'Multi';
                                          },
                                        );
                                        // selectedPayment.value = 'Multi';
                                        // _showMultiPaymentModal(
                                        //   context,
                                        //   total: total,
                                        //   prevPayment: prevPayment,
                                        // );
                                      },
                                      child: ValueListenableBuilder(
                                        valueListenable: multiCashAmount,
                                        builder: (context, cash, _) {
                                          return ValueListenableBuilder(
                                            valueListenable: multiCardAmount,
                                            builder: (context, card, __) {
                                              return PaymentOption(
                                                title: 'Multi',
                                                subtitle: cash == 0 && card == 0
                                                    ? ''
                                                    : 'Cash ${cash.toStringAsFixed(0)} | '
                                                          'Card ${card.toStringAsFixed(0)}',
                                                selected: payment == 'Multi',
                                                icon: Icons
                                                    .dashboard_customize_outlined,
                                                amount: cash + card,
                                              );
                                            },
                                          );
                                        },
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
                            child: state is SaleLoading
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
                                    onPressed: () async {
                                      print(
                                        'expiredStatus ${expiredStatusController.text}',
                                      );

                                      final payment = selectedPayment.value;

                                      double cashAmt = 0;
                                      double cardAmt = 0;

                                      if (payment == 'Cash') {
                                        cashAmt = total;
                                        cardAmt = 0;
                                      } else if (payment == 'Card') {
                                        cashAmt = 0;
                                        cardAmt = total;
                                      } else if (payment == 'Multi') {
                                        cashAmt = multiCashAmount.value;
                                        cardAmt = multiCardAmount.value;

                                        // safety check (only if user did not press OK or mismatch)
                                        if ((cashAmt + cardAmt - total).abs() >
                                            0.01) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Multi payment amount mismatch',
                                              ),
                                            ),
                                          );
                                          return;
                                        }
                                      } // 🔹 LOAD LEDGERS FROM SHARED PREF
                                      final ledgerData =
                                          await SharedPreferenceHelper()
                                              .getLedgers();

                                      final int cashLedgerId =
                                          ledgerData['cashLedgerId'] ?? 0;
                                      final int cardLedgerId =
                                          ledgerData['cardLedgerId'] ?? 0;

                                      final items =
                                          CartManager().cartItems.value;
                                      // Build SaveSaleRequest from cart
                                      final request = SaveSaleRequest(
                                        invoiceDate: DateTime.now()
                                            .toIso8601String()
                                            .split('T')
                                            .first,
                                        invoiceTime: DateTime.now()
                                            .toIso8601String()
                                            .split('T')
                                            .last
                                            .split('.')
                                            .first,
                                        ledgerId: 0,
                                        subTotal: subTotal,
                                        discountAmount: discount,
                                        vatAmount: tax,
                                        grandTotal: total,
                                        cashLedgerId: cashLedgerId,
                                        cashAmount: cashAmt,
                                        cardLedgerId: cardLedgerId,
                                        cardAmount: cardAmt,
                                        creditAmount: 0,
                                        tableId: 1,
                                        supplierId: 1,
                                        cashierId: 1,
                                        orderMasterId: 10,
                                        billStatus: '',
                                        salesType: '',
                                        billTokenNo: 22,
                                        createdUser: 1,
                                        branchId: 1,
                                        totalTax: tax,
                                        salesDetails: items
                                            .map(
                                              (e) => SaleDetail(
                                                productCode: e.productCode,
                                                productName: e.productName,
                                                qty: (e.qty as num).toInt(),
                                                // safer
                                                unitId: double.parse(
                                                  e.unitId,
                                                ).toInt(),
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
                                      if (expiredStatusController.text
                                              .toString() ==
                                          'true') {
                                        // Trigger cubit
                                        context.read<SaleCubit>().saveSale(
                                          request,
                                        );
                                      } else {
                                        print('expiredCheckFalse');
                                      }
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
            );
          },
        ),
      ),
    );
  }

  /// 🔹 Get the appropriate tax label based on vatType
  String _getTaxLabel(String? vatType) {
    switch (vatType?.toLowerCase()) {
      case 'tax':
        return 'Tax';
      case 'gst':
        return 'GST';
      default:
        return ''; // Default label if null or unknown
    }
  }

  /// 🔹 Calculate totals dynamically using VAT settings
  Future<Map<String, dynamic>> _calculateTotals() async {
    final items = CartManager().cartItems.value;
    final subTotal = items.fold(0.0, (sum, item) => sum + item.totalPrice);
    final discount = 0.0;

    final vatStatus = await SharedPreferenceHelper().getVatStatus();
    final vatType = await SharedPreferenceHelper().getVatType();
    double tax = 0.0;
    if (vatStatus == true) {
      // Apply 1% tax regardless of tax type (tax or gst)
      tax = subTotal * 0.01; // 1% tax
    }
    final total = subTotal - discount + tax;

    return {
      'subTotal': subTotal,
      'discount': discount,
      'tax': tax,
      'total': total,
      'vatType': vatType,
    };
  }

  void _showMultiPaymentModal(
    BuildContext context, {
    required double total,
    required String prevPayment,
    required VoidCallback onCancel,
    required VoidCallback onOk,
  }) {
    // ✅ If user already set Multi before, preload saved values
    final bool wasMulti = prevPayment == 'Multi';
    // final double initialCash = prevPayment == 'Cash' ? total : 0;
    // final double initialCard = prevPayment == 'Card' ? total : 0;
    final double initialCash = wasMulti
        ? multiCashAmount.value
        : (prevPayment == 'Cash' ? total : 0);

    final double initialCard = wasMulti
        ? multiCardAmount.value
        : (prevPayment == 'Card' ? total : 0);

    // ✅ TEMP values (only commit on OK)
    double tempCash = initialCash;
    double tempCard = initialCard;

    final cashCtrl = TextEditingController(
      text: initialCash == 0 ? '' : initialCash.toStringAsFixed(2),
    );
    final cardCtrl = TextEditingController(
      text: initialCard == 0 ? '' : initialCard.toStringAsFixed(2),
    );

    bool isAutoUpdating = false;
    bool closedByButton = false;
    double _parse(String v) => double.tryParse(v.trim()) ?? 0;

    // double _clampToTotal(double v) {
    //   if (v < 0) return 0;
    //   if (v > total) return total;
    //   return v;
    // }

    void _setText(TextEditingController c, double value) {
      final t = value == 0 ? '' : value.toStringAsFixed(2);
      c.value = TextEditingValue(
        text: t,
        selection: TextSelection.collapsed(offset: t.length),
      );
    }

    // ✅ INPUT FORMATTER: stop typing if value > total
    TextInputFormatter _maxTotalFormatter(double total) {
      return TextInputFormatter.withFunction((oldValue, newValue) {
        final t = newValue.text.trim();

        // allow empty
        if (t.isEmpty) return newValue;

        // allow just "." while typing
        if (t == ".") return newValue;

        final v = double.tryParse(t);
        if (v == null) return oldValue;

        // ❌ reject if exceeds total
        if (v > total) return oldValue;

        return newValue;
      });
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            // ✅ back button behaves like Cancel
            if (!closedByButton) onCancel();
            return true;
          },
          child: Padding(
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
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Total: ${total.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 16),

                /// 🔹 Cash row
                Row(
                  children: [
                    const SizedBox(width: 160, child: Text('Cash')),
                    Expanded(
                      child: TextField(
                        controller: cashCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d{0,2}$'), // 2 decimals
                          ),
                          _maxTotalFormatter(total), // ✅ stop if > total
                        ],
                        decoration: InputDecoration(
                          hintText: 'Amount',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onChanged: (v) {
                          if (isAutoUpdating) return;
                          isAutoUpdating = true;

                          final cash = _parse(v);
                          final card = total - cash;

                          // ✅ update TEMP only
                          tempCash = cash;
                          tempCard = card;

                          // if ((_parse(v) - cash).abs() > 0.001) {
                          //   _setText(cashCtrl, cash);
                          // }
                          _setText(cardCtrl, card);

                          isAutoUpdating = false;
                        },
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
                        controller: cardCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d{0,2}$'),
                          ),
                          _maxTotalFormatter(total), // ✅ stop if > total
                        ],
                        decoration: InputDecoration(
                          hintText: 'Amount',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onChanged: (v) {
                          if (isAutoUpdating) return;
                          isAutoUpdating = true;

                          final card = _parse(v);
                          final cash = total - card;

                          // ✅ update TEMP only
                          tempCard = card;
                          tempCash = cash;

                          // if ((_parse(v) - card).abs() > 0.001) {
                          //   _setText(cardCtrl, card);
                          // }
                          _setText(cashCtrl, cash);

                          isAutoUpdating = false;
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          closedByButton = true;
                          onCancel();
                          // ✅ Cancel = do nothing, just close
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
                          // ✅ OK = commit values
                          if ((tempCash + tempCard - total).abs() > 0.01) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Cash + Card must equal Total'),
                              ),
                            );
                            return;
                          }
                          closedByButton = true;
                          multiCashAmount.value = tempCash;
                          multiCardAmount.value = tempCard;
                          onOk();
                          Navigator.pop(context);
                        },
                        child: const Text('OK'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ).whenComplete(() {
      // ✅ swipe down / tap outside behaves like Cancel too
      if (!closedByButton) onCancel();
    });
  }

  Future<void> _handleExpiryWarning() async {
    print('reachedHaris');
    expiredStatusController.text = 'true';
    final prefs = await SharedPreferences.getInstance();

    final today = DateTime.now();
    final todayKey =
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    final expiryString = await SharedPreferenceHelper().getExpiryDate();

    if (expiryString.isEmpty || expiryString.trim().isEmpty) return;

    final expiry = DateTime.parse(expiryString);
    String? st_CurrentDate = await SharedPreferenceHelper().getCurrentDate();

    // final todayDate = DateTime(today.year, today.month, today.day);
    // final todayDate = await SharedPreferenceHelper().getCurrentDate();
    DateTime todayDate;
    try {
      todayDate = DateTime.parse(st_CurrentDate!);
      print('todayDate $todayDate');
    } catch (_) {
      todayDate = DateTime(today.year, today.month, today.day);
      print('todayDateCatch $todayDate');
    }

    final expDate = DateTime(expiry.year, expiry.month, expiry.day);

    final daysLeft = expDate.difference(todayDate).inDays;
    print('daysLeft $daysLeft');

    // if (daysLeft < 1 || daysLeft > 7) return;
    if (daysLeft > 7) return;

    final lastShown = prefs.getString('expiry_warning_last_shown');

    //if (lastShown == todayKey) return; //check once in a day

    await prefs.setString('expiry_warning_last_shown', todayKey);

    if (!mounted) return;

    _showExpirySoonDialog(daysLeft: daysLeft, expiryDate: expDate);
  }

  Future<void> _checkAndShowExpiryWarningOnceDaily() async {
    print('reached__checkAndShowExpiryWarningOnceDaily');
    try {
      final prefs = await SharedPreferences.getInstance();

      ///  CALL REGISTER API ONCE PER DAY

      final today = DateTime.now();
      final todayKey =
          "${today.year.toString().padLeft(4, '0')}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

      final lastApiCall = prefs.getString('subscription_api_last_called');

      //if (lastApiCall != todayKey) {
        print('reachedHere');
        final code = await SharedPreferenceHelper().getSubscriptionCode();
      final deviceId = await SharedPreferenceHelper().getDeviceID();
        // if (code.isNotEmpty) {
        //   await context.read<RegisterCubit>().registerServer(
        //     RegisterServerRequest(slno: code),
        //   );
        // }
        if (code.isNotEmpty) {
          context.read<RegisterCubit>().checkDeviceRegisterStatus(
            DeviceRegisterRequest(
              deviceId: deviceId.toString(),
            ),
          );
        }

        await prefs.setString('subscription_api_last_called', todayKey);
      // } else {
      //   print('elseCaseExpirewd');
      //   expiredStatusController.text = 'true';
      // }

      // ✅ Get expiry from your SharedPreferenceHelper
      // final expiryString = await SharedPreferenceHelper().getExpiryDate();
      //
      // // If no expiry stored, do nothing (or you can treat as expired)
      // if (expiryString.isEmpty || expiryString.trim().isEmpty) return;
      //
      // final expiry = DateTime.parse(expiryString);
      //
      // // Compare date-only (ignore time)
      // final todayDate = DateTime(today.year, today.month, today.day);
      //
      // final expDate = DateTime(expiry.year, expiry.month, expiry.day);
      //
      // final daysLeft = expDate.difference(todayDate).inDays;
      //
      // // ✅ Show only when within 7 days before expiry (1..7)
      // if (daysLeft < 1 || daysLeft > 7) return;
      //
      // // ✅ "Once per day" guard using SharedPreferences
      // final lastShown = prefs.getString(
      //   'expiry_warning_last_shown',
      // ); // yyyy-mm-dd
      //
      // if (lastShown == todayKey) return; // already shown today
      //
      // await prefs.setString('expiry_warning_last_shown', todayKey);
      //
      // if (!mounted) return;
      // _showExpirySoonDialog(daysLeft: daysLeft, expiryDate: expDate);
    } catch (e) {
      debugPrint("Expiry check error: $e");
    }
  }

  void _showExpirySoonDialog({
    required int daysLeft,
    required DateTime expiryDate,
  }) {
    String st_head = 'Subscription Expiring';
    String st_text =
        'Your subscription will expire in $daysLeft day(s).\n\nPlease renew to avoid interruption.';
    if (daysLeft == 0) {
      st_text = 'Your subscription expired.';
      st_head = 'Subscription Expired';
      expiredStatusController.text = 'false';
    } else {
      expiredStatusController.text = 'true';
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: Color(0xFFFFC107)),
            Text(st_head),
          ],
        ),
        content: Text(st_text),
        actions: [
          TextButton(
            //onPressed: () => Navigator.pop(context),
            onPressed: () {
              if (daysLeft <= 0) {
                exit(0);
              } else {
                Navigator.pop(context);
              }
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
  Future<String> getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      print('androidInfo.id ${androidInfo.id}');
      _deviceIdController.text = androidInfo.id.toString();
      return androidInfo.id; // ANDROID_ID
    }

    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor ?? 'unknown-ios-id';
    }

    return 'unsupported-platform';
  }

  
  void showNotRegisteredDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // ❌ User cannot close by tapping outside
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false, // ❌ Disable back button
          child: AlertDialog(
            title: const Text("Device Not Registered"),
            content: const Text("Your device is not registered now."),
            actions: [
              TextButton(
                onPressed: () {
                  // Exit the app
                  if (Platform.isAndroid) {
                    SystemNavigator.pop();
                  } else {
                    exit(0);
                  }
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );
      },
    );
  }
}
