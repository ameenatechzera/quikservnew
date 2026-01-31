import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:quikservnew/core/config/colors.dart';
import 'package:quikservnew/features/itemwiseReport/domain/parameters/itemwiseReportRequest.dart';
import 'package:quikservnew/features/itemwiseReport/presentation/bloc/item_wise_report_cubit.dart';
import 'package:quikservnew/services/shared_preference_helper.dart';

class ItemWiseReportScreen extends StatefulWidget {
   ItemWiseReportScreen({super.key});

  @override
  State<ItemWiseReportScreen> createState() => _ItemWiseReportScreenState();
}

class _ItemWiseReportScreenState extends State<ItemWiseReportScreen> {
  final TextEditingController fromDateController = TextEditingController();

  final TextEditingController toDateController = TextEditingController();

   DateTime fromDate = DateTime.now();

  String st_branchId ='';

   DateTime toDate = DateTime.now();
  final DateFormat formatter = DateFormat('dd MMM yyyy');


  @override
  void initState() {
    super.initState();
    fetchSalesReport();
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
    ),
      body: Column(
        children: [
          _dateFilter(),
          const SizedBox(height: 20),
          Expanded(
            child: BlocBuilder<ItemWiseReportCubit, ItemWiseReportState>(
              builder: (context, state) {

                if (state is ItemWiseReportInitial) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ItemSaleReportFailure) {
                  return Center(child: Text("Error: ${state.error}"));
                } else if (state is ItemSaleReportLoaded) {
                  print('List ${state.itemWisReport}');
                  final itemList = state.itemWisReport;
                  if (itemList.isEmpty) {
                    return const Center(child: Text("No data found."));
                  }
                  return ListView.builder(
                    itemCount: itemList.length,
                    itemBuilder: (context, index) {
                      final item = itemList[index];
                      return Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8),
                        child: Card(
                          elevation: 5,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: Column(
                            children: [
                              Container(
                                height: 40,
                                // color: Colors.amber,
                                decoration: const BoxDecoration(
                                  color: appThemeLightOrange,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(
                                        10), // match Card's default radius
                                    topRight: Radius.circular(10),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 38.0, right: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        item.productName,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        item.totalAmount,
                                        style: TextStyle(fontSize: 18),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Qty',
                                      ),
                                      Text(
                                        item.qty.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Sub',
                                      ),
                                      Text(item.subTotal,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Tax',
                                      ),
                                      Text(item.taxAmount,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(
                      child: Text("Please select date range"));
                }
              },
            ),
          ),
        ],
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

  /// 🔹 API / DB CALL
  Future<void> fetchSalesReport() async {
    final sharedPrefHelper = SharedPreferenceHelper();
    st_branchId = await sharedPrefHelper.getBranchId();

    context.read<ItemWiseReportCubit>().fetchItemWiseReport(
      ItemWiseReportRequest(
        FromDate: formatter.format(fromDate),
        ToDate: formatter.format(toDate),
        branchId: st_branchId,
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
}


