import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:quikservnew/core/theme/colors.dart';
import 'package:quikservnew/features/itemwiseReport/domain/parameters/itemwise_report_request.dart';
import 'package:quikservnew/features/itemwiseReport/presentation/bloc/item_wise_report_cubit.dart';
import 'package:quikservnew/features/sale/presentation/widgets/scroll_supportings.dart';
import 'package:quikservnew/services/shared_preference_helper.dart';
import 'package:share_plus/share_plus.dart';

class ItemWiseReportPage extends StatelessWidget {
  ItemWiseReportPage({super.key});
  final DateFormat formatter = DateFormat('MM-dd-yyyy');
  final DateTime fromDate = DateTime.now();
  final TextEditingController fromDateController = TextEditingController(
    text: DateFormat('dd-MM-yyyy').format(DateTime.now()),
  );

  final TextEditingController toDateController = TextEditingController(
    text: DateFormat('dd-MM-yyyy').format(DateTime.now()),
  );
  // void _onDateChanged(BuildContext context) {
  //   final fromDateRaw = fromDateController.text.trim();
  //   final toDateRaw = toDateController.text.trim();
  //   if (fromDateRaw.isNotEmpty && toDateRaw.isNotEmpty) {
  //     context.read<ItemWiseReportCubit>().fetchItemWiseReportNew(
  //       ItemWiseReportRequest(
  //         fromDate: formatter.format(fromDate),
  //         toDate: formatter.format(fromDate),
  //         branchId: "1",
  //       ),
  //     );
  //   }
  // }
  void _onDateChanged(BuildContext context) {
    final fromDateRaw = fromDateController.text.trim();
    final toDateRaw = toDateController.text.trim();

    if (fromDateRaw.isNotEmpty && toDateRaw.isNotEmpty) {
      final fromDate = DateFormat('dd-MM-yyyy').parse(fromDateRaw);
      final toDate = DateFormat('dd-MM-yyyy').parse(toDateRaw);

      context.read<ItemWiseReportCubit>().fetchItemWiseReportNew(
        ItemWiseReportRequest(
          fromDate: formatter.format(fromDate),
          toDate: formatter.format(toDate),
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

  Widget footerTotalSection({
    required double totalQty,
    required double totalAmount,
  }) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.account_balance_wallet_rounded,
            color: Color(0xFFFFE08A),
            size: 28,
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Total Sales',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                // SizedBox(height: 2),
                // Text(
                //   'All Categories',
                //   style: TextStyle(color: Colors.white38, fontSize: 11),
                // ),
              ],
            ),
          ),

          Container(height: 40, width: 1, color: Colors.white24),

          const SizedBox(width: 16),

          Text(
            totalAmount.toStringAsFixed(2),
            style: const TextStyle(
              color: Color(0xFFFFE08A),
              fontSize: 26,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
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
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () async {
              final state = context.read<ItemWiseReportCubit>().state;

              if (state is ItemSaleReportNewLoaded) {
                await generateAndSharePdf(
                  context,
                  state.itemWisReportNew.categories,
                  fromDateController.text,
                  toDateController.text,
                );
              }
            },
          ),
        ],
        // actions: [IconButton(onPressed: () {}, icon: Icon(Icons.share))],
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
                          contentPadding: EdgeInsets.symmetric(
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
                  double grandTotalQty = 0;
                  double grandTotalAmount = 0;

                  for (var products in report.values) {
                    for (var item in products) {
                      grandTotalQty +=
                          double.tryParse(item.qty.toString()) ?? 0;

                      grandTotalAmount +=
                          double.tryParse(item.totalAmount.toString()) ?? 0;
                    }
                  }
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          physics: const SoftBounceScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics(),
                          ),
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          itemCount: report.length,
                          itemBuilder: (context, index) {
                            String category = report.keys.elementAt(index);
                            List products = report[category]!;

                            /// Calculate category total
                            double categoryTotal = products.fold(
                              0,
                              (sum, item) =>
                                  sum + double.parse(item.totalAmount),
                            );
                            double categoryQty = products.fold(
                              0.0,
                              (sum, item) =>
                                  sum +
                                  (double.tryParse(item.qty.toString()) ?? 0),
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
                                  // Row(
                                  //   mainAxisAlignment:
                                  //       MainAxisAlignment.spaceBetween,
                                  //   children: [
                                  //     Text(
                                  //       category,
                                  //       style: const TextStyle(
                                  //         fontSize: 20,
                                  //         fontWeight: FontWeight.bold,
                                  //       ),
                                  //     ),
                                  //     Text(
                                  //       categoryTotal.toStringAsFixed(2),
                                  //       style: const TextStyle(
                                  //         fontSize: 20,
                                  //         fontWeight: FontWeight.bold,
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 5,
                                        child: Text(
                                          category,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),

                                      Expanded(
                                        // flex: 5,
                                        child: Text(
                                          categoryQty.toStringAsFixed(0),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            //color: Colors.blue,
                                          ),
                                        ),
                                      ),

                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          categoryTotal.toStringAsFixed(2),
                                          textAlign: TextAlign.end,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
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
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
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
                        ),
                      ),
                      footerTotalSection(
                        totalQty: grandTotalQty,
                        totalAmount: grandTotalAmount,
                      ),
                    ],
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

  Future<void> generateAndSharePdf(
    BuildContext context,
    Map<String, dynamic> report,
    String fromDate,
    String toDate,
  ) async {
    final pdf = pw.Document();

    final logoBytes = await rootBundle.load('assets/images/bw_printlogo.png');

    final logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());
    final companyName = await SharedPreferenceHelper().getCompanyName() ?? '';

    final companyPhone =
        await SharedPreferenceHelper().getCompanyPhoneNo() ?? '';

    final companyLogo = await SharedPreferenceHelper().getCompanyLogo() ?? '';
    final companyAddress =
        await SharedPreferenceHelper().getCompanyAddress1() ?? '';
    final companyAddress2 =
        await SharedPreferenceHelper().getCompanyAddress2() ?? '';
    final walletBytes = await rootBundle.load('assets/icons/wallet.png');

    final walletIcon = pw.MemoryImage(walletBytes.buffer.asUint8List());
    double grandTotalQty = 0;
    double grandTotalAmount = 0;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),

        footer: (context) {
          return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 10),
            child: pw.Text(
              'Page ${context.pageNumber} of ${context.pagesCount}',
              style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
            ),
          );
        },

        build: (context) {
          List<pw.Widget> widgets = [];

          widgets.add(
            pw.Container(
              padding: const pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey300),
                borderRadius: pw.BorderRadius.circular(12),
              ),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  /// LOGO LEFT
                  pw.Image(
                    logoImage,
                    width: 80,
                    height: 80,
                    fit: pw.BoxFit.contain,
                  ),

                  pw.SizedBox(width: 15),

                  /// COMPANY DETAILS CENTER
                  pw.Expanded(
                    child: pw.Center(
                      child: pw.Column(
                        mainAxisSize: pw.MainAxisSize.min,
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                          pw.Text(
                            companyName,
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontSize: 22,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),

                          pw.SizedBox(height: 4),

                          pw.Text(
                            companyAddress,
                            textAlign: pw.TextAlign.center,
                            style: const pw.TextStyle(fontSize: 10),
                          ),

                          pw.Text(
                            companyAddress2,
                            textAlign: pw.TextAlign.center,
                            style: const pw.TextStyle(fontSize: 10),
                          ),

                          pw.Text(
                            companyPhone,
                            textAlign: pw.TextAlign.center,
                            style: const pw.TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// BALANCER (optional)
                  pw.SizedBox(width: 95),
                ],
              ),
            ),
          );

          /// ==========================
          /// CATEGORYS
          /// ==========================
          report.forEach((category, products) {
            double categoryTotal = 0;
            double categoryQty = 0;

            for (var item in products) {
              categoryTotal +=
                  double.tryParse(item.totalAmount.toString()) ?? 0;

              categoryQty += double.tryParse(item.qty.toString()) ?? 0;

              grandTotalQty += double.tryParse(item.qty.toString()) ?? 0;

              grandTotalAmount +=
                  double.tryParse(item.totalAmount.toString()) ?? 0;
            }

            widgets.add(
              pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 18),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: pw.BorderRadius.circular(10),
                ),
                child: pw.Column(
                  children: [
                    /// CATEGORY HEADER
                    pw.Container(
                      padding: const pw.EdgeInsets.all(10),
                      decoration: const pw.BoxDecoration(
                        color: PdfColors.grey200,
                      ),
                      child: pw.Row(
                        children: [
                          pw.Expanded(
                            flex: 4,
                            child: pw.Text(
                              category,
                              style: pw.TextStyle(
                                fontSize: 13,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),

                          pw.Expanded(
                            child: pw.Text(
                              categoryQty.toStringAsFixed(0),
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),

                          pw.Expanded(
                            flex: 2,
                            child: pw.Text(
                              categoryTotal.toStringAsFixed(2),
                              textAlign: pw.TextAlign.right,
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// TABLE HEADER
                    pw.Container(
                      padding: const pw.EdgeInsets.all(8),
                      color: PdfColors.grey100,
                      child: pw.Row(
                        children: [
                          pw.Expanded(
                            flex: 6,
                            child: pw.Text(
                              "Product Name",
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),

                          pw.Expanded(
                            flex: 2,
                            child: pw.Text(
                              "Qty",
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),

                          pw.Expanded(
                            flex: 3,
                            child: pw.Text(
                              "Total",
                              textAlign: pw.TextAlign.right,
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    ...products.map<pw.Widget>((item) {
                      return pw.Container(
                        padding: const pw.EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        child: pw.Row(
                          children: [
                            pw.Expanded(
                              flex: 6,
                              child: pw.Text(
                                item.productName.toString(),
                                style: const pw.TextStyle(fontSize: 10),
                              ),
                            ),

                            pw.Expanded(
                              flex: 2,
                              child: pw.Text(
                                item.qty.toString(),
                                textAlign: pw.TextAlign.center,
                              ),
                            ),

                            pw.Expanded(
                              flex: 3,
                              child: pw.Text(
                                item.totalAmount.toString(),
                                textAlign: pw.TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            );
          });

          /// ==========================
          /// GRAND TOTAL
          /// ==========================
          widgets.add(
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(18),
              decoration: pw.BoxDecoration(
                color: PdfColors.black,
                borderRadius: pw.BorderRadius.circular(12),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Row(
                    children: [
                      pw.Image(walletIcon, width: 18, height: 18),
                      pw.SizedBox(width: 6),
                      pw.Text(
                        "Grand Total Amount",
                        style: const pw.TextStyle(color: PdfColors.white),
                      ),
                    ],
                  ),

                  pw.Text(
                    "$grandTotalAmount",
                    style: pw.TextStyle(
                      color: PdfColors.amber,
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );

          return widgets;
        },
      ),
    );

    // final dir = await getTemporaryDirectory();

    // final file = File(
    //   '${dir.path}/ItemWiseReport_${DateTime.now().millisecondsSinceEpoch}.pdf',
    // );

    // await file.writeAsBytes(await pdf.save());

    // await Share.shareXFiles([
    //   XFile(file.path),
    // ], text: 'ItemWise Summary Report');
    final dir = await getTemporaryDirectory();

    final fileName = 'ItemWiseReport_${fromDate}_to_${toDate}.pdf';

    final file = File('${dir.path}/$fileName');

    await file.writeAsBytes(await pdf.save());

    await Share.shareXFiles(
      [XFile(file.path)],
      subject: 'ItemWise Summary Report',
      text:
          '''
ItemWise Summary Report

From : $fromDate
To      : $toDate
''',
    );
  }
}
