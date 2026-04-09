import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/features/salesReport/domain/entities/salesreport_result.dart';
import 'package:quikservnew/features/salesReport/domain/parameters/salesReport_request_parameter.dart';
import 'package:quikservnew/features/salesReport/presentation/bloc/sles_report_cubit.dart';
import 'package:quikservnew/features/salesReport/presentation/screens/salesreport_preview_screen.dart';
import 'package:quikservnew/features/salesReport/presentation/widgets/delete_confirmation_dialogue.dart';
import 'package:quikservnew/features/salesReport/presentation/widgets/salesreport_widgets.dart';
import 'package:quikservnew/services/shared_preference_helper.dart';

class SalesReportPage extends StatefulWidget {
  const SalesReportPage({super.key});

  @override
  State<SalesReportPage> createState() => _SalesReportPageNEWState();
}

List<SalesMaster> salesList = [];
double saleTotal = 0;
final _totalRecordsController = TextEditingController();
final _totalSalesController = TextEditingController();
final TextEditingController fromDateController = TextEditingController();
final TextEditingController toDateController = TextEditingController();
String st_branchId = '';
DateTime fromDate = DateTime.now();
DateTime toDate = DateTime.now();
final DateFormat formatter = DateFormat('MM-dd-yyyy');
void _onDateChanged(BuildContext context) {
  final fromDateRaw = fromDateController.text.trim();
  final toDateRaw = toDateController.text.trim();
  if (fromDateRaw.isNotEmpty && toDateRaw.isNotEmpty) {
    context.read<SalesReportCubit>().fetchSalesReport(
      FetchReportRequest(
        fromDate: formatter.format(fromDate),
        toDate: formatter.format(toDate),
        userId: '1',
        branchId: st_branchId,
      ),
    );
  }
}

class _SalesReportPageNEWState extends State<SalesReportPage> {
  @override
  void initState() {
    final now = DateTime.now();
    fromDateController.text = DateFormat('dd-MM-yyyy').format(now);
    toDateController.text = DateFormat('dd-MM-yyyy').format(now);
    super.initState();
    fetchSalesReport();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),

      appBar: AppBar(
        toolbarHeight: 40,
        backgroundColor: AppColors.theme,
        title: const Text(
          'Sales Report',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            _dateFilter(),
            const SizedBox(height: 16),
            Expanded(
              child: BlocConsumer<SalesReportCubit, SlesReportState>(
                listener: (context, state) {
                  if (state is SalesDeleteSuccess) {
                    Fluttertoast.showToast(
                      msg: "Sales details deleted successfully..!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.black87,
                      textColor: Colors.white,
                      fontSize: 14,
                    );
                    context.read<SalesReportCubit>().fetchSalesReport(
                      FetchReportRequest(
                        fromDate: formatter.format(fromDate),
                        toDate: formatter.format(toDate),
                        userId: '1',
                        branchId: st_branchId,
                      ),
                    );
                  }
                  if (state is SalesDeleteFailure) {
                    Fluttertoast.showToast(
                      msg: "Sales details deletion failed..!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.black87,
                      textColor: Colors.white,
                      fontSize: 14,
                    );
                  }
                  if (state is SalesReportSuccess) {
                    salesList.clear();
                    salesList = state.response.salesMaster;
                    print('salesList ${salesList}');
                    _calculateTotals(salesList);
                  }
                },
                builder: (context, state) {
                  if (state is SlesReportInitial) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (salesList.isEmpty) {
                    return const Center(child: Text("No data found"));
                  }
                  return Expanded(
                    child: ListView.builder(
                      itemCount: salesList.length,
                      itemBuilder: (context, index) {
                        final sale = salesList[index];
                        return _salesCard(sale);
                      },
                    ),
                  );
                },
              ),
            ),
            footerTotalSection(_totalRecordsController),
          ],
        ),
      ),
    );
  }

  /// 🔹 Date Filter
  Widget _dateFilter() {
    return Container(
      color: AppColors.theme,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextFormField(
                controller: fromDateController,
                readOnly: true,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                decoration: const InputDecoration(
                  labelText: '  From Date',
                  labelStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  floatingLabelAlignment: FloatingLabelAlignment.center,
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 0,
                  ),
                ),
                onTap: () => _selectDate(context, fromDateController),
              ),
            ),
          ),
          const SizedBox(width: 30),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: TextFormField(
                  controller: toDateController,
                  readOnly: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  decoration: const InputDecoration(
                    labelText: 'To Date',
                    labelStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    floatingLabelAlignment: FloatingLabelAlignment.center,
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 0,
                    ),
                  ),
                  onTap: () => _selectDate(context, toDateController),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      final formatted = DateFormat('dd-MM-yyyy').format(picked);
      controller.text = formatted;
      // 🔥 FIX: update actual variables
      if (controller == fromDateController) {
        fromDate = picked;
      } else {
        toDate = picked;
      }
      _onDateChanged(context);
    }
  }

  /// 🔹 Sales Card
  Widget _salesCard(SalesMaster sale) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SalesReportPreviewScreen(
                  pagefrom: 'SalesReport',
                  masterId: sale.salesMasterId.toString(),
                ),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset('assets/icons/salesreporticon1.svg'),

                  // const Icon(Icons.receipt_long, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    "#${sale.billTokenNo}",
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  SvgPicture.asset('assets/icons/salesreporticon4.svg'),
                  const SizedBox(width: 6),

                  Text(
                    DateFormat(
                      'dd-MM-yyyy',
                    ).format(DateTime.parse(sale.invoiceDate!)),
                  ),

                  const SizedBox(width: 12),
                  Visibility(
                    visible: false,
                    child: Checkbox(
                      value: false,
                      onChanged: (_) {},
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  Spacer(),
                  Visibility(
                    visible: true,
                    child: _deleteButton(sale.salesMasterId),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              /// Invoice & Time
              Row(
                children: [
                  SvgPicture.asset('assets/icons/salesreporticon2.svg'),
                  SizedBox(width: 6),
                  Text(sale.invoiceNo.toString()),
                  SizedBox(width: 68),
                  Icon(Icons.access_time, size: 16),
                  SizedBox(width: 6),
                  Text(formatTime(sale.invoiceTime.toString())),

                  // Text(sale.invoiceTime.toString()),
                ],
              ),

              const SizedBox(height: 10),

              /// Payment & Amount
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset('assets/icons/salesreporticon3.svg'),
                      SizedBox(width: 6),
                      Text(sale.salesType.toString()),
                    ],
                  ),
                  Text(
                    sale.grandTotal.toString(),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _deleteButton(int salesMasterId) {
    return InkWell(
      onTap: () async {
        final result = await showConfirmationDialog(
          context,
          heading: 'Delete Confirmation',
          message: 'Are you sure you want to delete all selected items?',
          salesMasterId: salesMasterId,
        );
        if (result == true) {
        } else {}
      },
      child: CircleAvatar(
        radius: 16,
        backgroundColor: const Color(0xffFFE08A),
        child: SvgPicture.asset('assets/icons/salesreportdeleteicon.svg'),
      ),
    );
  }

  void _calculateTotals(List<SalesMaster> list) {
    saleTotal = 0;

    for (final item in list) {
      saleTotal += double.tryParse(item.grandTotal) ?? 0;
    }

    _totalRecordsController.text = list.length.toString();
    _totalSalesController.text = saleTotal.toStringAsFixed(2);
  }

  /// 🔹 API / DB CALL
  Future<void> fetchSalesReport() async {
    final sharedPrefHelper = SharedPreferenceHelper();
    st_branchId = await sharedPrefHelper.getBranchId();
    final expiryDate = await SharedPreferenceHelper().getExpiryDate();
    print('expiryDate $expiryDate');
    context.read<SalesReportCubit>().fetchSalesReport(
      FetchReportRequest(
        fromDate: formatter.format(fromDate),
        toDate: formatter.format(toDate),
        userId: '1',
        branchId: st_branchId,
      ),
    );
  }

  Future<void> pickDate({required bool isFrom}) async {
    print('reached SalesReport');
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isFrom ? fromDate : toDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        if (isFrom) {
          fromDate = picked;
        } else {
          toDate = picked;
        }
      });
      fetchSalesReport();
    }
  }
}
