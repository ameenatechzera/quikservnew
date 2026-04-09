import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quikservnew/core/config/colors.dart';
import 'package:quikservnew/core/utils/widgets/common_appbar.dart';
import 'package:quikservnew/features/salesReport/domain/entities/salesdetails_bymasterid_result.dart';
import 'package:quikservnew/features/salesReport/presentation/widgets/sales_report_row.dart';
import 'package:quikservnew/features/salesReport/presentation/widgets/salesreport_widgets.dart';

class SalesReportPreviewScreen extends StatefulWidget {
  final String pagefrom;
  final String masterId;
  const SalesReportPreviewScreen({
    super.key,
    required this.pagefrom,
    required this.masterId,
  });

  @override
  State<SalesReportPreviewScreen> createState() =>
      _SalesReportPreviewScreenState();
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
// final _totalRecordsController = TextEditingController();
// final _totalSalesController = TextEditingController();
final _totalQtyController = TextEditingController();
String st_custName = '', st_custAddress = '';
String amPmTime = '', st_billDate = '';
int clickPdfFlag = 0;
int tokenNo = 0;
double saleTotal = 0;

class _SalesReportPreviewScreenState extends State<SalesReportPreviewScreen> {
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
    super.initState();
    fetchDetails(stMasterID, context);
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateFormatter = DateFormat('dd-MM-yyyy');
    final timeFormatter = DateFormat('hh:mm a');
    return Scaffold(
      appBar: const CommonAppBar(title: "Bill Preview"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
              totalCard(_totalQtyController),
              Padding(
                padding: const EdgeInsets.only(
                  left: 2.0,
                  right: 2.0,
                  top: 0.0,
                  bottom: 6.0,
                ),
                child: SalesReportRow(selectPrintStatus: selectPrintStatus),
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
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: appBarColor),
                              ),
                            ),
                      ),
                      onPressed: () {},
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
      ),
    );
  }
}

/// -------------------- STYLES --------------------
const headerStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 12);
int get_decimalpoints() {
  final int decimal_points = 2;
  return decimal_points;
}
