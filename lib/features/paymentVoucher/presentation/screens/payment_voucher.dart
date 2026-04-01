import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:quikservnew/core/config/colors.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/features/paymentVoucher/presentation/bloc/payment_cubit.dart';
import 'package:quikservnew/features/paymentVoucher/presentation/helper/payment_helper.dart';
import 'package:quikservnew/features/paymentVoucher/presentation/widgets/paymentvoucher_widgets.dart';
import 'package:quikservnew/features/settings/presentation/widgets/accountsettings_widget.dart';

class PaymentScreen extends StatefulWidget {
  final String pagefrom;
  const PaymentScreen({super.key, required this.pagefrom});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  DateTime? selectedDate;
  String _selectedLedger = '';
  String _selectedledgerId = '';
  String stCurrentDate = '';
  late String pagefromValue;
  final FocusNode _amountFocusNode = FocusNode();
  String executiveId = '',
      stBranchId = ' ',
      executivename = '',
      stCompanyId = '',
      stRouteId = '',
      stDayregId = '',
      receiptNoPrefix = '',
      receiptNoSereies = '',
      stReceiptNo = '',
      stBankLedgerId = '',
      stCashLedgerId = '',
      stCurrencyConversionId = '',
      stUserId = '',
      stLedgerId = '';

  final _customerController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  final _paymentModeController = TextEditingController();

  final _dateController = TextEditingController();
  final List<String> _options = ['Cash', 'Bank'];
  String? _selectedOption = 'Cash';
  String _formatDate(DateTime date) {
    return DateFormat('dd/MMM/yyyy').format(date);
  }

  @override
  void initState() {
    pagefromValue = widget.pagefrom;
    _customerController.text = 'Expense Head';
    _dateController.text = PaymentScreenHelper().formatDate(
      PaymentScreenHelper().getDateTime(),
    );
    _paymentModeController.text = 'Cash';
    stLedgerId = stCashLedgerId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentCubit, PaymentState>(
      listener: (context, state) {
        if (state is SavePaymentFailure) {
          Fluttertoast.showToast(
            msg: state.message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        } else if (state is SavePaymentSuccess) {
          Fluttertoast.showToast(
            msg: "Payment saved successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0,
          );

          _amountController.clear();
          _notesController.clear();
        }
      },
      builder: (context, state) {
        final bool isSaving = false;
        return PopScope(
          canPop: !isSaving,
          onPopInvoked: (didPop) {},
          child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 40,
              backgroundColor: AppColors.theme,
              title: const Text(
                'Payment',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            body: SingleChildScrollView(
              child: Container(
                color: appThemegrayColors,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 6.0,
                        left: 4.0,
                        right: 4.0,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(1)),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 8.0,
                                  right: 8.0,
                                  bottom: 8.0,
                                  top: 8.0,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        width: 100,
                                        child: Text(
                                          'Payment Date',
                                          style: TextStyle(fontSize: 11),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        style: TextStyle(fontSize: 14),
                                        _dateController.text.toString(),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: InkWell(
                                        onTap: () {
                                          PaymentScreenHelper().selectDate(
                                            context: context,
                                            initialDate: selectedDate,
                                            onDateSelected: (picked) {
                                              setState(() {
                                                selectedDate = picked;
                                                _dateController.text =
                                                    _formatDate(picked);
                                              });
                                            },
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            right: 8.0,
                                          ),
                                          child: Text(
                                            'Edit',
                                            style: TextStyle(fontSize: 11),
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 8.0,
                                  right: 8.0,
                                ),
                                child: Divider(thickness: 1),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 8.0,
                                  right: 8.0,
                                  bottom: 24.0,
                                  top: 8.0,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: SizedBox(
                                        width: 100,
                                        child: Text(
                                          'Payment Mode',
                                          style: TextStyle(fontSize: 11),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: TextFormField(
                                        controller: _paymentModeController,
                                        enabled: false,
                                        style: TextStyle(color: Colors.black),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: InkWell(
                                        onTap: () async {
                                          PaymentModeBottomSheet.show(
                                            context: context,
                                            options: _options,
                                            selectedOption: _selectedOption,
                                            paymentModeController:
                                                _paymentModeController,
                                            onSelected: (value) {
                                              setState(() {
                                                _selectedOption = value;
                                              });
                                            },
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            right: 8.0,
                                          ),
                                          child: Text(
                                            'Edit',
                                            style: TextStyle(fontSize: 11),
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 4.0,
                            right: 4.0,
                            top: 2.0,
                            bottom: 2.0,
                          ),
                          child: SizedBox(
                            height: 80,
                            width: double.infinity,
                            child: Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(1),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _selectedLedger.isNotEmpty
                                          ? _selectedLedger
                                          : _customerController.text,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: InkWell(
                                            onTap: () async {
                                              final selectedLedger =
                                                  await showBankLedgerBottomSheet(
                                                    context,
                                                  );

                                              if (selectedLedger != null) {
                                                setState(() {
                                                  _selectedLedger =
                                                      selectedLedger
                                                          .bankAccName ??
                                                      selectedLedger
                                                          .ledgerName ??
                                                      '';

                                                  _selectedledgerId =
                                                      selectedLedger.ledgerId
                                                          ?.toString() ??
                                                      '';
                                                });
                                              }
                                            },
                                            child: Icon(
                                              Icons.add,
                                              color: appThemeColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    AmountColumn(
                      amountController: _amountController,
                      amountFocusNode: _amountFocusNode,
                    ),
                    NotesColumn(notesController: _notesController),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEAB307),
                            foregroundColor: Colors.white,
                            shadowColor: Colors.black,
                            elevation: 0,
                            padding: EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () => PaymentScreenHelper().onSavePressed(
                            context: context,
                            isSaving: isSaving,
                            dateController: _dateController,
                            paymentModeController: _paymentModeController,
                            amountController: _amountController,
                            selectedOption: _selectedOption ?? '',
                            selectedledgerId: _selectedledgerId,
                            stCashLedgerId: stCashLedgerId,
                            stBankLedgerId: stBankLedgerId,
                          ),
                          // _onSavePressed(context, isSaving: isSaving),
                          child: Text(
                            'Save',
                            style: TextStyle(fontFamily: 'ArealRoundedFont'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
