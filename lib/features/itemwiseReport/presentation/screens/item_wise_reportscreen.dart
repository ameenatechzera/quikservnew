import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/features/itemwiseReport/domain/parameters/itemwise_report_request.dart';
import 'package:quikservnew/features/itemwiseReport/presentation/bloc/item_wise_report_cubit.dart';

class ItemWiseReportPage extends StatelessWidget {
  ItemWiseReportPage({super.key});
  final DateFormat formatter = DateFormat('MM-dd-yyyy');
  final DateTime fromDate = DateTime.now();
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();
  void _onDateChanged(BuildContext context) {
    final fromDateRaw = fromDateController.text.trim();
    final toDateRaw = toDateController.text.trim();
    if (fromDateRaw.isNotEmpty && toDateRaw.isNotEmpty) {
      context.read<ItemWiseReportCubit>().fetchItemWiseReportNew(
        ItemWiseReportRequest(
          fromDate: formatter.format(fromDate),
          toDate: formatter.format(fromDate),
          branchId: "1",
        ),
      );
    }
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
      _onDateChanged(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    context.read<ItemWiseReportCubit>().fetchItemWiseReportNew(
      ItemWiseReportRequest(
        fromDate: formatter.format(fromDate),
        toDate: formatter.format(fromDate),
        branchId: "1",
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ItemWise Summary Report",
          style: TextStyle(fontSize: 18),
        ),
        backgroundColor: AppColors.theme,
      ),
      body: Column(
        children: [
          Container(
            color: AppColors.theme,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            // margin: EdgeInsets.zero,
            //height: 70,
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
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
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
                const SizedBox(width: 12),
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
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
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
          ),
          Expanded(
            child: BlocBuilder<ItemWiseReportCubit, ItemWiseReportState>(
              builder: (context, state) {
                if (state is ItemWiseReportInitial) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is ItemSaleReportFailure) {
                  return Center(child: Text(state.error));
                }

                if (state is ItemSaleReportNewLoaded) {
                  final report = state.itemWisReportNew.categories;

                  return ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: report.length,
                    itemBuilder: (context, index) {
                      String category = report.keys.elementAt(index);
                      List products = report[category]!;

                      /// Calculate category total
                      double categoryTotal = products.fold(
                        0,
                        (sum, item) => sum + double.parse(item.totalAmount),
                      );

                      return Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// CATEGORY HEADER
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  category,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  categoryTotal.toStringAsFixed(2),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            /// TABLE HEADER
                            const Row(
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: Text(
                                    "Product Name",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "Qty",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    "Total",
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const Divider(),

                            /// PRODUCT LIST
                            Column(
                              children: products.map<Widget>((item) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  child: Row(
                                    children: [
                                      /// PRODUCT NAME
                                      Expanded(
                                        flex: 5,
                                        child: Text(
                                          item.productName,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ),

                                      /// QTY
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          item.qty.toString(),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),

                                      /// TOTAL
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          item.totalAmount,
                                          textAlign: TextAlign.end,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
