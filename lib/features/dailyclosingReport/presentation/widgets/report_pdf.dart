import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:quikservnew/features/dailyclosingReport/domain/entities/dailyclosingreport_result.dart';
import 'package:quikservnew/features/itemwiseReport/domain/entities/itemwise_report_response.dart';
import 'package:share_plus/share_plus.dart';

String formatDateString(String inputDate) {
  DateTime parsedDate = DateTime.parse(inputDate);
  String formattedDate = DateFormat('dd-MM-yyyy').format(parsedDate);
  return formattedDate;
}

Future<void> shareDailyClosingReport({
  required String dateText,
  required String salesTotal,
  required String expenseTotal,
  required String cashBalance,
  required String bankBalance,
  required String salesTotalItemWise,
  required List<SummaryReports> summaryList,
  required List<ExpenseDetail> expenseList,
  required List<SummaryReport> itemsList,
}) async {
  try {
    final pdf = pw.Document();

    final PdfColor headerColor = PdfColor.fromHex('#FFF4CC');
    final PdfColor borderColor = PdfColor.fromHex('#E0E0E0');
    final PdfColor redColor = PdfColor.fromHex('#D32F2F');
    final PdfColor textColor = PdfColors.black;
    final PdfColor subTextColor = PdfColor.fromHex('#666666');

    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.fromLTRB(16, 14, 16, 14),
        build: (pw.Context context) {
          return [
            /// Title
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.symmetric(vertical: 8),
              child: pw.Center(
                child: pw.Text(
                  "DAILY CLOSING REPORT",
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
            ),

            /// Date bar
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 7,
              ),
              decoration: pw.BoxDecoration(
                color: headerColor,
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Center(
                child: pw.Text(
                  formatDateString(dateText),
                  style: pw.TextStyle(
                    fontSize: 13,
                    fontWeight: pw.FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
            ),

            pw.SizedBox(height: 10),

            /// Sales summary card
            _buildPdfCard(
              borderColor: borderColor,
              child: pw.Column(
                children: [
                  _buildPdfSectionHeader(
                    title: 'Sales Total',
                    value: salesTotal,
                    headerColor: headerColor,
                  ),
                  _buildPdfAmountRow(
                    'Cash',
                    salesTotal == ''
                        ? '0.00'
                        : _getSummaryAmount(summaryList, 'cash'),
                  ),
                  _buildPdfAmountRow(
                    'Card',
                    salesTotal == ''
                        ? '0.00'
                        : _getSummaryAmount(summaryList, 'card'),
                  ),
                  _buildPdfAmountRow(
                    'Credit',
                    salesTotal == ''
                        ? '0.00'
                        : _getSummaryAmount(summaryList, 'credit'),
                  ),

                  pw.SizedBox(height: 4),

                  _buildPdfSectionHeader(
                    title: 'Expense Total',
                    value: expenseTotal,
                    headerColor: headerColor,
                    isTopSection: false,
                  ),

                  ...expenseList.map(
                    (expense) =>
                        _buildPdfAmountRow(expense.ledgerName, expense.amount),
                  ),

                  pw.SizedBox(height: 4),

                  pw.Padding(
                    padding: const pw.EdgeInsets.only(top: 4, bottom: 4),
                    child: pw.Center(
                      child: pw.Text(
                        'Balance',
                        style: pw.TextStyle(
                          fontSize: 15,
                          fontWeight: pw.FontWeight.bold,
                          color: redColor,
                        ),
                      ),
                    ),
                  ),

                  _buildPdfAmountRow('Cash', cashBalance),
                  _buildPdfAmountRow('Card', bankBalance),
                ],
              ),
            ),

            pw.SizedBox(height: 10),

            /// Product wise card
            _buildPdfCard(
              borderColor: borderColor,
              child: pw.Column(
                children: [
                  _buildPdfSectionHeader(
                    title: 'Product Wise',
                    value: salesTotalItemWise,
                    headerColor: headerColor,
                  ),

                  ...itemsList.map(
                    (item) => pw.Container(
                      width: double.infinity,
                      padding: const pw.EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: const pw.BoxDecoration(
                        border: pw.Border(
                          bottom: pw.BorderSide(
                            color: PdfColors.grey300,
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            item.productName,
                            softWrap: true,
                            style: pw.TextStyle(
                              fontSize: 12,
                              fontWeight: pw.FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          pw.SizedBox(height: 4),
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              _buildPdfMiniColumn(
                                label: 'Qty',
                                value: item.qty.toString(),
                                subTextColor: subTextColor,
                              ),
                              _buildPdfMiniColumn(
                                label: 'Sub',
                                value: item.subTotal,
                                subTextColor: subTextColor,
                              ),
                              _buildPdfMiniColumn(
                                label: 'Tax',
                                value: item.taxAmount,
                                subTextColor: subTextColor,
                              ),
                              _buildPdfMiniColumn(
                                label: 'Total',
                                value: item.totalAmount.toString(),
                                subTextColor: subTextColor,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            if (itemsList.isEmpty && summaryList.isEmpty)
              pw.Padding(
                padding: const pw.EdgeInsets.only(top: 14),
                child: pw.Center(
                  child: pw.Text(
                    "No data found.",
                    style: pw.TextStyle(fontSize: 12, color: subTextColor),
                  ),
                ),
              ),
          ];
        },
      ),
    );

    final directory = await getTemporaryDirectory();
    final file = File("${directory.path}/daily_closing_report.pdf");
    await file.writeAsBytes(await pdf.save());

    await Share.shareXFiles([XFile(file.path)], text: "Daily Closing Report");
  } catch (e) {
    debugPrint("Share error: $e");
  }
}

pw.Widget _buildPdfCard({
  required pw.Widget child,
  required PdfColor borderColor,
}) {
  return pw.Container(
    width: double.infinity,
    decoration: pw.BoxDecoration(
      color: PdfColors.white,
      borderRadius: pw.BorderRadius.circular(10),
      border: pw.Border.all(color: borderColor, width: 0.7),
    ),
    child: child,
  );
}

pw.Widget _buildPdfSectionHeader({
  required String title,
  required String value,
  required PdfColor headerColor,
  bool isTopSection = true,
}) {
  return pw.Container(
    width: double.infinity,
    padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: pw.BoxDecoration(
      color: headerColor,
      borderRadius: isTopSection
          ? const pw.BorderRadius.only(
              topLeft: pw.Radius.circular(10),
              topRight: pw.Radius.circular(10),
            )
          : null,
    ),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Expanded(
          child: pw.Text(
            title,
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
        ),
        pw.SizedBox(width: 8),
        pw.Text(
          value,
          style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
        ),
      ],
    ),
  );
}

pw.Widget _buildPdfAmountRow(String title, String amount) {
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          flex: 3,
          child: pw.Text(
            title,
            softWrap: true,
            style: const pw.TextStyle(fontSize: 12),
          ),
        ),
        pw.SizedBox(width: 8),
        pw.Expanded(
          flex: 2,
          child: pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text(
              amount,
              textAlign: pw.TextAlign.right,
              style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
            ),
          ),
        ),
      ],
    ),
  );
}

pw.Widget _buildPdfMiniColumn({
  required String label,
  required String value,
  required PdfColor subTextColor,
}) {
  return pw.Expanded(
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(label, style: pw.TextStyle(fontSize: 10, color: subTextColor)),
        pw.SizedBox(height: 1),
        pw.Text(
          value,
          softWrap: true,
          style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
        ),
      ],
    ),
  );
}

String _getSummaryAmount(List<SummaryReports> summaryList, String type) {
  if (summaryList.isEmpty) return '0.00';

  final payment = summaryList.first;

  switch (type.toLowerCase()) {
    case 'cash':
      return payment.cashAmount;
    case 'card':
      return payment.cardAmount;
    case 'credit':
      return payment.creditAmount;
    default:
      return '0.00';
  }
}
