import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:quikservnew/features/salesReport/domain/entities/salesReportResult.dart';
import 'package:quikservnew/features/salesReport/domain/parameters/salesReport_request_parameter.dart';
import 'package:quikservnew/features/salesReport/presentation/bloc/sles_report_cubit.dart';
import 'package:quikservnew/features/salesReport/presentation/screens/salesReportPreviewScreen.dart';
import 'package:quikservnew/features/salesReport/presentation/screens/sales_report_preview_screen.dart';
import 'package:quikservnew/services/shared_preference_helper.dart';

class SalesReportScreen extends StatefulWidget {
  const SalesReportScreen({super.key});

  @override
  State<SalesReportScreen> createState() => _SalesReportScreenState();
}

class _SalesReportScreenState extends State<SalesReportScreen> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  List<SalesMaster> salesList = [];

  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final DateFormat displayDate = DateFormat('dd-MM-yyyy');

  String st_branchId = '';

  final _totalRecordsController = TextEditingController();
  final _totalSalesController = TextEditingController();
  final _fromDateFormattedController = TextEditingController();
  final _toDateFormattedController = TextEditingController();

  double saleTotal = 0;

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

  void _calculateTotals(List<SalesMaster> list) {
    saleTotal = 0;

    for (final item in list) {
      saleTotal += double.tryParse(item.grandTotal) ?? 0;
    }

    _totalRecordsController.text = list.length.toString();
    _totalSalesController.text = saleTotal.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sales Report')),
      body: Column(
        children: [
          /// 🔹 DATE SELECTION
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: dateCard(
                    "From Date",
                    fromDate,
                    () => pickDate(isFrom: true),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: dateCard(
                    "To Date",
                    toDate,
                    () => pickDate(isFrom: false),
                  ),
                ),
              ],
            ),
          ),

          /// 🔹 SALES LIST
          Expanded(
            child: BlocConsumer<SalesReportCubit, SlesReportState>(
              listener: (context, state) {
                if (state is SalesReportSuccess) {
                  //setState(() {
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
                if (state is SalesReportSuccess) {
                  return ListView.builder(
                    itemCount: salesList.length,
                    itemBuilder: (context, index) {
                      final sale = salesList[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      salesReportPreviewScreen(
                                        st_fromDate:
                                            _fromDateFormattedController.text
                                                .toString(),
                                        st_toDate: _toDateFormattedController
                                            .text
                                            .toString(),
                                        pagefrom: 'SalesReport',
                                        masterId: salesList[0].salesMasterId
                                            .toString(),
                                      ),
                              transitionsBuilder:
                                  (
                                    context,
                                    animation,
                                    secondaryAnimation,
                                    child,
                                  ) {
                                    const begin = Offset(1.0, 0.0);
                                    const end = Offset.zero;
                                    const curve = Curves.ease;

                                    var tween = Tween(
                                      begin: begin,
                                      end: end,
                                    ).chain(CurveTween(curve: curve));

                                    return SlideTransition(
                                      position: animation.drive(tween),
                                      child: child,
                                    );
                                  },
                            ),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          child: ListTile(
                            title: Text("Invoice: ${sale.invoiceNo}"),
                            subtitle: Text(
                              "Date: ${displayDate.format(DateTime.parse(sale.createdDate!))}",
                            ),
                            trailing: Text(
                              "₹${sale.grandTotal}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return ListView.builder(
                    itemCount: salesList.length,
                    itemBuilder: (context, index) {
                      final sale = salesList[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: ListTile(
                          title: Text("Invoice: ${sale.invoiceNo}"),
                          subtitle: Text(
                            "Date: ${displayDate.format(DateTime.parse(sale.createdDate!))}",
                          ),
                          trailing: Text(
                            "₹${sale.grandTotal}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
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
