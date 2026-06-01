import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quikservnew/core/appdata/appdata.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/core/utils/widgets/app_toast.dart';
import 'package:quikservnew/features/authentication/domain/parameters/register_server_params.dart';
import 'package:quikservnew/features/authentication/presentation/bloc/registercubit/register_cubit.dart';
import 'package:quikservnew/features/authentication/presentation/screens/login_screen.dart';
import 'package:quikservnew/features/cart/data/models/cart_item_model.dart';
import 'package:quikservnew/features/cart/domain/usecases/cart_manager.dart';
import 'package:quikservnew/features/cart/presentation/helper/cartscreen_helper.dart';
import 'package:quikservnew/features/cart/presentation/widgets/cart_item_row.dart';
import 'package:quikservnew/features/cart/presentation/widgets/payment_option.dart';
import 'package:quikservnew/features/cart/presentation/widgets/summary_row.dart';
import 'package:quikservnew/features/sale/domain/entities/loyalty_search_result.dart';
import 'package:quikservnew/features/sale/domain/parameters/sale_save_request_parameter.dart';
import 'package:quikservnew/features/sale/presentation/bloc/sale_cubit.dart';
import 'package:quikservnew/features/salesReport/domain/parameters/salesDetails_request_parameter.dart';
import 'package:quikservnew/features/salesReport/presentation/widgets/print_thermal.dart';
import 'package:quikservnew/services/shared_preference_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'CustomerListBySearch.dart';

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
  TextEditingController totalSalesController = TextEditingController();
  TextEditingController customerNameController = TextEditingController();
  TextEditingController customerPhoneController = TextEditingController();
  final _deviceIdController = TextEditingController();
  final CartScreenHelper cartScreenHelper = CartScreenHelper();
  bool _isButtonDisabled = false;
  LoyaltyCustomer? _selectedCustomer;
  bool _redeemPoints = false;
  bool _redeemEligible = false;
  String st_RedeemAmount = '', st_points_earned = '';
  bool _collectCustomerSaveOnSale = false;

  @override
  void initState() {
    //AppData.saleType ='Dine-In';
    expiredStatusController.text = 'false';
    //getDeviceId();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cartScreenHelper.checkAndShowExpiryWarningOnceDaily(
        context: context,
        expiredStatusController: expiredStatusController,
      );
    });
    super.initState();
    _loadDefaultPayment();
  }

  /// 🔹 Load default payment from SharedPreferences
  Future<void> _loadDefaultPayment() async {
    final int savedPayment = await helper
        .getPaymentOption(); // 0 = Cash, 1 = Card
    final int collectedCustomer = await helper
        .getCustomerDetailsOnSale(); // 0 = Not Collecting Customer Details, 1 = Collecting Customer Details
    if(collectedCustomer == 1){
      _collectCustomerSaveOnSale = true;
    }
    if (savedPayment == 0) {
      selectedPayment.value = 'Cash';
    } else if (savedPayment == 1) {
      selectedPayment.value = 'Card';
    }
  }

  Future<void> _openCustomerSearch() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const CustomerListBySearchPage()),
    );

    if (result != null) {
      setState(() {
        _selectedCustomer = result;
      });

      print('selectedCustomer $_selectedCustomer');
      print('totalSalesController ${totalSalesController.text}');
      print('totalEarnedAmount ${_selectedCustomer!.totalEarnedAmount}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          title:  Text(
            AppData.saleType!,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: AppColors.theme,
          foregroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          actions: [
            InkWell(
              onTap: _openCustomerSearch,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 8,
                ),
                child: Row(
                  children: [
                    const Text(
                      'Search Customers',
                      style: TextStyle(color: Colors.black),
                    ),
                    const SizedBox(width: 8),

                    IconButton(
                      icon: const Icon(Icons.search, color: Colors.black),
                      onPressed: _openCustomerSearch,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: BlocListener<RegisterCubit, RegisterState>(
            listener: (context, state) async {
              if (state is RegisterSuccess) {
                await cartScreenHelper.handleExpiryWarning(
                  context: context,
                  expiredStatusController: expiredStatusController,
                );
              }
              if (state is DeviceRegisterSuccess) {
                if (state.registerResponse.data?.result == true) {
                  final code = await SharedPreferenceHelper()
                      .getSubscriptionCode();
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
                  Navigator.pop(context);
                  CartManager().clearCart();
                  String selectedPrinter = (await SharedPreferenceHelper()
                      .loadSelectedPrinterSize())!;
                  print('selectedPrinter $selectedPrinter');
                  if (selectedPrinter.length > 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PrintPage(
                          pageFrom: 'SalesReport',
                          sales: state.response,
                        ),
                      ),
                    );
                  } else {
                    Navigator.pop(context);
                  }
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
                  final branchId = await SharedPreferenceHelper().getBranchId();
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
                }
              },
              builder: (context, state) {
                return ValueListenableBuilder<List<CartItem>>(
                  valueListenable: CartManager().cartItems,
                  builder: (context, cartItems, _) {
                    if (cartItems.isEmpty) {
                      return const Center(child: Text("Your cart is empty"));
                    }

                    return FutureBuilder<Map<String, dynamic>>(
                      future: CartScreenHelper().calculateTotals(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const SizedBox(
                            height: 100,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final totals = snapshot.data!;
                        final subTotal = totals['subTotal'] as double;
                        var discount = totals['discount'] as double;
                        final tax = totals['tax'] as double;
                        var total = totals['total'] as double;
                        final vatType = totals['vatType'] as String?;
                        double redeemAmount = 0, pointsEarned = 0;
                        totalSalesController.text = total.toString();

                        // double totalSalesAmount = double.parse(totalSalesController.text.toString());
                        // double totalEarnedAmount = 0;
                        // try {
                        //    totalEarnedAmount = double.parse(
                        //       _selectedCustomer!.totalEarnedAmount.toString());
                        // }catch(_){
                        //
                        // }
                        // if(totalSalesAmount>=totalEarnedAmount){
                        //   _redeemEligible = true;
                        // }

                        // ── apply redeem deduction once here ──
                        if (_redeemPoints && _selectedCustomer != null) {
                          final dbl_redeemLimit =
                              double.tryParse(
                                _selectedCustomer!.totalEarnedAmount,
                              ) ??
                              0;

                          if (total >= dbl_redeemLimit && dbl_redeemLimit > 0) {
                            redeemAmount =
                                double.parse(
                                  _selectedCustomer!.totalPointsEarned,
                                ) *
                                double.parse(_selectedCustomer!.pointValue);
                            total = total - redeemAmount;
                            discount = redeemAmount;
                          }
                        } else {
                          if (_selectedCustomer != null) {
                            double amountPerPoint = double.parse(
                              _selectedCustomer!.amountPerPoint,
                            );
                            double dbl_billTotal = total;
                            pointsEarned = dbl_billTotal / amountPerPoint;
                            st_points_earned = pointsEarned.toString();
                          }
                        }

                        return Column(
                          // ← outer Column
                          children: [
                            /// ── TOP: scrollable area ──
                            Expanded(
                              // ← takes all space above bottom bar
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    /// Cart items
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 5,
                                      ),
                                      itemCount: cartItems.length,
                                      itemBuilder: (context, index) {
                                        return CartItemRow(
                                          item: cartItems[index],
                                          index: index + 1,
                                        );
                                      },
                                    ),

                                    /// Summary box
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Payment',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFFFF4D7),
                                              borderRadius:
                                                  BorderRadius.circular(12),
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
                                                if (tax > 0)
                                                  summaryRow(
                                                    '${CartScreenHelper().getTaxLabel(vatType)} :',
                                                    tax.toStringAsFixed(2),
                                                  ),
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

                                          /// Loyalty card
                                          if (_selectedCustomer != null)
                                            _buildLoyaltyCard(
                                              _selectedCustomer!,
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            /// ── BOTTOM: fixed, never scrolls ──
                            Container(
                              padding: const EdgeInsets.fromLTRB(
                                12,
                                10,
                                12,
                                12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.06),
                                    blurRadius: 8,
                                    offset: const Offset(0, -2),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  /// Payment options — Cash / Card / Multi
                                  ValueListenableBuilder(
                                    valueListenable: selectedPayment,
                                    builder: (context, payment, _) {
                                      return Row(
                                        children: [
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                multiCashAmount.value = 0;
                                                multiCardAmount.value = 0;
                                                selectedPayment.value = 'Cash';
                                              },
                                              child: PaymentOption(
                                                title: 'Cash',
                                                subtitle: '',
                                                selected: payment == 'Cash',
                                                iconPath:
                                                    'assets/icons/cashicon.svg',
                                                amount: payment == 'Cash'
                                                    ? total
                                                    : 0,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                multiCashAmount.value = 0;
                                                multiCardAmount.value = 0;
                                                selectedPayment.value = 'Card';
                                              },
                                              child: PaymentOption(
                                                title: 'Card',
                                                subtitle: '',
                                                selected: payment == 'Card',
                                                iconPath:
                                                    'assets/icons/cardicon.svg',
                                                amount: payment == 'Card'
                                                    ? total
                                                    : 0,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                final prevPayment =
                                                    selectedPayment.value;
                                                var onCancel = () {
                                                  selectedPayment.value =
                                                      prevPayment;
                                                };
                                                var onOk = () {
                                                  selectedPayment.value =
                                                      'Multi';
                                                };
                                                final bool wasMulti =
                                                    prevPayment == 'Multi';
                                                final double initialCash =
                                                    wasMulti
                                                    ? multiCashAmount.value
                                                    : (prevPayment == 'Cash'
                                                          ? total
                                                          : 0);
                                                final double initialCard =
                                                    wasMulti
                                                    ? multiCardAmount.value
                                                    : (prevPayment == 'Card'
                                                          ? total
                                                          : 0);
                                                double tempCash = initialCash;
                                                double tempCard = initialCard;
                                                final cashCtrl =
                                                    TextEditingController(
                                                      text: initialCash == 0
                                                          ? ''
                                                          : initialCash
                                                                .toStringAsFixed(
                                                                  2,
                                                                ),
                                                    );
                                                final cardCtrl =
                                                    TextEditingController(
                                                      text: initialCard == 0
                                                          ? ''
                                                          : initialCard
                                                                .toStringAsFixed(
                                                                  2,
                                                                ),
                                                    );
                                                bool isAutoUpdating = false;
                                                bool closedByButton = false;
                                                double _parse(String v) =>
                                                    double.tryParse(v.trim()) ??
                                                    0;
                                                void _setText(
                                                  TextEditingController c,
                                                  double value,
                                                ) {
                                                  final t = value == 0
                                                      ? ''
                                                      : value.toStringAsFixed(
                                                          2,
                                                        );
                                                  c.value = TextEditingValue(
                                                    text: t,
                                                    selection:
                                                        TextSelection.collapsed(
                                                          offset: t.length,
                                                        ),
                                                  );
                                                }

                                                TextInputFormatter
                                                _maxTotalFormatter(
                                                  double total,
                                                ) {
                                                  return TextInputFormatter.withFunction(
                                                    (oldValue, newValue) {
                                                      final t = newValue.text
                                                          .trim();
                                                      if (t.isEmpty)
                                                        return newValue;
                                                      if (t == '.')
                                                        return newValue;
                                                      final v = double.tryParse(
                                                        t,
                                                      );
                                                      if (v == null)
                                                        return oldValue;
                                                      if (v > total)
                                                        return oldValue;
                                                      return newValue;
                                                    },
                                                  );
                                                }

                                                showModalBottomSheet(
                                                  context: context,
                                                  isScrollControlled: true,
                                                  shape: const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                          top: Radius.circular(
                                                            16,
                                                          ),
                                                        ),
                                                  ),
                                                  builder: (context) {
                                                    return WillPopScope(
                                                      onWillPop: () async {
                                                        if (!closedByButton)
                                                          onCancel();
                                                        return true;
                                                      },
                                                      child: Padding(
                                                        padding: EdgeInsets.only(
                                                          left: 16,
                                                          right: 16,
                                                          top: 16,
                                                          bottom:
                                                              MediaQuery.of(
                                                                    context,
                                                                  )
                                                                  .viewInsets
                                                                  .bottom +
                                                              16,
                                                        ),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            const Text(
                                                              'Multi Payment',
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 8,
                                                            ),
                                                            Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(
                                                                'Total: ${total.toStringAsFixed(2)}',
                                                                style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 16,
                                                            ),
                                                            Row(
                                                              children: [
                                                                const SizedBox(
                                                                  width: 160,
                                                                  child: Text(
                                                                    'Cash',
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: TextField(
                                                                    controller:
                                                                        cashCtrl,
                                                                    keyboardType:
                                                                        const TextInputType.numberWithOptions(
                                                                          decimal:
                                                                              true,
                                                                        ),
                                                                    inputFormatters: [
                                                                      FilteringTextInputFormatter.allow(
                                                                        RegExp(
                                                                          r'^\d*\.?\d{0,2}$',
                                                                        ),
                                                                      ),
                                                                      _maxTotalFormatter(
                                                                        total,
                                                                      ),
                                                                    ],
                                                                    decoration: InputDecoration(
                                                                      hintText:
                                                                          'Amount',
                                                                      border: OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                              8,
                                                                            ),
                                                                      ),
                                                                    ),
                                                                    onChanged: (v) {
                                                                      if (isAutoUpdating)
                                                                        return;
                                                                      isAutoUpdating =
                                                                          true;
                                                                      tempCash =
                                                                          _parse(
                                                                            v,
                                                                          );
                                                                      tempCard =
                                                                          total -
                                                                          tempCash;
                                                                      _setText(
                                                                        cardCtrl,
                                                                        tempCard,
                                                                      );
                                                                      isAutoUpdating =
                                                                          false;
                                                                    },
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height: 12,
                                                            ),
                                                            Row(
                                                              children: [
                                                                const SizedBox(
                                                                  width: 160,
                                                                  child: Text(
                                                                    'Card',
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: TextField(
                                                                    controller:
                                                                        cardCtrl,
                                                                    keyboardType:
                                                                        const TextInputType.numberWithOptions(
                                                                          decimal:
                                                                              true,
                                                                        ),
                                                                    inputFormatters: [
                                                                      FilteringTextInputFormatter.allow(
                                                                        RegExp(
                                                                          r'^\d*\.?\d{0,2}$',
                                                                        ),
                                                                      ),
                                                                      _maxTotalFormatter(
                                                                        total,
                                                                      ),
                                                                    ],
                                                                    decoration: InputDecoration(
                                                                      hintText:
                                                                          'Amount',
                                                                      border: OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                              8,
                                                                            ),
                                                                      ),
                                                                    ),
                                                                    onChanged: (v) {
                                                                      if (isAutoUpdating)
                                                                        return;
                                                                      isAutoUpdating =
                                                                          true;
                                                                      tempCard =
                                                                          _parse(
                                                                            v,
                                                                          );
                                                                      tempCash =
                                                                          total -
                                                                          tempCard;
                                                                      _setText(
                                                                        cashCtrl,
                                                                        tempCash,
                                                                      );
                                                                      isAutoUpdating =
                                                                          false;
                                                                    },
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height: 20,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  child: OutlinedButton(
                                                                    onPressed: () {
                                                                      closedByButton =
                                                                          true;
                                                                      onCancel();
                                                                      Navigator.pop(
                                                                        context,
                                                                      );
                                                                    },
                                                                    child: const Text(
                                                                      'Cancel',
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 12,
                                                                ),
                                                                Expanded(
                                                                  child: ElevatedButton(
                                                                    style: ElevatedButton.styleFrom(
                                                                      backgroundColor:
                                                                          const Color(
                                                                            0xFFEAB307,
                                                                          ),
                                                                      foregroundColor:
                                                                          Colors
                                                                              .black,
                                                                    ),
                                                                    onPressed: () {
                                                                      if ((tempCash +
                                                                                  tempCard -
                                                                                  total)
                                                                              .abs() >
                                                                          0.01) {
                                                                        ScaffoldMessenger.of(
                                                                          context,
                                                                        ).showSnackBar(
                                                                          const SnackBar(
                                                                            content: Text(
                                                                              'Cash + Card must equal Total',
                                                                            ),
                                                                          ),
                                                                        );
                                                                        return;
                                                                      }
                                                                      closedByButton =
                                                                          true;
                                                                      multiCashAmount
                                                                              .value =
                                                                          tempCash;
                                                                      multiCardAmount
                                                                              .value =
                                                                          tempCard;
                                                                      onOk();
                                                                      Navigator.pop(
                                                                        context,
                                                                      );
                                                                    },
                                                                    child:
                                                                        const Text(
                                                                          'OK',
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
                                                ).whenComplete(() {
                                                  if (!closedByButton)
                                                    onCancel();
                                                });
                                              },
                                              child: ValueListenableBuilder(
                                                valueListenable:
                                                    multiCashAmount,
                                                builder: (context, cash, _) {
                                                  return ValueListenableBuilder(
                                                    valueListenable:
                                                        multiCardAmount,
                                                    builder: (context, card, __) {
                                                      return PaymentOption(
                                                        title: 'Multi',
                                                        subtitle:
                                                            cash == 0 &&
                                                                card == 0
                                                            ? ''
                                                            : 'Cash ${cash.toStringAsFixed(0)} | Card ${card.toStringAsFixed(0)}',
                                                        selected:
                                                            payment == 'Multi',
                                                        iconPath:
                                                            'assets/icons/multiicon.svg',
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
                                  const SizedBox(height: 10),
                                  Visibility(
                                    visible: _collectCustomerSaveOnSale,
                                    child: Card(
                                      elevation: 3,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Customer Name',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            TextField(
                                              controller: customerNameController,
                                              decoration: InputDecoration(
                                                hintText: 'Enter customer name',
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                              ),
                                            ),

                                            const SizedBox(height: 16),

                                            const Text(
                                              'Phone Number',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            TextField(
                                              controller: customerPhoneController,
                                              keyboardType: TextInputType.phone,
                                              decoration: InputDecoration(
                                                hintText: 'Enter phone number',
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  /// Confirm Sale button
                                  SizedBox(
                                    width: double.infinity,
                                    height: 48,
                                    child: state is SaleLoading
                                        ? const Center(
                                            child: CircularProgressIndicator(),
                                          )
                                        : ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(
                                                0xFFEAB307,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              elevation: 0,
                                            ),
                                            onPressed: _isButtonDisabled
                                                ? null
                                                : () async {
                                                    setState(
                                                      () => _isButtonDisabled =
                                                          true,
                                                    );
                                                    final payment =
                                                        selectedPayment.value;
                                                    double cashAmt = 0;
                                                    double cardAmt = 0;
                                                    if (payment == 'Cash') {
                                                      cashAmt = total;
                                                      cardAmt = 0;
                                                    } else if (payment ==
                                                        'Card') {
                                                      cashAmt = 0;
                                                      cardAmt = total;
                                                    } else if (payment ==
                                                        'Multi') {
                                                      cashAmt =
                                                          multiCashAmount.value;
                                                      cardAmt =
                                                          multiCardAmount.value;
                                                      if ((cashAmt +
                                                                  cardAmt -
                                                                  total)
                                                              .abs() >
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
                                                    }
                                                    //print('_selectedCustomer!.loyalityId ${_selectedCustomer!.loyalityId}');
                                                    String st_pointsRedeemed =
                                                        '';
                                                    if (redeemAmount > 0) {
                                                      st_pointsRedeemed =
                                                          _selectedCustomer!
                                                              .totalPointsEarned;
                                                    }

                                                    final customer =
                                                        _selectedCustomer;
                                                    int st_LoyaltyId = 0;
                                                    int loyaltyCustId = 0;
                                                    if (customer != null) {
                                                      st_LoyaltyId =
                                                          customer.loyalityId;
                                                      loyaltyCustId =
                                                          customer.custId;
                                                    }
                                                    final ledgerData =
                                                        await SharedPreferenceHelper()
                                                            .getLedgers();
                                                    final int cashLedgerId =
                                                        ledgerData['cashLedgerId'] ??
                                                        0;
                                                    final int cardLedgerId =
                                                        ledgerData['cardLedgerId'] ??
                                                        0;
                                                    final items = CartManager()
                                                        .cartItems
                                                        .value;
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
                                                      ledgerId: 0,
                                                      subTotal: subTotal,
                                                      discountAmount: discount,
                                                      vatAmount: tax,
                                                      grandTotal: total,
                                                      cashLedgerId:
                                                          cashLedgerId,
                                                      cashAmount: cashAmt,
                                                      cardLedgerId:
                                                          cardLedgerId,
                                                      cardAmount: cardAmt,
                                                      creditAmount: 0,
                                                      tableId: 1,
                                                      supplierId: 1,
                                                      cashierId: 1,
                                                      orderMasterId: 10,
                                                      billStatus: 'Completed',
                                                      salesType: AppData.saleType!,
                                                      billTokenNo: 22,
                                                      createdUser: 1,
                                                      branchId: 1,
                                                      totalTax: tax,
                                                      salesDetails: items
                                                          .map(
                                                            (e) => SaleDetail(
                                                              productCode:
                                                                  e.productCode,
                                                              productName:
                                                                  e.productName,
                                                              qty:
                                                                  (e.qty as num)
                                                                      .toInt(),
                                                              unitId:
                                                                  double.parse(
                                                                    e.unitId,
                                                                  ).toInt(),
                                                              purchaseCost:
                                                                  double.parse(
                                                                    e.purchaseCost,
                                                                  ),
                                                              salesRate:
                                                                  e.salesRate,
                                                              excludeRate:
                                                                  e.salesRate,
                                                              subtotal:
                                                                  e.totalPrice,
                                                              vatId: 1,
                                                              vatAmount:
                                                                  tax /
                                                                  items.length,
                                                              totalAmount:
                                                                  e.totalPrice +
                                                                  (tax /
                                                                      items
                                                                          .length),
                                                              conversionRate: 1,
                                                            ),
                                                          )
                                                          .toList(),

                                                      loyalCardId: st_LoyaltyId,
                                                      customerId: loyaltyCustId,
                                                      pointRedeemed:
                                                          st_pointsRedeemed,
                                                      pointEarned:
                                                          st_points_earned,
                                                      redeemedAmount:
                                                          redeemAmount,
                                                      customerName: customerNameController.text.toString(),
                                                      customerPhoneNo: customerPhoneController.text.toString(),
                                                    );
                                                    if (expiredStatusController
                                                            .text ==
                                                        'true') {
                                                      context
                                                          .read<SaleCubit>()
                                                          .saveSale(request);
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
                            ),
                            // ── END BOTTOM BAR ──
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ),
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
                onPressed: () async {
                  // Exit the app
                  if (Platform.isAndroid) {
                    //SystemNavigator.pop();
                    // await clearAppData();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => LoginScreen()),
                      (route) => false,
                    );
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

  Widget _buildLoyaltyCard(LoyaltyCustomer customer) {
    return Column(
      children: [
        /// ATM Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F3460)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -30,
                right: -30,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.04),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Top row — chip + title + logo
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          /// Chip
                          Container(
                            width: 34,
                            height: 26,
                            decoration: BoxDecoration(
                              color: const Color(0xFFD4A843),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: GridView.count(
                              crossAxisCount: 2,
                              padding: const EdgeInsets.all(4),
                              mainAxisSpacing: 2,
                              crossAxisSpacing: 2,
                              physics: const NeverScrollableScrollPhysics(),
                              children: List.generate(
                                4,
                                (_) => Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.18),
                                    borderRadius: BorderRadius.circular(1),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "LOYALTY CARD",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white.withOpacity(0.45),
                                  letterSpacing: 1,
                                ),
                              ),
                              const Text(
                                "QuikServ Rewards",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      /// Logo circles
                      SizedBox(
                        width: 38,
                        height: 24,
                        child: Stack(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFFE8B84B).withOpacity(0.9),
                              ),
                            ),
                            Positioned(
                              left: 14,
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(
                                    0xFFE8B84B,
                                  ).withOpacity(0.5),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  /// Bottom row — name/contact + points
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            customer.customerName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            customer.phoneNo,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                          Text(
                            customer.email,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white.withOpacity(0.38),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "POINTS",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white.withOpacity(0.45),
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            customer.totalPointsEarned,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFE8B84B),
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        /// Redeem Checkbox
        Visibility(
          visible: true,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Checkbox(
                  value: _redeemPoints,
                  activeColor: const Color(0xFF0F3460),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  onChanged: (val) {
                    double _salesTotal = double.parse(
                      totalSalesController.text.toString(),
                    );
                    print('_salesTotal $_salesTotal');
                    print(
                      '_selectedCustomer!.totalEarnedAmount ${_selectedCustomer!.totalEarnedAmount.toString()}',
                    );
                    print('pointLimit ${_selectedCustomer!.minRedeemPoint}');
                    print('PointValue ${_selectedCustomer!.pointValue}');
                    double dbl_pointLimit = double.parse(
                      _selectedCustomer!.minRedeemPoint.toString(),
                    );
                    double dbl_pointEarned = double.parse(
                      _selectedCustomer!.totalPointsEarned.toString(),
                    );
                    double totalSalesAmount = double.parse(
                      totalSalesController.text.toString(),
                    );
                    double totalEarnedAmount = double.parse(
                      _selectedCustomer!.totalEarnedAmount.toString(),
                    );
                    double pointValue = double.parse(
                      _selectedCustomer!.pointValue.toString(),
                    ); //return Discount
                    dbl_pointEarned = dbl_pointEarned * pointValue;
                    st_RedeemAmount = dbl_pointEarned.toStringAsFixed(
                      get_decimalpoints(),
                    );

                    if (dbl_pointEarned >= dbl_pointLimit) {
                      if (totalSalesAmount >= totalEarnedAmount) {
                        _redeemPoints = true;
                      } else {
                        Fluttertoast.showToast(
                          msg: "Point Limit not reached !!!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          // TOP, CENTER, BOTTOM
                          backgroundColor: Colors.black87,
                          textColor: Colors.white,
                        );
                      }
                      if (_salesTotal >=
                          double.parse(
                            _selectedCustomer!.totalEarnedAmount.toString(),
                          )) {
                        setState(() => _redeemPoints = val ?? false);
                      }
                    } else {
                      Fluttertoast.showToast(
                        msg: "Point Limit not reached !",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        // TOP, CENTER, BOTTOM
                        backgroundColor: Colors.black87,
                        textColor: Colors.white,
                      );
                    }
                  },
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Redeem points",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "${customer.totalPointsEarned} pts → ₹${st_RedeemAmount} off",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: _redeemPoints
                        ? Colors.green.shade50
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _redeemPoints ? "Applied" : "Off",
                    style: TextStyle(
                      fontSize: 11,
                      color: _redeemPoints
                          ? Colors.green.shade700
                          : Colors.grey.shade500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Future<void> clearAppData() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear(); // 🔥 clears everything
}
