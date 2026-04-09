import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:quikservnew/features/sale/presentation/widgets/dashboard_content.dart';
import 'package:quikservnew/features/salesReport/domain/entities/salesdetails_bymasterid_result.dart';
import 'package:quikservnew/features/salesReport/domain/parameters/salesDetails_request_parameter.dart';
import 'package:quikservnew/features/salesReport/presentation/bloc/sles_report_cubit.dart';
import 'package:quikservnew/features/salesReport/presentation/screens/salesreport_preview_screen.dart';
import 'package:quikservnew/services/shared_preference_helper.dart';

Widget totalCard(TextEditingController totalQtyController) {
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
          totalQtyController.text = truncated.toString();
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
          vatType = await sharedPrefHelper.getVatType();

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
              totalRow("Total Qty", totalQtyController.text.toString()),
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

/// -------------------- TOP CARD --------------------
Widget topBillInfoCard({required String billDate, required String billTime}) {
  return BlocConsumer<SalesReportCubit, SlesReportState>(
    listener: (context, state) {
      if (state is SlesDetailsInitial) {
        //showLoadingDialog(context);
      }
      if (state is SalesDetailsSuccess) {
        st_custName = state.response.salesMaster!.ledgerName;
        tokenNo = state.response.salesMaster!.billTokenNo;
        print(tokenNo);
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
          padding: EdgeInsets.all(12),
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
              Row(
                children: [
                  const Text(
                    "Customer Name:",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  Text(st_custName, style: TextStyle(color: Colors.black)),
                ],
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  Text(
                    "TokenNo:",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(width: 4),
                  Text(
                    tokenNo.toString(),
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
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
              Expanded(flex: 1, child: Text("Rate", style: headerStyle)),
              Expanded(
                flex: 1,
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
            if (state is SaleDetailsLoading) {
              return SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (state is SalesDetailsSuccess) {
              return SizedBox(
                //height: 200,
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
                              '$st_qty-${data.unitName}',
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 8,
                              ),
                            ),
                          ),
                          Expanded(flex: 1, child: Text(data.salesRate)),
                          Expanded(
                            flex: 1,
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

Future<void> fetchDetails(String stMasterID, BuildContext context) async {
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

Widget footerTotalSection(TextEditingController totalRecordsController) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 8,
          offset: const Offset(0, -2),
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Total Records",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              totalRecordsController.text,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              "Total Sales",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              totalRecordsController.text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

String formatTime(String time) {
  try {
    return DateFormat('hh:mm a').format(DateFormat('HH:mm:ss').parse(time));
  } catch (_) {
    return time;
  }
}

/// 🔹 DATE CARD
Widget dateCard(String title, DateTime date, VoidCallback onTap) {
  return Card(
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 6),
            Text(
              formatter.format(date),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    ),
  );
}
