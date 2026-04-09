import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:quikservnew/features/salesReport/domain/entities/salesdetails_bymasterid_result.dart';
import 'package:share_plus/share_plus.dart';
import 'package:quikservnew/services/shared_preference_helper.dart';

class SalesPreviewPdfHelper {
  ///  MAIN METHOD
  static Future<void> createPdf(SalesDetailsByMasterIdResult sales) async {
    final pdf = pw.Document();

    /// ---------------- DATA ----------------
    final billDate = _formatDate(sales.salesMaster!.invoiceDate.toString());

    final billTime = _formatBillTime(sales.salesMaster!.invoiceTime.toString());

    final customerName = sales.salesMaster!.ledgerName;
    final tokenNo = sales.salesMaster!.billTokenNo.toString();

    double totalQty = 0;
    for (final item in sales.salesDetails) {
      totalQty += double.tryParse(item.qty.toString()) ?? 0;
    }

    final subTotal =
        double.tryParse(sales.salesMaster!.subTotal.toString()) ?? 0;

    final tax = double.tryParse(sales.salesMaster!.vatAmount.toString()) ?? 0;

    final discount =
        double.tryParse(sales.salesMaster!.discountAmount.toString()) ?? 0;

    final grandTotal =
        double.tryParse(sales.salesMaster!.grandTotal.toString()) ?? 0;

    final vatEnabled = await SharedPreferenceHelper().getVatStatus();

    final vatType = (await SharedPreferenceHelper().getVatType()).toLowerCase();

    double sgst = 0;
    double cgst = 0;

    if (vatEnabled == true && vatType == 'gst') {
      sgst = tax / 2;
      cgst = tax / 2;
    }

    /// ---------------- UI ----------------
    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(8), // same as UI
        build: (context) => [
          ///  TOP CARD
          _card(
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text("Bill Date: $billDate", style: _bold()),
                    pw.Text("Time: $billTime", style: _bold()),
                  ],
                ),
                pw.SizedBox(height: 8),

                pw.Row(
                  children: [
                    pw.Text("Customer Name:", style: _semiBold()),
                    pw.SizedBox(width: 4),
                    pw.Text(customerName),
                  ],
                ),

                pw.SizedBox(height: 8),

                pw.Row(
                  children: [
                    pw.Text("TokenNo:", style: _semiBold()),
                    pw.SizedBox(width: 4),
                    pw.Text(tokenNo),
                  ],
                ),
              ],
            ),
          ),

          /// 🔶 ITEMS CARD
          _card(
            pw.Column(
              children: [
                /// HEADER
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Row(
                    children: [
                      _flex("Sl", 1, bold: true),
                      _flex("Barcode", 3, bold: true),
                      _flex("Qty", 1, bold: true),
                      _flex("Rate", 1, bold: true),
                      _flex("Total", 1, bold: true, right: true),
                    ],
                  ),
                ),

                pw.Divider(),

                /// ITEMS
                ...List.generate(sales.salesDetails.length, (index) {
                  final data = sales.salesDetails[index];

                  String qty = "0";
                  String rate = "0";
                  String total = "0";

                  try {
                    qty = double.parse(data.qty.toString()).toStringAsFixed(2);
                  } catch (_) {}

                  try {
                    rate = double.parse(
                      data.salesRate.toString(),
                    ).toStringAsFixed(2);
                  } catch (_) {}

                  try {
                    double q = double.parse(data.qty.toString());
                    double r = double.parse(data.salesRate.toString());
                    total = (q * r).toStringAsFixed(2);
                  } catch (_) {}

                  return pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    child: pw.Row(
                      children: [
                        _flex("${index + 1}", 1),
                        _flex(data.productName, 3),
                        _flex("$qty-${data.unitName}", 1),
                        _flex(rate, 1),
                        _flex(total, 1, right: true),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),

          ///  TOTAL CARD
          _card(
            pw.Column(
              children: [
                _row("Total Qty", totalQty.toStringAsFixed(2)),
                _row("Sub Total", subTotal.toStringAsFixed(2)),

                if (vatEnabled == true && vatType == 'gst') ...[
                  _row("SGST", sgst.toStringAsFixed(2)),
                  _row("CGST", cgst.toStringAsFixed(2)),
                ] else if (vatEnabled == true && vatType.isNotEmpty)
                  _row("Tax Amount", tax.toStringAsFixed(2)),

                _row("Discount", discount.toStringAsFixed(2)),
                pw.Divider(),
                _row("Grand Total", grandTotal.toStringAsFixed(2), bold: true),
              ],
            ),
          ),
        ],
      ),
    );

    final dir = await getTemporaryDirectory();
    final file = File("${dir.path}/bill_preview_$tokenNo.pdf");

    await file.writeAsBytes(await pdf.save());

    await Share.shareXFiles([XFile(file.path)]);
  }

  /// ---------------- HELPERS ----------------

  static pw.Widget _card(pw.Widget child) {
    return pw.Container(
      margin: const pw.EdgeInsets.all(8),
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        borderRadius: pw.BorderRadius.circular(8),
        border: pw.Border.all(color: PdfColors.grey400),
      ),
      child: child,
    );
  }

  static pw.Widget _flex(
    String text,
    int flex, {
    bool bold = false,
    bool right = false,
  }) {
    return pw.Expanded(
      flex: flex,
      child: pw.Text(
        text,
        textAlign: right ? pw.TextAlign.right : pw.TextAlign.left,
        style: pw.TextStyle(
          fontSize: 10,
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  static pw.Widget _row(String label, String value, {bool bold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  static pw.TextStyle _bold() => pw.TextStyle(fontWeight: pw.FontWeight.bold);

  static pw.TextStyle _semiBold() =>
      pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11);

  /// ---------------- DATE ----------------
  static String _formatDate(String dateStr) {
    try {
      return DateFormat('dd-MM-yyyy').format(DateTime.parse(dateStr));
    } catch (_) {
      return dateStr;
    }
  }

  /// ---------------- TIME ----------------
  static String _formatBillTime(String rawTime) {
    try {
      return DateFormat(
        'hh:mm a',
      ).format(DateFormat('HH:mm:ss').parse(rawTime));
    } catch (_) {
      try {
        return DateFormat('hh:mm a').format(DateFormat('HH:mm').parse(rawTime));
      } catch (_) {
        return rawTime;
      }
    }
  }
}
