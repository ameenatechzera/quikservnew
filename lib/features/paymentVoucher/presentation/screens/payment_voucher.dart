import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:quikservnew/core/config/colors.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentScreen extends StatefulWidget {
  final String pagefrom;
  //final Customer? customer;
  PaymentScreen({super.key, required this.pagefrom });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  DateTime? selectedDate;
  String _selectedLedger = '';
  String _selectedledgerId = '';
  String st_currentDate = '';
  late String pagefromValue;
  //List<Customer> customers = [];
  FocusNode _amountFocusNode = FocusNode();
  String executiveId = '',
      st_branchId = ' ',
      executivename = '',
      st_companyId = '',
      st_routeId = '',
      st_dayregId = '',
      receiptNoPrefix = '',
      receiptNoSereies = '',
      st_receiptNo = '',
      st_bankLedgerId = '',
      st_CashLedgerId = '',
      st_currencyConversionId ='',
      st_userId = '',
      st_LedgerId = '';

  final _customerController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  final _paymentModeController = TextEditingController();
  final _receiptNoController = TextEditingController();
  final _dateController = TextEditingController();

  // List of options
  final List<String> _options = ['Cash', 'Bank'];

 // final List<Bank> _bankList = [];

  // Variable to keep track of the selected option
  String? _selectedOption = 'Cash';

  String _formatDate(DateTime date) {
    return DateFormat('dd/MMM/yyyy').format(date);
  }

  @override
  void initState() {
    // TODO: implement initState
    pagefromValue = widget.pagefrom;
    _customerController.text = 'Expense Head';


    // context.read<ReceiptCubit>().fetchBankLedgers();

    _dateController.text = formatDate(getDateTime());
    _paymentModeController.text = 'Cash';
    st_LedgerId = st_CashLedgerId;
    //getReceiptNoAndSeries();
    super.initState();
  }
  String getDateTime() {
    String formattedDate = "";
    try {
      var now = new DateTime.now();
      var formatter = new DateFormat('yyyy-MM-dd HH:mm:ss');
      formattedDate = formatter.format(now);
    } catch (e) {
      e.toString();
    }
    return formattedDate;
  }
  String formatDate(String dateStr) {
    DateTime dateTime =
    DateTime.parse(dateStr); // Parse the string into a DateTime object
    String formattedDate =
    DateFormat('dd-MMM-yyyy').format(dateTime); // Format the DateTime object
    return formattedDate;
  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _dateController.text = _formatDate(selectedDate!).toString();
      });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true, //When false, blocks the current route from being popped.
      onPopInvoked: (didPop) {
        //do your logic here:
        print('pagefrom' + pagefromValue);

      },
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
                  padding:
                  const EdgeInsets.only(top: 6.0, left: 4.0, right: 4.0),
                  child: Container(
                    width: double.infinity,
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(1),
                        ),
                      ),
                      child: Column(
                        children: [

                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, bottom: 8.0, top: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                      width: 100,
                                      child: Text(
                                        'Receipt Date',
                                        style: TextStyle(fontSize: 11),
                                      )),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    style: TextStyle(fontSize: 14),
                                    _dateController.text.toString(),
                                    // selectedDate == null
                                    //     ? st_currentDate
                                    //     : '${_formatDate(selectedDate!)}',
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: InkWell(
                                    onTap: () {
                                      _selectDate(context);
                                    },
                                    child: Padding(
                                      padding:
                                      const EdgeInsets.only(right: 8.0),
                                      child: Text(
                                        'Edit',
                                        style: TextStyle(fontSize: 11),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Divider(
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, bottom: 24.0, top: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                      width: 100,
                                      child: Text(
                                        'Receipt Mode',
                                        style: TextStyle(fontSize: 11),
                                      )),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: TextFormField(
                                    controller: _paymentModeController,
                                    enabled: false,
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                    decoration: InputDecoration(
                                        border: InputBorder.none),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: InkWell(
                                    onTap: () async {
                                      // final selectedItem =
                                      //     await showPaymentCheckBox(context, [
                                      //   'Route A',
                                      //   'Route B',
                                      //   'Route C',
                                      //   'Route D'
                                      // ]);
                                      // final selectedItem =
                                      // await PaymentcashBottomSheet();
                                      _showBottomSheet(context);
                                      // print(selectedItem);
                                    },
                                    child: Padding(
                                      padding:
                                      const EdgeInsets.only(right: 8.0),
                                      child: Text(
                                        'Edit',
                                        style: TextStyle(fontSize: 11),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ),
                                )
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
                              left: 4.0, right: 4.0, top: 2.0, bottom: 2.0),
                          child: Container(
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
                                      _customerController.text.toString(),
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
                                              // context
                                              //     .read<AppbarBlolcBloc>()
                                              //     .add(
                                              //     GetSelectCustomerEvent());
                                              // Customer? cust =
                                              // await showListforSelection(
                                              //     context,
                                              //     customers,
                                              //     'Receipt',st_routeId,'');
                                              // _selectedLedger =
                                              //     cust!.ledgerName.toString();
                                              // _selectedledgerId = cust.ledgerId;
                                              // setState(() {
                                              //   _customerController.text =
                                              //       _selectedLedger.toString();
                                              // });

                                              print('reached $_selectedLedger');
                                            },
                                            child: Icon(
                                              Icons.add,
                                              color: appThemeColor,
                                            ),
                                          ),
                                        ),
                                        // Padding(
                                        //   padding: const EdgeInsets.all(8.0),
                                        //   child: InkWell(
                                        //     onTap: () async {},
                                        //     child: Icon(
                                        //       Icons.search,
                                        //       color: appThemeColor,
                                        //     ),
                                        //   ),
                                        //)
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

                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 4.0, right: 4.0, top: 2.0, bottom: 2.0),
                      child: Container(
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 50,
                                    width: 200,
                                    child: TextFormField(
                                      controller: _amountController,
                                      focusNode: _amountFocusNode,
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(fontSize: 14),
                                      decoration: const InputDecoration(
                                        // Removes the bottom line
                                          labelText: 'Amount',
                                          labelStyle: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 4.0, right: 4.0, top: 2.0, bottom: 2.0),
                      child: Container(
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 80,
                                    child: TextFormField(
                                      controller: _notesController,
                                      keyboardType: TextInputType.text,
                                      style: TextStyle(fontSize: 18),
                                      decoration: const InputDecoration(
                                        // Removes the bottom line
                                        labelText: 'Notes(Optional)',
                                        labelStyle: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                        contentPadding:
                                        EdgeInsets.only(bottom: 0),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
               Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEAB307),
                            // Background color
                            foregroundColor: Colors.white,
                            // Text color
                            shadowColor: Colors.black,

                            // Shadow color
                            elevation: 0,
                            // Elevation
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                            // Padding
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(10), // Rounded corners
                            ),
                          ),
                          onPressed: () {
                            bool save_status = validation_for_save();
                            if (save_status) {
                              // Payments paymnt = Payments(
                              //     receiptNo: _receiptNoController.text.toString(),
                              //     receiptNoSeries: st_receiptNo,
                              //     paymentDate: _formatDate(selectedDate!),
                              //     paymentMode: _paymentModeController.text.toString(),
                              //     ledgerName: _customerController.text.toString(),
                              //     amt: _amountController.text.toString(),
                              //     remarks: _notesController.text.toString(),
                              //     ledgerId: _selectedledgerId);
                              // context.read<PaymentCubit>().savePayments(paymnt);

                              if (_selectedOption == 'Cash') {
                                st_LedgerId = st_CashLedgerId;
                              }
                              if (_selectedOption == 'Bank') {
                                st_LedgerId = st_bankLedgerId;
                              }
                              if (_amountController.text.isNotEmpty &&
                                  _selectedOption!.isNotEmpty &&
                                  _selectedledgerId.isNotEmpty &&
                                  selectedDate.toString().isNotEmpty) {
                                // context.read<ReceiptCubit>().saveReceiptDetails(
                                //     ReceiptSaveParameter(
                                //         ReceiptDate:
                                //         _dateController.text.toString(),
                                //         BankOrCashledgerId: st_LedgerId,
                                //         CustomerLedgerId: _selectedledgerId,
                                //         Narration:
                                //         _notesController.text.toString(),
                                //         userId: st_userId,
                                //         branchId: st_branchId,
                                //         Total:
                                //         _amountController.text.toString()));
                              } else {
                                Fluttertoast.showToast(
                                  msg: "Enter All Fields",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.grey,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                              }
                            }
                          },
                          child: const Text(
                            'Save',
                            style: TextStyle(
                              fontFamily: 'ArealRoundedFont',
                            ),
                          ),
                        ),
                      ),
                    )

              ],
            ),
          ),
        ),
      ),
    );
  }

  // Future<void> getReceiptNoAndSeries() async {
  //   final prefs = await SharedPreferences.getInstance();
  //
  //   st_branchId = prefs.getString('branchId') ?? '';
  //   executiveId = prefs.getString('executiveId') ?? '';
  //   executivename = prefs.getString('executiveName') ?? '';
  //   receiptNoPrefix = prefs.getString('receiptPrefix') ?? '';
  //   receiptNoSereies = prefs.getString('lastReceiptBillNo') ?? '';
  //   print('receiptNoSereies $receiptNoSereies');
  //   print('executivename $executivename');
  //   st_receiptNo = await generateNewNumber(receiptNoSereies);
  //   _receiptNoController.text = receiptNoPrefix + st_receiptNo;
  //   await SharedPrefrence().getSelectedRoute().then((value) async {
  //     print('st_routeId $st_routeId');
  //     st_routeId = value.toString();
  //   });
  //   await SharedPrefrence().getExeBankAccountLedgerId().then((value) async {
  //     print('st_bankLedgerId $value');
  //     st_bankLedgerId = value.toString();
  //   });
  //   await SharedPrefrence().getExeCashAccountLedgerId().then((value) async {
  //     print('st_CashLedgerId $value');
  //     st_CashLedgerId = value.toString();
  //   });
  //   await SharedPrefrence().getCurrencyConversionId().then((value) async {
  //     st_currencyConversionId = value.toString();
  //   });
  //   SharedPrefrence().getUserId().then((value) async {
  //     print('st_userIdInit $value');
  //     st_userId = value.toString();
  //   });
  //   await SharedPrefrence().getSelectedRoute().then((value) async {
  //     print('st_routeId $value');
  //     st_routeId = value.toString();
  //   });
  //   if(pagefromValue=='CustomerView'){
  //     _selectedLedger =
  //         widget.customer!.ledgerName.toString();
  //     _selectedledgerId =  widget.customer!.ledgerId;
  //     _amountFocusNode.requestFocus();
  //     setState(() {
  //       _customerController.text =
  //           _selectedLedger.toString();
  //     });
  //   }
  //   else{
  //     if (st_routeId == '0') {
  //       print('ifCase $st_routeId');
  //       context.read<PartiesCubit>().fetchPartiesLocal();
  //     } else {
  //       context.read<PartiesCubit>().fetchPartiesLocalByRoute(st_routeId);
  //     }
  //
  //   }
  //
  //
  //
  // }



  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: _options.map((option) {
                  final isSelected = _selectedOption == option;
                  return AbsorbPointer(
                    absorbing: isSelected,
                    child: CheckboxListTile(
                      title: Text(option),
                      value: isSelected,
                      onChanged: (bool? selected) {
                        if (selected == true) {
                          setState(() {
                            _selectedOption = option;
                            print(_selectedOption);
                            _paymentModeController.text =
                                _selectedOption.toString();
                          });
                          Navigator.pop(context); // Close the bottom sheet
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            );
          },
        );
      },
    );
  }

  bool validation_for_save() {
    bool valid_status = true;
    print('haris');

    String? st_date_selected = _dateController.text.toString();
    print('st_date_selected $st_date_selected');

    if (_receiptNoController.text.toString().isEmpty) {
      valid_status = false;
      Fluttertoast.showToast(
        msg: "Receipt No Not Generated",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else if (st_date_selected.toString().isEmpty) {
      valid_status = false;
      Fluttertoast.showToast(
        msg: "Pls Select Date..!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else if (_paymentModeController.text.toString().isEmpty) {
      valid_status = false;
      Fluttertoast.showToast(
        msg: "Pls Select Mode of Payment..!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else if (_amountController.text.toString().isEmpty) {
      valid_status = false;
      Fluttertoast.showToast(
        msg: "Pls Add Amount..!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      valid_status = true;
    }

    return valid_status;
  }
}