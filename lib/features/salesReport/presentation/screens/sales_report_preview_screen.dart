import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:fluttertoast/fluttertoast.dart';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quikservnew/core/config/colors.dart';
import 'package:quikservnew/features/salesReport/domain/entities/salesDetailsByMasterIdResult.dart';
import 'package:quikservnew/features/salesReport/domain/parameters/salesDetails_request_parameter.dart';
import 'package:quikservnew/features/salesReport/domain/parameters/salesReport_request_parameter.dart';
import 'package:quikservnew/features/salesReport/presentation/bloc/sles_report_cubit.dart';
import 'package:quikservnew/features/salesReport/presentation/widgets/dottedLinePainter.dart';
import 'package:quikservnew/features/salesReport/presentation/widgets/print_thermal.dart';
import 'package:quikservnew/services/shared_preference_helper.dart';
// import 'package:share_plus/share_plus.dart';

class SaleReportPreviewScreen extends StatefulWidget {
  final String st_fromDate;

  final String st_toDate;

  final String pagefrom;

  final String masterId;

  SaleReportPreviewScreen({
    super.key,
    required this.st_fromDate,
    required this.st_toDate,
    required this.pagefrom,
    required this.masterId,
  });

  @override
  State<SaleReportPreviewScreen> createState() =>
      _SaleReportPreviewScreenState();
}

class _SaleReportPreviewScreenState extends State<SaleReportPreviewScreen> {
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
  String st_GrandTotal = '',
      st_SubTotal = '',
      st_DbName = '',
      st_TaxableAmt = '',
      st_TotalTax = '',
      st_netInvAmt = '',
      st_totalDisc = '',
      st_cgst = '',
      st_totalDiscExcluded = '';
  List<SalesDetailsByMasterIdResult> saleList = [];

  String pagefromValue = '', st_SalesInvoiceNo = '', stMasterID = '';
  final _totalQtyController = TextEditingController();
  int clickPdfFlag = 0;

  @override
  void initState() {
    stMasterID = widget.masterId;
    fetchDetails(stMasterID);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidthactual = MediaQuery.of(context).size.width;
    double screenWidth = MediaQuery.of(context).size.width - 16;
    Size screenSize = MediaQuery.of(context).size;
    double topHeight = (screenSize.height) * 0.28; // 70% of the screen height
    double listHeight = (screenSize.height) * 0.19; // 30% of the screen height
    double totalHeight = (screenSize.height) * 0.42; // 30% of the screen height
    return WillPopScope(
      onWillPop: () async {
        // context.read<AppbarCubit>().salesReportPageSelected();
        context.read<SalesReportCubit>().fetchSalesReport(
          FetchReportRequest(
            from_date: widget.st_fromDate,
            to_date: widget.st_toDate,
            user_id: '1',
            branchId: "1",
          ),
        );
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: Column(
          children: [
            Expanded(
              child: Container(
                height: 1500,
                color: Colors.white,
                child: BlocConsumer<SalesReportCubit, SlesReportState>(
                  listener: (context, state) {
                    print('state $state');

                    if (state is SalesDetailsSuccess) {}
                  },
                  builder: (context, state) {
                    if (state is SlesDetailsInitial) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              appBarColor,
                            ),
                          ), // centered loading
                        ),
                      );
                    }
                    if (state is SalesDetailsSuccess) {
                      return BlocBuilder<SalesReportCubit, SlesReportState>(
                        builder: (context, state) {
                          if (state is SalesDetailsSuccess) {
                            saleList.clear();
                            saleList.add(state.response);

                            // Sale sale = state.salesDetails.table;
                            totalQty = 0;
                            for (
                              int i = 0;
                              i < saleList.first.salesDetails.length;
                              i++
                            ) {
                              totalQty =
                                  totalQty +
                                  double.parse(
                                    saleList.first.salesDetails[i].qty
                                        .toString(),
                                  );
                              String truncated = totalQty.toStringAsFixed(
                                get_decimalpoints(),
                              ); // Keeps one decimal place
                              print('truncated $truncated');
                              _totalQtyController.text = truncated.toString();
                            }
                            st_GrandTotal = '0';
                            try {
                              double dbltax = double.parse(
                                state.response.salesMaster!.vatAmount
                                    .toString(),
                              );
                              double dblsubTotal = double.parse(
                                state.response.salesMaster!.subTotal.toString(),
                              );
                              double dblGrandTotal = dbltax + dblsubTotal;
                              st_GrandTotal = dblGrandTotal.toStringAsFixed(
                                get_decimalpoints(),
                              );
                            } catch (_) {}
                            try {
                              double dbl_SubTotal = double.parse(
                                state.response.salesMaster!.subTotal.toString(),
                              );
                              st_SubTotal = dbl_SubTotal.toStringAsFixed(
                                get_decimalpoints(),
                              );
                            } catch (_) {}
                            try {
                              double dbl_TaxableAmt = double.parse(
                                state.response.salesMaster!.subTotal.toString(),
                              );
                              st_TaxableAmt = dbl_TaxableAmt.toStringAsFixed(
                                get_decimalpoints(),
                              );
                            } catch (_) {}
                            try {
                              double dbl_TotalTax = double.parse(
                                state.response.salesMaster!.vatAmount
                                    .toString(),
                              );
                              st_TotalTax = dbl_TotalTax.toStringAsFixed(
                                get_decimalpoints(),
                              );
                            } catch (_) {}
                            if (st_vatType == 'GST') {
                              double dbl_TotalTax = double.parse(
                                state.response.salesMaster!.vatAmount
                                    .toString(),
                              );
                              double dbl_cgst = dbl_TotalTax / 2;
                              st_cgst = dbl_cgst.toStringAsFixed(
                                get_decimalpoints(),
                              );
                            }
                            try {
                              double dbl_TotalDisc = double.parse(
                                state.response.salesMaster!.discountAmount
                                    .toString(),
                              );
                              st_totalDisc = dbl_TotalDisc.toStringAsFixed(
                                get_decimalpoints(),
                              );
                            } catch (_) {}
                            try {
                              double dbl_TotalExcludedDisc = double.parse(
                                state.response.salesMaster!.subTotal.toString(),
                              );
                              st_totalDiscExcluded = dbl_TotalExcludedDisc
                                  .toStringAsFixed(get_decimalpoints());
                            } catch (_) {}

                            try {
                              double dbl_NetInvAmt = double.parse(
                                state.response.salesMaster!.grandTotal
                                    .toString(),
                              );
                              st_netInvAmt = dbl_NetInvAmt.toStringAsFixed(
                                get_decimalpoints(),
                              );
                            } catch (_) {}

                            String amPmTime = '';
                            try {
                              String st_Time = state
                                  .response
                                  .salesMaster!
                                  .invoiceTime
                                  .toString();
                              // Parse the railway time to a DateTime object
                              DateTime time = DateFormat(
                                'HH:mm',
                              ).parse(st_Time);
                              amPmTime = DateFormat('hh:mm a').format(time);
                              print('ChangedTime $amPmTime');
                            } catch (_) {}
                            // String st_custName = state
                            //     .salesDetailsResult.salesMaster!.ledgerName
                            //     .toString();
                            String st_custName = state
                                .response
                                .salesMaster!
                                .ledgerName
                                .toString();
                            String st_custAddress = state
                                .response
                                .salesMaster!
                                .ledgerName
                                .toString(); // Assuming there's an address field

                            // Handle null cases
                            st_custName = st_custName == 'null'
                                ? ''
                                : st_custName;
                            st_custAddress = st_custAddress == 'null'
                                ? ''
                                : st_custAddress;

                            String st_custName1 = '', st_custName2 = '';
                            bool custSecondStatus = false;
                            print('st_custNameLength ${st_custName.length}');
                            if (st_custName.length > 1) {
                              st_custName1 = st_custName;
                              if (st_custName.length > 38) {
                                st_custName1 = st_custName.substring(0, 38);
                                if (st_custName.length > 76) {
                                  st_custName2 = st_custName.substring(38, 76);
                                } else {
                                  st_custName2 = st_custName.substring(
                                    38,
                                    st_custName.length,
                                  );
                                }
                              }
                              if (st_custName2.length > 1) {
                                custSecondStatus = true;
                              }
                            }

                            listHeight =
                                70.00 * state.response.salesDetails.length;
                            return Container(
                              color:
                                  //appThemeOrange,
                                  appThemegrayColors,
                              child: Column(
                                //mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 2.0,
                                      right: 2.0,
                                      top: 6.0,
                                    ),
                                    child: Card(
                                      child: Container(
                                        color: Colors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Center(
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                        left: 8.0,
                                                      ),
                                                      child: RichText(
                                                        text: TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text:
                                                                  ('Invoice No :'),
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .red[900],
                                                                fontSize: 15,
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text:
                                                                  ("  " +
                                                                  state
                                                                      .response
                                                                      .salesMaster!
                                                                      .invoiceNo
                                                                      .toString()),
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .red[900],
                                                                fontSize: 18,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.all(
                                                        8.0,
                                                      ),
                                                      child: RichText(
                                                        text: TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text:
                                                                  ('Bill Date :'),
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .red[900],
                                                                fontSize: 13,
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text:
                                                                  ("  " +
                                                                  (_formatDate(
                                                                    state
                                                                        .response
                                                                        .salesMaster!
                                                                        .invoiceDate
                                                                        .toString(),
                                                                  ))),
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .red[900],
                                                                fontSize: 15,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.all(
                                                        8.0,
                                                      ),
                                                      child: RichText(
                                                        text: TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text:
                                                                  ('Bill Time :'),
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .red[900],
                                                                fontSize: 13,
                                                              ),
                                                            ),
                                                            TextSpan(
                                                              text:
                                                                  ("  " +
                                                                  amPmTime
                                                                      .toString()),
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .red[900],
                                                                fontSize: 15,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                            left: 8.0,
                                                            right: 8.0,
                                                            top: 2.0,
                                                            bottom: 0.0,
                                                          ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets.only(
                                                                  top: 4.0,
                                                                  bottom: 8.0,
                                                                ),
                                                            child: RichText(
                                                              text: TextSpan(
                                                                children: [
                                                                  const TextSpan(
                                                                    text:
                                                                        ('Customer Name : '),
                                                                    style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          13,
                                                                    ),
                                                                  ),
                                                                  TextSpan(
                                                                    text:
                                                                        (st_custName1),
                                                                    style: const TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          11,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Visibility(
                                                            visible:
                                                                custSecondStatus,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets.only(
                                                                    top: 4.0,
                                                                    bottom: 8.0,
                                                                  ),
                                                              child: RichText(
                                                                text: TextSpan(
                                                                  children: [
                                                                    const TextSpan(
                                                                      text:
                                                                          ('                                '),
                                                                      style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            13,
                                                                      ),
                                                                    ),
                                                                    TextSpan(
                                                                      text:
                                                                          ("  " +
                                                                          st_custName2),
                                                                      style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            11,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          RichText(
                                                            text: TextSpan(
                                                              children: [
                                                                const TextSpan(
                                                                  text:
                                                                      ('Customer Address : '),
                                                                  style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        13,
                                                                  ),
                                                                ),
                                                                TextSpan(
                                                                  // text: ("  " +
                                                                  //     state
                                                                  //         .salesDetailsResult
                                                                  //         .salesMaster!
                                                                  //         .ledgerName
                                                                  //         .toString()),
                                                                  text:
                                                                      ("  " +
                                                                      st_custAddress),
                                                                  style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        15,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                  top: 8.0,
                                                                ),
                                                            child: Text(''),
                                                          ),
                                                        ],
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
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        top: 2.0,
                                        left: 2.0,
                                        right: 2.0,
                                        bottom: 2.0,
                                      ),
                                      child: Card(
                                        color: Colors.white,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(1),
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 40,
                                              color: Colors.white,
                                              child: const Padding(
                                                padding: EdgeInsets.only(
                                                  top: 4.0,
                                                  bottom: 8.0,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text('#'),
                                                    ),
                                                    Expanded(
                                                      flex: 4,
                                                      child: Text(
                                                        'Barcode',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 3,
                                                      child: Text(
                                                        'Qty',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 3,
                                                      child: Text(
                                                        'Rate',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                    Visibility(
                                                      visible: false,
                                                      child: Expanded(
                                                        flex: 3,
                                                        child: Text(
                                                          'Vat',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 3,
                                                      child: Text('Total'),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                top: 8.0,
                                              ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: screenWidth,
                                                    height: 2,
                                                    child: CustomPaint(
                                                      painter:
                                                          DottedLinePainter(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              color: Colors.white,
                                              //height: state.salesDetails.salesDetails.length*75,
                                              width: screenWidth,
                                              child: ListView.separated(
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemCount: state
                                                    .response
                                                    .salesDetails
                                                    .length,
                                                separatorBuilder:
                                                    (
                                                      BuildContext context,
                                                      int index,
                                                    ) => Container(height: 10),
                                                itemBuilder: (BuildContext context, int index) {
                                                  int slno = index + 1;

                                                  SalesDetail data = state
                                                      .response
                                                      .salesDetails[index];
                                                  String st_qty = '',
                                                      st_rate = '',
                                                      st_total = '';
                                                  try {
                                                    st_qty =
                                                        double.parse(
                                                          data.qty.toString(),
                                                        ).toStringAsFixed(
                                                          get_decimalpoints(),
                                                        );
                                                  } catch (_) {}
                                                  try {
                                                    st_rate =
                                                        double.parse(
                                                          data.salesRate
                                                              .toString(),
                                                        ).toStringAsFixed(
                                                          get_decimalpoints(),
                                                        );
                                                  } catch (_) {}
                                                  try {
                                                    double dblQty =
                                                        double.parse(
                                                          data.qty.toString(),
                                                        );
                                                    double salesRate =
                                                        double.parse(
                                                          data.salesRate,
                                                        );
                                                    double dblTotal =
                                                        dblQty * salesRate;
                                                    st_total = dblTotal
                                                        .toStringAsFixed(
                                                          get_decimalpoints(),
                                                        );
                                                  } catch (_) {}

                                                  return Column(
                                                    children: [
                                                      Container(
                                                        color: Colors.white,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.only(
                                                                top: 0.0,
                                                                bottom: 2.0,
                                                                left: 2.0,
                                                              ),
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                flex: 1,
                                                                child: Text(
                                                                  slno.toString(),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 17,
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets.all(
                                                                        4.0,
                                                                      ),
                                                                  child: Text(
                                                                    data.productName,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                    style: const TextStyle(
                                                                      fontSize:
                                                                          11,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        color: Colors.white,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.only(
                                                                top: 8.0,
                                                                bottom: 8.0,
                                                              ),
                                                          child: Row(
                                                            children: [
                                                              const Expanded(
                                                                flex: 1,
                                                                child: Text(''),
                                                              ),
                                                              Expanded(
                                                                flex: 4,
                                                                child: Text(
                                                                  data.productCode
                                                                      .toString(),
                                                                  style:
                                                                      TextStyle(
                                                                        fontSize:
                                                                            11,
                                                                      ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 3,
                                                                child: Text(
                                                                  st_qty +
                                                                      '-' +
                                                                      data.unitName
                                                                          .toString(),
                                                                  style: const TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                    fontSize:
                                                                        11,
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 3,
                                                                child: Text(
                                                                  st_rate
                                                                      .toString(),
                                                                  style:
                                                                      TextStyle(
                                                                        fontSize:
                                                                            11,
                                                                      ),
                                                                ),
                                                              ),
                                                              Visibility(
                                                                visible: false,
                                                                child: Expanded(
                                                                  flex: 3,
                                                                  child: Text(
                                                                    data.vatAmount
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                      fontSize:
                                                                          11,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 3,
                                                                child: Text(
                                                                  '  ' +
                                                                      st_total
                                                                          .toString(),
                                                                  style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .red,
                                                                    fontSize:
                                                                        11,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 3.0,
                                      right: 3.0,
                                    ),
                                    child: Card(
                                      color: Colors.white,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(1),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  width: double.infinity,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                          left: 60.0,
                                                        ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        const Expanded(
                                                          flex: 3,
                                                          child: Text(
                                                            'Total Qty                     :',
                                                            textAlign:
                                                                TextAlign.left,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 3,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets.only(
                                                                  top: 8.0,
                                                                  right: 12.0,
                                                                  bottom: 8.0,
                                                                ),
                                                            child: Text(
                                                              _totalQtyController
                                                                  .text
                                                                  .toString(),
                                                              style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  width: double.infinity,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                          left: 60.0,
                                                        ),
                                                    child: Row(
                                                      children: [
                                                        const Expanded(
                                                          flex: 3,
                                                          child: Text(
                                                            'Sub Total                    :',
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 3,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets.only(
                                                                  top: 8.0,
                                                                  right: 12.0,
                                                                  bottom: 8.0,
                                                                ),
                                                            child: Text(
                                                              st_SubTotal
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Visibility(
                                                visible: vatStatus,
                                                child: Expanded(
                                                  child: SizedBox(
                                                    width: double.infinity,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                            left: 60.0,
                                                          ),
                                                      child: Row(
                                                        children: [
                                                          const Expanded(
                                                            flex: 3,
                                                            child: Text(
                                                              'Taxable Amt               :',
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 3,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets.only(
                                                                    top: 8.0,
                                                                    right: 12.0,
                                                                    bottom: 8.0,
                                                                  ),
                                                              child: Text(
                                                                (st_TaxableAmt
                                                                    .toString()),
                                                                style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .right,
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
                                          Visibility(
                                            visible: discTaxIncludedStatus,
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        width: double.infinity,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.only(
                                                                left: 60.0,
                                                              ),
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                flex: 3,
                                                                child: Text(
                                                                  'Discount          :',
                                                                ),
                                                              ),
                                                              Visibility(
                                                                visible:
                                                                    discTaxIncludedStatus,
                                                                child: Expanded(
                                                                  flex: 3,
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.only(
                                                                      top: 8.0,
                                                                      right:
                                                                          12.0,
                                                                      bottom:
                                                                          8.0,
                                                                    ),
                                                                    child: Text(
                                                                      st_totalDisc
                                                                          .toString(),
                                                                      style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .right,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Visibility(
                                                                visible:
                                                                    discTaxExcludedStatus,
                                                                child: Expanded(
                                                                  flex: 3,
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.only(
                                                                      top: 8.0,
                                                                      right:
                                                                          12.0,
                                                                      bottom:
                                                                          8.0,
                                                                    ),
                                                                    child: Text(
                                                                      st_totalDiscExcluded
                                                                          .toString(),
                                                                      style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .right,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        width: double.infinity,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.only(
                                                                left: 60.0,
                                                              ),
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                flex: 3,
                                                                child: Text(
                                                                  'Tax                   :',
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 3,
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets.only(
                                                                        top:
                                                                            8.0,
                                                                        right:
                                                                            12.0,
                                                                        bottom:
                                                                            8.0,
                                                                      ),
                                                                  child: Text(
                                                                    state
                                                                        .response
                                                                        .salesMaster!
                                                                        .vatAmount
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .right,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Visibility(
                                            //visible: discTaxExcludedStatus,
                                            visible: vatStatus,
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        width: double.infinity,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.only(
                                                                left: 60.0,
                                                              ),
                                                          child: Row(
                                                            children: [
                                                              const Expanded(
                                                                flex: 3,
                                                                child: Text(
                                                                  'Tax                                :',
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 3,
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets.only(
                                                                        top:
                                                                            8.0,
                                                                        right:
                                                                            12.0,
                                                                        bottom:
                                                                            8.0,
                                                                      ),
                                                                  child: Text(
                                                                    st_TotalTax
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .right,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        width: double.infinity,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.only(
                                                                left: 60.0,
                                                              ),
                                                          child: Row(
                                                            children: [
                                                              const Expanded(
                                                                flex: 3,
                                                                child: Text(
                                                                  'Discount                      :',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                ),
                                                              ),
                                                              Visibility(
                                                                visible:
                                                                    discTaxIncludedStatus,
                                                                child: Expanded(
                                                                  flex: 3,
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.only(
                                                                      top: 8.0,
                                                                      right:
                                                                          12.0,
                                                                      bottom:
                                                                          8.0,
                                                                    ),
                                                                    child: Text(
                                                                      st_totalDisc
                                                                          .toString(),
                                                                      style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .right,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Visibility(
                                                                visible:
                                                                    discTaxExcludedStatus,
                                                                child: Expanded(
                                                                  flex: 3,
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.only(
                                                                      top: 8.0,
                                                                      right:
                                                                          12.0,
                                                                      bottom:
                                                                          8.0,
                                                                    ),
                                                                    child: Text(
                                                                      st_totalDiscExcluded,
                                                                      style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .right,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Visibility(
                                            //visible: discTaxExcludedStatus,
                                            visible: gstStatus,
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        width: double.infinity,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.only(
                                                                left: 60.0,
                                                              ),
                                                          child: Row(
                                                            children: [
                                                              const Expanded(
                                                                flex: 3,
                                                                child: Text(
                                                                  'CGST                            :',
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 3,
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets.only(
                                                                        top:
                                                                            8.0,
                                                                        right:
                                                                            12.0,
                                                                        bottom:
                                                                            8.0,
                                                                      ),
                                                                  child: Text(
                                                                    st_cgst
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .right,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        width: double.infinity,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.only(
                                                                left: 60.0,
                                                              ),
                                                          child: Row(
                                                            children: [
                                                              const Expanded(
                                                                flex: 3,
                                                                child: Text(
                                                                  'SGST                             :',
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 3,
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets.only(
                                                                        top:
                                                                            8.0,
                                                                        right:
                                                                            12.0,
                                                                        bottom:
                                                                            8.0,
                                                                      ),
                                                                  child: Text(
                                                                    st_cgst
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .right,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Visibility(
                                                  visible: true,
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          width:
                                                              double.infinity,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets.only(
                                                                  left: 60.0,
                                                                ),
                                                            child: Row(
                                                              children: [
                                                                const Expanded(
                                                                  flex: 3,
                                                                  child: Text(
                                                                    'Grand Total                 :',
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex: 3,
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.only(
                                                                      top: 8.0,
                                                                      right:
                                                                          12.0,
                                                                      bottom:
                                                                          8.0,
                                                                    ),
                                                                    child: Text(
                                                                      st_GrandTotal,
                                                                      style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .right,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        width: double.infinity,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.only(
                                                                left: 60.0,
                                                              ),
                                                          child: Row(
                                                            children: [
                                                              const Expanded(
                                                                flex: 3,
                                                                child: Text(
                                                                  'Discount                      :',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                ),
                                                              ),
                                                              Visibility(
                                                                visible:
                                                                    discTaxIncludedStatus,
                                                                child: Expanded(
                                                                  flex: 3,
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.only(
                                                                      top: 8.0,
                                                                      right:
                                                                          12.0,
                                                                      bottom:
                                                                          8.0,
                                                                    ),
                                                                    child: Text(
                                                                      st_totalDisc
                                                                          .toString(),
                                                                      style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .right,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Visibility(
                                                                visible:
                                                                    discTaxExcludedStatus,
                                                                child: Expanded(
                                                                  flex: 3,
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.only(
                                                                      top: 8.0,
                                                                      right:
                                                                          12.0,
                                                                      bottom:
                                                                          8.0,
                                                                    ),
                                                                    child: Text(
                                                                      st_totalDiscExcluded,
                                                                      style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .right,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        width: double.infinity,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.only(
                                                                left: 60.0,
                                                              ),
                                                          child: Row(
                                                            children: [
                                                              const Expanded(
                                                                flex: 3,
                                                                child: Text(
                                                                  'Net Invoice Amount   :',
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 3,
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets.only(
                                                                        top:
                                                                            8.0,
                                                                        right:
                                                                            12.0,
                                                                        bottom:
                                                                            8.0,
                                                                      ),
                                                                  child: Text(
                                                                    st_GrandTotal,
                                                                    style: const TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .right,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Visibility(
                                            visible: true,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    width: double.infinity,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                            left: 60.0,
                                                          ),
                                                      child: Row(
                                                        children: [
                                                          const Expanded(
                                                            flex: 3,
                                                            child: Text(
                                                              'Grand Total                 :',
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 3,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets.only(
                                                                    top: 8.0,
                                                                    right: 12.0,
                                                                    bottom: 8.0,
                                                                  ),
                                                              child: Text(
                                                                st_GrandTotal,
                                                                style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .right,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Visibility(
                                              visible: false,
                                              child: Expanded(
                                                flex: 1,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
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
                                                            MaterialStateProperty.all<
                                                              Color
                                                            >(appBarColor),
                                                        backgroundColor:
                                                            MaterialStateProperty.all<
                                                              Color
                                                            >(appBarColor),
                                                        shape:
                                                            MaterialStateProperty.all<
                                                              RoundedRectangleBorder
                                                            >(
                                                              RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      18.0,
                                                                    ),
                                                                side: BorderSide(
                                                                  color:
                                                                      appBarColor,
                                                                ),
                                                              ),
                                                            ),
                                                      ),
                                                      onPressed: () async {
                                                        print('pressed');
                                                        if (clickPdfFlag == 0) {
                                                          // Fluttertoast
                                                          //     .showToast(
                                                          //   msg:
                                                          //   "Generate new pdf before share!",
                                                          //   toastLength: Toast
                                                          //       .LENGTH_SHORT,
                                                          //   gravity:
                                                          //   ToastGravity
                                                          //       .BOTTOM,
                                                          //   backgroundColor:
                                                          //   Colors.grey,
                                                          //   textColor:
                                                          //   Colors.white,
                                                          //   fontSize: 16.0,
                                                          // );
                                                        } else {
                                                          //await sharePdf();
                                                        }
                                                      },
                                                      child: const Text(
                                                        'Share',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
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
                                                  padding:
                                                      const EdgeInsets.only(
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
                                                            MaterialStateProperty.all<
                                                              Color
                                                            >(appBarColor),
                                                        backgroundColor:
                                                            MaterialStateProperty.all(
                                                              appBarColor,
                                                            ),
                                                        shape:
                                                            MaterialStateProperty.all<
                                                              RoundedRectangleBorder
                                                            >(
                                                              RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      18.0,
                                                                    ),
                                                                side: BorderSide(
                                                                  color:
                                                                      appBarColor,
                                                                ),
                                                              ),
                                                            ),
                                                      ),
                                                      onPressed: () {
                                                        print('pressed');

                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                    PrintPage(
                                                                      pageFrom:
                                                                      'SalesReport',
                                                                      sales:
                                                                      saleList.first,
                                                                    )));

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
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Visibility(
                                              visible: false,
                                              child: Expanded(
                                                flex: 1,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        left: 2.0,
                                                        right: 2.0,
                                                        bottom: 2.0,
                                                      ),
                                                  child: Container(
                                                    width: 150,
                                                    height: 90,
                                                    child: Column(
                                                      children: [
                                                        Visibility(
                                                          visible: false,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets.only(
                                                                  left: 8.0,
                                                                ),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Expanded(
                                                                  flex: 1,
                                                                  child: Checkbox(
                                                                    visualDensity:
                                                                        VisualDensity
                                                                            .compact,
                                                                    // Reduces the size
                                                                    materialTapTargetSize:
                                                                        MaterialTapTargetSize
                                                                            .shrinkWrap,
                                                                    // Shrinks tap area
                                                                    value:
                                                                        selectedPdfWithBgIndex,
                                                                    // Check if the current item is selected
                                                                    onChanged:
                                                                        (
                                                                          bool?
                                                                          newValue,
                                                                        ) {
                                                                          setState(() {
                                                                            // If the current checkbox is clicked, update the selectedIndex
                                                                            selectedPdfWithBgIndex =
                                                                                newValue;
                                                                          });
                                                                        },
                                                                  ),
                                                                ),
                                                                const Visibility(
                                                                  visible:
                                                                      false,
                                                                  child: Expanded(
                                                                    flex: 6,
                                                                    child: Padding(
                                                                      padding: EdgeInsets.only(
                                                                        left:
                                                                            2.0,
                                                                      ),
                                                                      child: Text(
                                                                        ' with header',
                                                                        style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          fontSize:
                                                                              11,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Visibility(
                                                          visible: false,
                                                          child: Container(
                                                            width: 150,
                                                            height: 40,
                                                            child: ElevatedButton(
                                                              style: ButtonStyle(
                                                                foregroundColor:
                                                                    MaterialStateProperty.all<
                                                                      Color
                                                                    >(
                                                                      appBarColor,
                                                                    ),
                                                                backgroundColor:
                                                                    MaterialStateProperty.all<
                                                                      Color
                                                                    >(
                                                                      appBarColor,
                                                                    ),
                                                                shape:
                                                                    MaterialStateProperty.all<
                                                                      RoundedRectangleBorder
                                                                    >(
                                                                      RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                              18.0,
                                                                            ),
                                                                        side: BorderSide(
                                                                          color:
                                                                              appBarColor,
                                                                        ),
                                                                      ),
                                                                    ),
                                                              ),
                                                              onPressed: () {
                                                                clickPdfFlag =
                                                                    1;
                                                                // if (selectedPdfWithBgIndex == true) {
                                                                //   SharedPrefrence().setPdfPrintWithBgStatus('true');
                                                                // } else {
                                                                //   SharedPrefrence()
                                                                //       .setPdfPrintWithBgStatus('false');
                                                                // }
                                                                //st_pdfTypeSelected ='type_1';
                                                                // createPdfNew(saleList.first,st_pdfTypeSelected);
                                                              },
                                                              child: const Text(
                                                                'PDF',
                                                                style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                ),
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
                                            foregroundColor:
                                                MaterialStateProperty.all<
                                                  Color
                                                >(appBarColor),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                  appBarColor,
                                                ),
                                            shape:
                                                MaterialStateProperty.all<
                                                  RoundedRectangleBorder
                                                >(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          18.0,
                                                        ),
                                                    side: BorderSide(
                                                      color: appBarColor,
                                                    ),
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
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          return Container();
                        },
                      );
                    } else {
                      return Container(
                        color: Colors.red,
                        width: double.infinity,
                        height: double.infinity,
                        child: Center(child: Text('Loading...')),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
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

  Future<void> fetchDetails(String stMasterID) async {
    if (st_pdfTypeSelected.isEmpty) {
      st_pdfTypeSelected = 'type_3';
    }
    // print('st_pdfTypeSelected $st_pdfTypeSelected');
    // await SharedPrefrence().getVatType().then((value) async {
    //   print('st_vatType $value');
    //   st_vatType = value.toString();
    // });
    // await SharedPrefrence().getVatEnabledStatus().then((value) async {
    //   print('st_vatEnabled $value');
    //   st_vatEnabled = value.toString();
    // });
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
      // if (vatStatus) {
      //   AppData.vatStatus = 'VAT';
      // }
      // if (gstStatus) {
      //   AppData.vatStatus = 'GST';
      // }
    } else {
      vatStatus = false;
      gstStatus = false;
    }

    // SharedPrefrence().loadSelectedPrinter().then((selected) {
    //   if (selected!.isNotEmpty) {
    //     selectedPrinter = selected;
    //     print('selectedPrinter $selectedPrinter');
    //     selectPrintStatus = true;
    //   } else {
    //     selectedPrinter = 'No print';
    //     selectPrintStatus = false;
    //   }
    // });

    context.read<SalesReportCubit>().fetchSalesDetailsByMasterId(
      FetchSalesDetailsRequest(
        branchId: st_branchIdPref,
        SalesMasterId: stMasterID,
      ),
    );
  }

  //   Future<void> sharePdf() async {
  //     //final pdfFile = await generatePdf();
  //     final output = await getTemporaryDirectory();
  //     final file = File('${output.path}/' + 'st_PdfName' + '.pdf');
  //     // final file = File('${output.path}/maasker.pdf');
  //     final xFiles = [XFile(file.path, name: "Example 1")];
  //
  //     await Share.shareXFiles(
  //       xFiles,
  //       text: "Check out these PDFs!",
  //       subject: "PDF Sharing with Flutter",
  //     );
  //   }
}

int get_decimalpoints() {
  final int decimal_points = 2;
  return decimal_points;
}
