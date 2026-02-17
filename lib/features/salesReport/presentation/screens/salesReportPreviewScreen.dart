import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:quikservnew/core/config/colors.dart';
import 'package:quikservnew/core/utils/widgets/common_appbar.dart';
import 'package:quikservnew/features/salesReport/domain/entities/salesDetailsByMasterIdResult.dart';
import 'package:quikservnew/features/salesReport/domain/parameters/salesDetails_request_parameter.dart';
import 'package:quikservnew/features/salesReport/presentation/bloc/sles_report_cubit.dart';
import 'package:quikservnew/features/salesReport/presentation/widgets/print_thermal.dart';
import 'package:quikservnew/services/shared_preference_helper.dart';

class salesReportPreviewScreen extends StatefulWidget {
  // final String st_fromDate;
  //
  // final String st_toDate;

  final String pagefrom;

  final String masterId;

  const salesReportPreviewScreen({
    super.key,
    // required this.st_fromDate,
    // required this.st_toDate,
    required this.pagefrom,
    required this.masterId,
  });

  @override
  State<salesReportPreviewScreen> createState() =>
      _salesReportPreviewScreenState();
}

List<SalesDetailsByMasterIdResult> saleList = [];
String st_GrandTotal = '',
    st_SubTotal = '',
    st_DbName = '',
    st_TaxableAmt = '',
    st_TotalTax = '',
    st_netInvAmt = '',
    st_totalDisc = '',
    st_sgst = '',
    st_cgst = '',
    st_totalDiscExcluded = '';
String currency = '',
    st_branchIdPref = '',
    st_userIdPref = '',
    st_discTaxIncludeStatus = '',
    st_pdfTypeSelected = 'type_3',
    st_vatType = '',
    st_vatEnabled = '',
    selectedPrinter = '';
bool selectPrintStatus = false;
bool discTaxIncludedStatus = false;
bool discTaxExcludedStatus = false;
bool vatStatus = false;
bool gstStatus = false;
int decimal = 2;
double totalQty = 0;
bool? selectedPdfWithBgIndex = false;
final _totalRecordsController = TextEditingController();
final _totalSalesController = TextEditingController();
final _totalQtyController = TextEditingController();

String st_custName = '', st_custAddress = '';
String amPmTime = '', st_billDate = '';
int clickPdfFlag = 0;

double saleTotal = 0;

class _salesReportPreviewScreenState extends State<salesReportPreviewScreen> {
  String stMasterID = '';
  String currency = '',
      st_branchIdPref = '',
      st_userIdPref = '',
      st_discTaxIncludeStatus = '',
      st_pdfTypeSelected = 'type_3',
      st_vatType = '',
      st_vatEnabled = '',
      selectedPrinter = '';
  bool selectPrintStatus = true;
  bool discTaxIncludedStatus = false;
  bool discTaxExcludedStatus = false;
  bool vatStatus = false;
  bool gstStatus = false;
  int decimal = 2;
  double totalQty = 0;
  bool? selectedPdfWithBgIndex = false;

  @override
  void initState() {
    stMasterID = widget.masterId;
    fetchDetails(stMasterID);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateFormatter = DateFormat('dd-MM-yyyy');
    final timeFormatter = DateFormat('hh:mm a');

    return Scaffold(
      appBar: const CommonAppBar(title: "Bill Preview"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// TOP CARD
            topBillInfoCard(
              billDate: dateFormatter.format(now),
              billTime: timeFormatter.format(now),
            ),

            /// ITEMS CARD
            itemsCard(),

            /// TOTAL CARD
            totalCard(),
            Padding(
              padding: const EdgeInsets.only(
                left: 2.0,
                right: 2.0,
                top: 0.0,
                bottom: 6.0,
              ),
              child: Card(
                child: Container(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Visibility(
                        visible: false,
                        child: Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 2.0,
                              right: 2.0,
                              bottom: 2.0,
                              top: 12.0,
                            ),
                            child: Container(
                              width: 150,
                              height: 40,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                        appBarColor,
                                      ),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                        appBarColor,
                                      ),
                                  shape:
                                      MaterialStateProperty.all<
                                        RoundedRectangleBorder
                                      >(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            18.0,
                                          ),
                                          side: BorderSide(color: appBarColor),
                                        ),
                                      ),
                                ),
                                onPressed: () async {
                                  print('pressed');
                                  if (clickPdfFlag == 0) {
                                    Fluttertoast.showToast(
                                      msg: "Generate new pdf before share!",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: Colors.grey,
                                      textColor: Colors.white,
                                      fontSize: 16.0,
                                    );
                                  } else {
                                    //await sharePdf();
                                  }
                                },
                                child: const Text(
                                  'Share',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: selectPrintStatus,
                        child: Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 2.0,
                              right: 2.0,
                              bottom: 2.0,
                              top: 12.0,
                            ),
                            child: Container(
                              width: double.infinity,
                              height: 40,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                        appBarColor,
                                      ),
                                  backgroundColor: MaterialStateProperty.all(
                                    appBarColor,
                                  ),
                                  shape:
                                      MaterialStateProperty.all<
                                        RoundedRectangleBorder
                                      >(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            18.0,
                                          ),
                                          side: BorderSide(color: appBarColor),
                                        ),
                                      ),
                                ),
                                onPressed: () {
                                  print('pressed');

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PrintPage(
                                        pageFrom: 'SalesReport',
                                        sales: saleList.first,
                                      ),
                                    ),
                                  );

                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder:
                                  //             (
                                  //             context) =>
                                  //             ThermalPrinterScreen(
                                  //               sales:
                                  //               saleList
                                  //                   .first,
                                  //               pageFrom:
                                  //               'SalesReport',
                                  //             )));
                                },
                                child: const Text(
                                  'Print',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Visibility(
                      //   visible: true,
                      //   child: Expanded(
                      //     flex: 1,
                      //     child: Padding(
                      //       padding: const EdgeInsets.only(
                      //         left: 2.0,
                      //         right: 2.0,
                      //         bottom: 2.0,
                      //       ),
                      //       child: Container(
                      //         width: 150,
                      //         height: 90,
                      //         child: Column(
                      //           children: [
                      //             Visibility(
                      //               visible: false,
                      //               child: Padding(
                      //                 padding: const EdgeInsets.only(left: 8.0),
                      //                 child: Row(
                      //                   mainAxisAlignment:
                      //                       MainAxisAlignment.center,
                      //                   children: [
                      //                     Expanded(
                      //                       flex: 1,
                      //                       child: Checkbox(
                      //                         visualDensity:
                      //                             VisualDensity.compact,
                      //                         // Reduces the size
                      //                         materialTapTargetSize:
                      //                             MaterialTapTargetSize
                      //                                 .shrinkWrap,
                      //                         // Shrinks tap area
                      //                         value: selectedPdfWithBgIndex,
                      //                         // Check if the current item is selected
                      //                         onChanged: (bool? newValue) {
                      //                           setState(() {
                      //                             // If the current checkbox is clicked, update the selectedIndex
                      //                             selectedPdfWithBgIndex =
                      //                                 newValue;
                      //                           });
                      //                         },
                      //                       ),
                      //                     ),
                      //                     const Visibility(
                      //                       visible: true,
                      //                       child: Expanded(
                      //                         flex: 6,
                      //                         child: Padding(
                      //                           padding: EdgeInsets.only(
                      //                             left: 2.0,
                      //                           ),
                      //                           child: Text(
                      //                             ' with header',
                      //                             style: TextStyle(
                      //                               fontWeight: FontWeight.bold,
                      //                               fontSize: 11,
                      //                             ),
                      //                           ),
                      //                         ),
                      //                       ),
                      //                     ),
                      //                   ],
                      //                 ),
                      //               ),
                      //             ),
                      //             Visibility(
                      //               visible: false,
                      //               child: Container(
                      //                 width: 150,
                      //                 height: 40,
                      //                 child: ElevatedButton(
                      //                   style: ButtonStyle(
                      //                     foregroundColor:
                      //                         MaterialStateProperty.all<Color>(
                      //                           appBarColor,
                      //                         ),
                      //                     backgroundColor:
                      //                         MaterialStateProperty.all<Color>(
                      //                           appBarColor,
                      //                         ),
                      //                     shape:
                      //                         MaterialStateProperty.all<
                      //                           RoundedRectangleBorder
                      //                         >(
                      //                           RoundedRectangleBorder(
                      //                             borderRadius:
                      //                                 BorderRadius.circular(
                      //                                   18.0,
                      //                                 ),
                      //                             side: BorderSide(
                      //                               color: appBarColor,
                      //                             ),
                      //                           ),
                      //                         ),
                      //                   ),
                      //                   onPressed: () {
                      //                     clickPdfFlag = 1;
                      //                     // if (selectedPdfWithBgIndex == true) {
                      //                     //   SharedPrefrence().setPdfPrintWithBgStatus('true');
                      //                     // } else {
                      //                     //   SharedPrefrence()
                      //                     //       .setPdfPrintWithBgStatus('false');
                      //                     // }
                      //                     //st_pdfTypeSelected ='type_1';
                      //                     // createPdfNew(saleList.first,st_pdfTypeSelected);
                      //                   },
                      //                   child: const Text(
                      //                     'PDF',
                      //                     style: TextStyle(color: Colors.white),
                      //                   ),
                      //                 ),
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
            Visibility(
              visible: false,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 8.0,
                  right: 8.0,
                  bottom: 8.0,
                ),
                child: Container(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(
                        appBarColor,
                      ),
                      backgroundColor: MaterialStateProperty.all(appBarColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: appBarColor),
                        ),
                      ),
                    ),
                    onPressed: () {
                      // context
                      //     .read<AppbarCubit>()
                      //     .salePageSelected();

                      // Navigator.pushReplacement(
                      //   context,
                      //   PageRouteBuilder(
                      //     pageBuilder: (context,
                      //         animation,
                      //         secondaryAnimation) =>
                      //         SaleScreen(),
                      //     transitionsBuilder: (context,
                      //         animation,
                      //         secondaryAnimation,
                      //         child) {
                      //       const begin =
                      //       Offset(1.0, 0.0);
                      //       const end = Offset.zero;
                      //       const curve = Curves.ease;
                      //
                      //       var tween = Tween(
                      //           begin: begin,
                      //           end: end)
                      //           .chain(CurveTween(
                      //           curve: curve));
                      //
                      //       return SlideTransition(
                      //         position: animation
                      //             .drive(tween),
                      //         child: child,
                      //       );
                      //     },
                      //   ),
                      // );
                    },
                    child: const Text(
                      'New Sale',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchDetails(String stMasterID) async {
    if (st_pdfTypeSelected.isEmpty) {
      st_pdfTypeSelected = 'type_3';
    }
    final sharedPrefHelper = SharedPreferenceHelper();
    st_branchIdPref = await sharedPrefHelper.getBranchId();
    // st_vatType ='GST';
    if (st_vatEnabled == 'true') {
      if (st_vatType == 'VAT') {
        vatStatus = true;
        gstStatus = false;
      } else if (st_vatType == 'GST') {
        vatStatus = false;
        gstStatus = true;
      } else {
        vatStatus = false;
        gstStatus = false;
      }
    } else {
      vatStatus = false;
      gstStatus = false;
    }

    context.read<SalesReportCubit>().fetchSalesDetailsByMasterId(
      FetchSalesDetailsRequest(
        branchId: st_branchIdPref,
        SalesMasterId: stMasterID,
      ),
    );
  }
}

/// -------------------- TOP CARD --------------------
Widget topBillInfoCard({required String billDate, required String billTime}) {
  return BlocConsumer<SalesReportCubit, SlesReportState>(
    listener: (context, state) {
      if (state is SlesDetailsInitial) {
        //showLoadingDialog(context);
      }
      if (state is SalesDetailsSuccess) {
        st_custName = state.response.salesMaster!.ledgerName;
        //st_custAddress = state.response.salesMaster!.add;
        print('BillDate ${state.response.salesMaster!.invoiceDate.toString()}');

        st_billDate = _formatDate(
          state.response.salesMaster!.invoiceDate.toString(),
        );
        try {
          String st_Time = state.response.salesMaster!.invoiceTime.toString();
          // Parse the railway time to a DateTime object
          DateTime time = DateFormat('HH:mm').parse(st_Time);
          amPmTime = DateFormat('hh:mm a').format(time);
          print('ChangedTime $amPmTime');
        } catch (_) {}
      }
    },
    builder: (context, state) {
      return Card(
        margin: const EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Bill Date: $st_billDate",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Time: $amPmTime",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                "Customer Name",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(st_custName, style: TextStyle(color: Colors.black)),
            ],
          ),
        ),
      );
    },
  );
}

/// -------------------- ITEMS CARD --------------------
Widget itemsCard() {
  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 8),
    child: Column(
      children: [
        /// HEADER ROW
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: const [
              Expanded(flex: 1, child: Text("Sl", style: headerStyle)),
              Expanded(flex: 3, child: Text("Barcode", style: headerStyle)),
              Expanded(flex: 1, child: Text("Qty", style: headerStyle)),
              Expanded(flex: 2, child: Text("Rate", style: headerStyle)),
              Expanded(
                flex: 2,
                child: Text(
                  "Total",
                  style: headerStyle,
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        /// ITEMS LIST
        BlocConsumer<SalesReportCubit, SlesReportState>(
          listener: (context, state) {
            if (state is SalesDetailsSuccess) {
              saleList.clear();
              saleList.add(state.response);
            }
          },
          builder: (context, state) {
            if (state is SalesDetailsSuccess) {
              return SizedBox(
                height: 200,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.response.salesDetails.length,
                  itemBuilder: (context, index) {
                    // int slno = index + 1;

                    SalesDetail data = state.response.salesDetails[index];
                    String st_qty = '', st_rate = '', st_total = '';
                    try {
                      st_qty = double.parse(
                        data.qty.toString(),
                      ).toStringAsFixed(get_decimalpoints());
                    } catch (_) {}
                    try {
                      st_rate = double.parse(
                        data.salesRate.toString(),
                      ).toStringAsFixed(get_decimalpoints());
                    } catch (_) {}
                    try {
                      double dblQty = double.parse(data.qty.toString());
                      double salesRate = double.parse(data.salesRate);
                      double dblTotal = dblQty * salesRate;
                      st_total = dblTotal.toStringAsFixed(get_decimalpoints());
                    } catch (_) {}
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      child: Row(
                        children: [
                          Expanded(flex: 1, child: Text("${index + 1}")),
                          Expanded(
                            flex: 3,
                            child: Text(
                              data.productName,
                              style: TextStyle(fontSize: 11),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              st_qty + '-' + data.unitName.toString(),
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          Expanded(flex: 2, child: Text(data.salesRate)),
                          Expanded(
                            flex: 2,
                            child: Text(
                              data.subtotal,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ],
    ),
  );
}

/// -------------------- TOTAL CARD --------------------
// Widget totalCard() {
//   return BlocConsumer<SalesReportCubit, SlesReportState>(
//     listener: (context, state) {
//       if (state is SalesDetailsSuccess) {
//         saleList.clear();
//         saleList.add(state.response);

//         // Sale sale = state.salesDetails.table;
//         totalQty = 0;
//         for (int i = 0; i < saleList.first.salesDetails.length; i++) {
//           totalQty =
//               totalQty +
//               double.parse(saleList.first.salesDetails[i].qty.toString());
//           String truncated = totalQty.toStringAsFixed(
//             get_decimalpoints(),
//           ); // Keeps one decimal place
//           print('truncated $truncated');
//           _totalQtyController.text = truncated.toString();
//         }
//         st_GrandTotal = '0';
//         try {
//           double dbltax = double.parse(
//             state.response.salesMaster!.vatAmount.toString(),
//           );
//           double dblsubTotal = double.parse(
//             state.response.salesMaster!.subTotal.toString(),
//           );
//           double dblGrandTotal = dbltax + dblsubTotal;
//           st_GrandTotal = dblGrandTotal.toStringAsFixed(get_decimalpoints());
//         } catch (_) {}
//         try {
//           double dbl_SubTotal = double.parse(
//             state.response.salesMaster!.subTotal.toString(),
//           );
//           st_SubTotal = dbl_SubTotal.toStringAsFixed(get_decimalpoints());
//         } catch (_) {}
//         try {
//           double dbl_TaxableAmt = double.parse(
//             state.response.salesMaster!.subTotal.toString(),
//           );
//           st_TaxableAmt = dbl_TaxableAmt.toStringAsFixed(get_decimalpoints());
//         } catch (_) {}
//         try {
//           double dbl_TotalTax = double.parse(
//             state.response.salesMaster!.vatAmount.toString(),
//           );
//           st_TotalTax = dbl_TotalTax.toStringAsFixed(get_decimalpoints());
//         } catch (_) {}
//         if (st_vatType == 'GST') {
//           double dbl_TotalTax = double.parse(
//             state.response.salesMaster!.vatAmount.toString(),
//           );
//           double dbl_cgst = dbl_TotalTax / 2;
//           st_cgst = dbl_cgst.toStringAsFixed(get_decimalpoints());
//         }
//         try {
//           double dbl_TotalDisc = double.parse(
//             state.response.salesMaster!.discountAmount.toString(),
//           );
//           st_totalDisc = dbl_TotalDisc.toStringAsFixed(get_decimalpoints());
//         } catch (_) {}
//         try {
//           double dbl_TotalExcludedDisc = double.parse(
//             state.response.salesMaster!.subTotal.toString(),
//           );
//           st_totalDiscExcluded = dbl_TotalExcludedDisc.toStringAsFixed(
//             get_decimalpoints(),
//           );
//         } catch (_) {}

//         try {
//           double dbl_NetInvAmt = double.parse(
//             state.response.salesMaster!.grandTotal.toString(),
//           );
//           st_netInvAmt = dbl_NetInvAmt.toStringAsFixed(get_decimalpoints());
//         } catch (_) {}

//         String amPmTime = '';
//         try {
//           String st_Time = state.response.salesMaster!.invoiceTime.toString();
//           // Parse the railway time to a DateTime object
//           DateTime time = DateFormat('HH:mm').parse(st_Time);
//           amPmTime = DateFormat('hh:mm a').format(time);
//           print('ChangedTime $amPmTime');
//         } catch (_) {}

//         st_custName = state.response.salesMaster!.ledgerName.toString();
//         st_custAddress = state.response.salesMaster!.ledgerName
//             .toString(); // Assuming there's an address field

//         // Handle null cases
//         st_custName = st_custName == 'null' ? '' : st_custName;
//         st_custAddress = st_custAddress == 'null' ? '' : st_custAddress;

//         String st_custName1 = '', st_custName2 = '';
//         bool custSecondStatus = false;
//         if (st_custName.length > 1) {
//           st_custName1 = st_custName;
//           if (st_custName.length > 38) {
//             st_custName1 = st_custName.substring(0, 38);
//             if (st_custName.length > 76) {
//               st_custName2 = st_custName.substring(38, 76);
//             } else {
//               st_custName2 = st_custName.substring(38, st_custName.length);
//             }
//           }
//           if (st_custName2.length > 1) {
//             custSecondStatus = true;
//           }
//         }
//       }
//     },
//     builder: (context, state) {
//       return Card(
//         margin: const EdgeInsets.all(8),
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Column(
//             children: [
//               totalRow("Total Qty", _totalQtyController.text.toString()),
//               totalRow("Sub Total", st_SubTotal.toString()),
//               totalRow('Tax Amount', st_TotalTax),
//               const Divider(),
//               totalRow("Grand Total", st_GrandTotal, isBold: true),
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }
Widget totalCard() {
  return BlocConsumer<SalesReportCubit, SlesReportState>(
    listener: (context, state) {
      if (state is SalesDetailsSuccess) {
        saleList.clear();
        saleList.add(state.response);

        // Calculate total quantity
        totalQty = 0;
        for (int i = 0; i < saleList.first.salesDetails.length; i++) {
          totalQty =
              totalQty +
              double.parse(saleList.first.salesDetails[i].qty.toString());
          String truncated = totalQty.toStringAsFixed(get_decimalpoints());
          _totalQtyController.text = truncated.toString();
        }

        // Reset all tax values
        st_TotalTax = '0';
        st_sgst = '0';
        st_cgst = '0';
        st_GrandTotal = '0';
        st_SubTotal = '0';
        st_TaxableAmt = '0';
        st_totalDisc = '0';
        st_netInvAmt = '0';

        // Get VAT settings
        final sharedPrefHelper = SharedPreferenceHelper();
        String vatEnabled = '';
        String vatType = '';

        // Get values from SharedPreferences
        Future(() async {
          vatEnabled = await sharedPrefHelper.getVatStatus().toString();
          vatType = await sharedPrefHelper.getVatType() ?? '';

          // Calculate values based on VAT settings
          try {
            double dblsubTotal = double.parse(
              state.response.salesMaster!.subTotal.toString(),
            );
            st_SubTotal = dblsubTotal.toStringAsFixed(get_decimalpoints());
            st_TaxableAmt = st_SubTotal;

            // Calculate tax based on VAT status and type
            if (vatEnabled == 'true' && vatType.isNotEmpty) {
              double dbltax = double.parse(
                state.response.salesMaster!.vatAmount.toString(),
              );
              st_TotalTax = dbltax.toStringAsFixed(get_decimalpoints());

              // For GST, split into SGST and CGST
              if (vatType.toLowerCase() == 'gst') {
                double halfTax = dbltax / 2;
                st_sgst = halfTax.toStringAsFixed(get_decimalpoints());
                st_cgst = halfTax.toStringAsFixed(get_decimalpoints());
              }
            } else {
              // No tax if VAT is not enabled or type is null/empty
              st_TotalTax = '0';
              st_sgst = '0';
              st_cgst = '0';
            }

            // Calculate grand total
            double dblGrandTotal =
                double.parse(st_SubTotal) + double.parse(st_TotalTax);
            st_GrandTotal = dblGrandTotal.toStringAsFixed(get_decimalpoints());

            // Calculate discount
            try {
              double dbl_TotalDisc = double.parse(
                state.response.salesMaster!.discountAmount.toString(),
              );
              st_totalDisc = dbl_TotalDisc.toStringAsFixed(get_decimalpoints());
            } catch (_) {}

            // Calculate net invoice amount
            try {
              double dbl_NetInvAmt = double.parse(
                state.response.salesMaster!.grandTotal.toString(),
              );
              st_netInvAmt = dbl_NetInvAmt.toStringAsFixed(get_decimalpoints());
            } catch (_) {}
          } catch (_) {}
        });

        // Handle time formatting
        try {
          String st_Time = state.response.salesMaster!.invoiceTime.toString();
          DateTime time = DateFormat('HH:mm').parse(st_Time);
          amPmTime = DateFormat('hh:mm a').format(time);
          print('ChangedTime $amPmTime');
        } catch (_) {}

        st_custName = state.response.salesMaster!.ledgerName.toString();
        st_custAddress = state.response.salesMaster!.ledgerName.toString();

        // Handle null cases
        st_custName = st_custName == 'null' ? '' : st_custName;
        st_custAddress = st_custAddress == 'null' ? '' : st_custAddress;
      }
    },
    builder: (context, state) {
      // Get VAT settings for display
      String vatEnabled = '';
      String vatType = '';

      // This should be fetched properly in a real scenario
      // For now, we'll use the global variables
      vatEnabled = st_vatEnabled;
      vatType = st_vatType;

      return Card(
        margin: const EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              totalRow("Total Qty", _totalQtyController.text.toString()),
              totalRow("Sub Total", st_SubTotal.toString()),

              // Show tax rows only if VAT is enabled and has a type
              if (vatEnabled == 'true' && vatType.isNotEmpty)
                Column(
                  children: [
                    if (vatType.toLowerCase() == 'gst')
                      Column(
                        children: [
                          totalRow('SGST', st_sgst),
                          totalRow('CGST', st_cgst),
                        ],
                      )
                    else if (vatType.toLowerCase() == 'tax')
                      totalRow('Tax Amount', st_TotalTax),
                  ],
                ),

              totalRow("Discount", st_totalDisc),
              const Divider(),
              totalRow("Grand Total", st_GrandTotal, isBold: true),
            ],
          ),
        ),
      );
    },
  );
}

Widget totalRow(String label, String value, {bool isBold = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    ),
  );
}

/// -------------------- STYLES --------------------
const headerStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 12);
//Calculate Total Details
void _calculateTotals(List<SalesMaster> list) {
  saleTotal = 0;

  for (final item in list) {
    saleTotal += double.tryParse(item.grandTotal ?? '0') ?? 0;
  }

  _totalRecordsController.text = list.length.toString();
  _totalSalesController.text = saleTotal.toStringAsFixed(2);
}

int get_decimalpoints() {
  final int decimal_points = 2;
  return decimal_points;
}

String _formatDate(String dateStr) {
  DateTime dateTime = DateTime.parse(
    dateStr,
  ); // Parse the string into a DateTime object
  String formattedDate = DateFormat(
    'dd-MM-yyyy',
  ).format(dateTime); // Format the DateTime object
  return formattedDate;
}
