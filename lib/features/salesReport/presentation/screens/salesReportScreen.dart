import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:quikservnew/features/sale/presentation/widgets/dashboard_content.dart';
import 'package:quikservnew/features/salesReport/domain/parameters/salesReport_request_parameter.dart';
import 'package:quikservnew/features/salesReport/presentation/bloc/sles_report_cubit.dart';

import 'package:quikservnew/features/salesReport/domain/entities/salesReportResult.dart';
import 'package:quikservnew/features/salesReport/presentation/screens/salesReportPreviewScreen.dart';
import 'package:quikservnew/features/salesReport/presentation/widgets/deleteConfirmationDialogue.dart';
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
String st_branchId = '';
DateTime fromDate = DateTime.now();
DateTime toDate = DateTime.now();

class _SalesReportPageNEWState extends State<SalesReportPage> {
  @override
  void initState() {
    super.initState();
    fetchSalesReport();
  }

  @override
  void dispose() {
    _totalRecordsController.dispose();
    _totalSalesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          "Sales Report",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          Visibility(
            visible: false,
            child: Row(
              children: [
                Checkbox(
                  value: false,
                  onChanged: (_) {},
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const Text("Select All", style: TextStyle(color: Colors.black)),
                const SizedBox(width: 8),
                _deleteButton(0),
                const SizedBox(width: 12),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _dateFilter(),
            const SizedBox(height: 16),
            BlocConsumer<SalesReportCubit, SlesReportState>(
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
                      from_date: formatter.format(fromDate),
                      to_date: formatter.format(toDate),
                      user_id: '1',
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
                  //setState(() {
                  salesList.clear();
                  salesList = state.response.salesMaster;
                  print('salesList ${salesList}');
                  _calculateTotals(salesList);
                  //});
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
          ],
        ),
      ),
    );
  }

  /// 🔹 Date Filter
  Widget _dateFilter() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xffFFF4CC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _dateBox(
              "From Date",
              fromDate,
              () => pickDate(isFrom: true),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _dateBox("To Date", toDate, () => pickDate(isFrom: false)),
          ),
        ],
      ),
    );
  }

  Widget _dateBox(String label, DateTime? date, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 6),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    date == null
                        ? "Select Date"
                        : "${date.day.toString().padLeft(2, '0')}-"
                              "${date.month.toString().padLeft(2, '0')}-"
                              "${date.year}",
                  ),
                ),
                const Icon(Icons.calendar_today_outlined, size: 18),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// 🔹 Sales Card
  Widget _salesCard(SalesMaster sale) {
    // final DateFormat formatter = DateFormat('dd MMM yyyy');

    return Container(
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
              builder: (context) => salesReportPreviewScreen(
                pagefrom: 'SalesReport',
                masterId: sale.salesMasterId.toString(),
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Top Row
            Row(
              children: [
                const Icon(Icons.receipt_long, size: 18),
                const SizedBox(width: 6),
                Text(
                  "#${sale.billTokenNo}",
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.calendar_today_outlined, size: 16),
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
                Icon(Icons.confirmation_number_outlined, size: 16),
                SizedBox(width: 6),
                Text(sale.invoiceNo.toString()),
                SizedBox(width: 16),
                Icon(Icons.access_time, size: 16),
                SizedBox(width: 6),
                Text(sale.invoiceTime.toString()),
              ],
            ),

            const SizedBox(height: 10),

            /// Payment & Amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.payments_outlined, size: 18),
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
        child: const Icon(Icons.delete_outline, size: 18, color: Colors.black),
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
    context.read<SalesReportCubit>().fetchSalesReport(
      FetchReportRequest(
        from_date: formatter.format(fromDate),
        to_date: formatter.format(toDate),
        user_id: '1',
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
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
