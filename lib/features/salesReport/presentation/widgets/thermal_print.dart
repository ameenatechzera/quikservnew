import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';
import 'package:quikservnew/features/salesReport/domain/entities/salesdetails_bymasterid_result.dart';
import 'package:quikservnew/features/salesReport/presentation/screens/salesreport_preview_screen.dart';

import 'package:quikservnew/services/shared_preference_helper.dart';


/// Wraps [text] into lines no longer than [maxChars], breaking on spaces
/// where possible so words aren't split mid-way. Falls back to a hard
/// break only if a single word is longer than [maxChars].
String companyNameFontSize ='';
bool vatStatus = false;
List<String> _wordWrap(String text, int maxChars) {
  if (text.isEmpty) return [''];
  final words = text.split(' ');
  final lines = <String>[];
  var current = '';
  for (final word in words) {
    final candidate = current.isEmpty ? word : '$current $word';
    if (candidate.length <= maxChars) {
      current = candidate;
    } else {
      if (current.isNotEmpty) lines.add(current);
      if (word.length > maxChars) {
        // Hard-break an overly long single word.
        var remaining = word;
        while (remaining.length > maxChars) {
          lines.add(remaining.substring(0, maxChars));
          remaining = remaining.substring(maxChars);
        }
        current = remaining;
      } else {
        current = word;
      }
    }
  }
  if (current.isNotEmpty) lines.add(current);
  return lines;
}

class ThermalPrinterService_3inches {

  Future<List<int>> generateReceipt(String st_companyLogo, SalesDetailsByMasterIdResult? sales, {

    String? logoUrl = 'https://example.com/logo.png', // <-- put your logo URL here
  }) async {
    List<int> bytes = [];

    final profile = await CapabilityProfile.load();
    const paperSize = PaperSize.mm80; // 3 inch printer
    final generator = Generator(paperSize, profile);
    final vatEnableStatus = await SharedPreferenceHelper().getVatStatus();
    if(vatEnableStatus){
      vatStatus = true;
    }
    else{
      vatStatus = false;
    }
    final st_userName = await SharedPreferenceHelper().getStaffName();
    print('vatStatus$vatStatus');
    // ---------- LOGO (top center) ----------

    if (st_companyLogo != null && st_companyLogo.isNotEmpty) {
      try {
        final response = await http.get(Uri.parse(st_companyLogo));
        if (response.statusCode == 200) {
          img.Image? decodedImage = img.decodeImage(
            Uint8List.fromList(response.bodyBytes),
          );
          if (decodedImage != null) {
            // Derive the real printable width from the paper size the
            // generator was actually configured with — don't hardcode
            // a single value, since 58mm/2" and 80mm/3" printers differ.
            // 80mm/3" printers are ~576 dots wide at 203dpi.
            final int printerWidthDots = switch (paperSize) {
              PaperSize.mm58 => 384,
              PaperSize.mm80 => 576,
              _ => 576, // safe default if unknown
            };

            // Practical display size for a logo — scale relative to the
            // actual paper width so it doesn't dominate the receipt.
            final int maxLogoWidth = (printerWidthDots * 0.45).round();
            const int maxLogoHeight = 220;

            // Scale down by whichever dimension is more constraining,
            // preserving aspect ratio. Only shrink — never upscale a
            // small logo bigger than its original size.
            double scale = 1.0;
            if (decodedImage.width > maxLogoWidth) {
              scale = maxLogoWidth / decodedImage.width;
            }
            if (decodedImage.height * scale > maxLogoHeight) {
              scale = maxLogoHeight / decodedImage.height;
            }

            if (scale < 1.0) {
              final int targetWidth = (decodedImage.width * scale).round();
              final int targetHeight = (decodedImage.height * scale).round();
              decodedImage = img.copyResize(
                decodedImage,
                width: targetWidth,
                height: targetHeight,
              );
            }

            // Some printer/driver combos ignore the `align` flag for raster
            // images (it only reliably works for text). To guarantee true
            // centering regardless of that, paste the logo onto a full
            // paper-width white canvas, centered horizontally, then print
            // that canvas — it's centered by construction either way.
            final canvas = img.Image(width: printerWidthDots, height: decodedImage.height);
            img.fill(canvas, color: img.ColorRgb8(255, 255, 255));
            final int xOffset = ((printerWidthDots - decodedImage.width) / 2).round();
            img.compositeImage(canvas, decodedImage, dstX: xOffset, dstY: 0);

            bytes += generator.image(canvas, align: PosAlign.center);
          }
        }
      } catch (e) {
        // If the logo fails to load/decode, skip it silently so the
        // rest of the receipt still prints.
      }
    }
    String st_company ='',st_companyAddress='',st_companyPhone='' , footer_description ='';
    st_company = await SharedPreferenceHelper().getCompanyName() ?? "";
    st_companyAddress =
        await SharedPreferenceHelper().getCompanyAddress1() ?? "";
    st_companyPhone = await SharedPreferenceHelper().getCompanyPhoneNo() ?? "";
    footer_description = (await SharedPreferenceHelper().fetchDescriptionPrint())!;

    String formatted ='' , formattedTime='';
    try {
      formatted = DateFormat('dd-MM-yyyy').format(
          DateTime.parse(sales!.salesMaster!.invoiceDate!));
    }catch(_){
      print('Date_conversionError');
    }
    try{
      formattedTime = formatTo12Hour(sales!.salesMaster!.invoiceTime);
    }catch(_){
      print('Time_conversionError');
    }
    // ---------- HEADER ----------
    // At double width (size2) an 80mm/3" printer fits roughly half as many
    // characters per line as normal text (~24 instead of ~48, vs ~16/~32
    // on 58mm/2" paper). Wrap the company name to that width ourselves and
    // join with \n in a single text() call, so every line — including
    // wrapped ones — stays centered.
    final List<String> st_companyLines = _wordWrap(st_company, 24);
    // Company name — split into individual lines so each one gets its own
// centering calculation. Passing a single string with embedded '\n'
// only centers the first line correctly, especially at size2 (double
// width) where the character budget per line is much smaller — long
// lines wrap and the wrapped remainder isn't centered.
    for (final line in st_companyLines) {
      if (line.trim().isEmpty) continue;


      bytes += generator.row([
        PosColumn(
          text: '',
          width: 3,
          styles: const PosStyles(align: PosAlign.center, bold: true),
        ),


        PosColumn(
          text: line.trim(),
          width: 6,
          styles: const PosStyles(align: PosAlign.center, bold: true, height: PosTextSize.size2),
        ),

        PosColumn(
          text: '',
          width: 3,
          styles: const PosStyles(align: PosAlign.center, bold: true),
        ),

      ]);

    }

// bytes += generator.hr(ch: '-');

// Address and phone — same issue, split into two separate calls
// instead of concatenating with '\n' into one string.
//     bytes += generator.text(
//       st_companyAddress,
//       styles: const PosStyles(align: PosAlign.center, bold: true),
//     );
    bytes += generator.row([
      PosColumn(
        text: '',
        width: 3,
        styles: const PosStyles(align: PosAlign.center, bold: true),
      ),


      PosColumn(
        text: st_companyAddress.trim(),
        width: 6,
        styles: const PosStyles(align: PosAlign.center, bold: true),
      ),

      PosColumn(
        text: '',
        width: 3,
        styles: const PosStyles(align: PosAlign.center, bold: true),
      ),

    ]);

    bytes += generator.row([


      PosColumn(
        text: '',
        width: 1,
        styles: const PosStyles(align: PosAlign.center, bold: true),
      ),
      PosColumn(
        text:  'Phone No: $st_companyPhone',
        width: 10,
        styles: const PosStyles(align: PosAlign.center, bold: true),
      ),

      PosColumn(
        text: '',
        width: 1,
        styles: const PosStyles(align: PosAlign.center, bold: true),
      ),

    ]);
    bytes += generator.hr(ch: '-');
    // ---------- BILL INFO ----------
    bytes += generator.row([
      PosColumn(
        text: 'Bill No:'+sales!.salesMaster!.invoiceNo.toString(),
        width: 7,
        styles: const PosStyles(align: PosAlign.left, bold: true),
      ),
      PosColumn(
        text: ' '+sales!.salesMaster!.salesType.toString(),
        width: 5,
        styles: const PosStyles(align: PosAlign.right, bold: true),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: 'Date: '+formatted.toString(),
        width: 7,
        styles: const PosStyles(align: PosAlign.left, bold: true),
      ),
      PosColumn(
        text: ' '+formattedTime.toString(),
        width: 5,
        styles: const PosStyles(align: PosAlign.right, bold: true),
      ),
    ]);
    // bytes += generator.row([
    //   PosColumn(text: 'W: LATHA', width: 6, styles: const PosStyles(align: PosAlign.left, bold: true)),
    //   PosColumn(text: 'Table:', width: 6, styles: const PosStyles(align: PosAlign.right, bold: true)),
    // ]);
    bytes += generator.hr(ch: '-');

    // ---------- ITEM TABLE HEADER ----------
    bytes += generator.row([
      // PosColumn(text: 'No', width: 1, styles: const PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(text: 'Item', width: 4, styles: const PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(text: 'Qty', width: 3, styles: const PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(text: 'Rate', width: 2, styles: const PosStyles(align: PosAlign.right, bold: true)),

      PosColumn(text: 'Amt', width: 3, styles: const PosStyles(align: PosAlign.right, bold: true)),
    ]);
    bytes += generator.hr(ch: '-');

    // ---------- ITEM ROWS: line 1 = product name (full width), line 2 = qty/rate/amount ----------
    for (int i = 0; i < sales!.salesDetails.length; i++) {
      int srlNo = i + 1;
      String st_prodName = sales.salesDetails[i].productName.toString();

      double dblQty = 0;
      String st_unitwithQty = '';
      try {
        String? stQty = sales.salesDetails[i].qty.toString();
        dblQty = double.parse(stQty!);
        // st_unitwithQty = dblQty.toString() + ' ' + sales.salesDetails[i].unitName;
        st_unitwithQty = dblQty.toString();
      } catch (_) {}

      String st_rate = sales.salesDetails[i].salesRate.toString();
      String st_total = '';
      try {
        double salesRate = double.parse(sales.salesDetails[i].salesRate);
        double dblTotal = dblQty * salesRate;
        st_total = dblTotal.toStringAsFixed(get_decimalpoints());
      } catch (_) {}

      // Line 1: serial no + product name, full row width
      bytes += generator.text(
        '$srlNo. $st_prodName',
        styles: const PosStyles(align: PosAlign.left, bold: true),
      );

      // Line 2: qty/unit, rate, amount — indented to line up under the heading
      bytes += generator.row([
        PosColumn(
          text: '',
          width: 2,
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          text: st_unitwithQty,
          width: 3,
          styles: const PosStyles(align: PosAlign.right, bold: true),
        ),
        PosColumn(
          text: st_rate,
          width: 4,
          styles: const PosStyles(align: PosAlign.right, bold: true),
        ),
        PosColumn(
          text: st_total,
          width: 3,
          styles: const PosStyles(align: PosAlign.right, bold: true),
        ),
      ]);
      bytes += generator.hr(ch: '-');
    }

    // ---------- NET AMOUNT ----------
    String? st_taxableValue = sales!.salesMaster?.subTotal;
    String? st_TaxAmt = sales!.salesMaster?.vatAmount;
    double dblSGST = double.parse(st_TaxAmt!);
    double dbl_sgst = dblSGST / 2;
    String st_sgst = dbl_sgst.toStringAsFixed(get_decimalpoints());
    String? st_Total = sales!.salesMaster?.grandTotal;
    double dblPayCard = 0, dblPayCash = 0;
    bool arabicTextStatus =false;

    String? st_paycash = sales!.salesMaster?.cashAmount.toString();
    String? st_paycard = sales!.salesMaster?.cardAmount.toString();



    ////////////////////////////////
    // Sub Total — normal size, smaller than Net Amount
    if (vatStatus) {
      bytes += generator.row([
        PosColumn(
          text: 'Sub Total:',
          width: 7,
          styles: const PosStyles(align: PosAlign.left, bold: true),
        ),
        PosColumn(
          text: st_taxableValue!,
          width: 5,
          styles: const PosStyles(align: PosAlign.right, bold: true),
        ),
      ]);

      bytes += generator.row([
        PosColumn(
          text: 'Tax:',
          width: 7,
          styles: const PosStyles(align: PosAlign.left, bold: true),
        ),
        PosColumn(
          text: st_TaxAmt,
          width: 5,
          styles: const PosStyles(align: PosAlign.right, bold: true),
        ),
      ]);
    }

    // Net Amount — largest, unchanged (double height)
    bytes += generator.row([
      PosColumn(
        text: 'Net Amount:',
        width: 7,
        styles: const PosStyles(align: PosAlign.left, bold: true, height: PosTextSize.size2),
      ),
      PosColumn(
        text: st_Total!,
        width: 5,
        styles: const PosStyles(align: PosAlign.right, bold: true, height: PosTextSize.size2),
      ),
    ]);

    // Cash — smaller font, only shown when the cash amount is greater than zero
    double dblPaycashCheck = 0;
    try {
      dblPaycashCheck = double.parse(st_paycash!);
    } catch (_) {}
    if (dblPaycashCheck > 0) {


      bytes += generator.row([
        PosColumn(
          text: 'Cash:',
          width: 7,
          styles: const PosStyles(align: PosAlign.left, bold: true, height: PosTextSize.size1),
        ),
        PosColumn(
          text: st_paycash!,
          width: 5,
          styles: const PosStyles(align: PosAlign.right, bold: true, height: PosTextSize.size1),
        ),
      ]);
    }

    // Card — smaller font, only shown when the card amount is greater than zero
    double dblPaycardCheck = 0;
    try {
      dblPaycardCheck = double.parse(st_paycard!);
    } catch (_) {}
    if (dblPaycardCheck > 0) {
      bytes += generator.row([
        PosColumn(
          text: 'Card:',
          width: 7,
          styles: const PosStyles(align: PosAlign.left, bold: true, fontType: PosFontType.fontB),
        ),
        PosColumn(
          text: st_paycard!,
          width: 5,
          styles: const PosStyles(align: PosAlign.right, bold: true, fontType: PosFontType.fontB),
        ),
      ]);
    }
    bytes += generator.hr(ch: '-');
    String st_OrderNo = '${sales.salesMaster?.billTokenNo ?? ''}';
    // ---------- FOOTER ----------
    bytes += generator.text('('+st_userName+')',styles: const PosStyles(align: PosAlign.center, bold:true));
    // bytes += generator.text('Kot No  : 0', styles: const PosStyles(align: PosAlign.left, bold: true));
    bytes += generator.text(
      'Tocken No : '+st_OrderNo,
      styles: const PosStyles(align: PosAlign.left, bold: true, height: PosTextSize.size2),
    );
    bytes += generator.text(
      footer_description,
      styles: const PosStyles(align: PosAlign.center, bold: true),
    );

    bytes += generator.feed(2);
    bytes += generator.cut();

    return bytes;
  }
  String formatTo12Hour(String time24) {
    final parsed = DateFormat('HH:mm:ss').parse(time24); // adjust pattern below if needed
    return DateFormat('hh:mm a').format(parsed);
  }
}

/// Wraps [text] into lines no longer than [maxChars], breaking on spaces
/// where possible so words aren't split mid-way. Falls back to a hard
/// break only if a single word is longer than [maxChars].


class ThermalPrinterService_2inches {

  Future<List<int>> generateReceipt(String st_companyLogo, SalesDetailsByMasterIdResult? sales, {

    String? logoUrl = 'https://example.com/logo.png', // <-- put your logo URL here
  }) async {
    List<int> bytes = [];

    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile); // 2 inch printer
    final vatEnableStatus = await SharedPreferenceHelper().getVatStatus();
    if(vatEnableStatus){
      vatStatus = true;
    }
    else{
      vatStatus = false;
    }
    final st_userName = await SharedPreferenceHelper().getStaffName();
    print('vatStatus$vatStatus');
    // ---------- LOGO (top center) ----------

    if (st_companyLogo != null && st_companyLogo.isNotEmpty) {
      try {
        final response = await http.get(Uri.parse(st_companyLogo));
        if (response.statusCode == 200) {
          img.Image? decodedImage = img.decodeImage(
            Uint8List.fromList(response.bodyBytes),
          );
          if (decodedImage != null) {
            // Derive the real printable width from the paper size the
            // generator was actually configured with — don't hardcode
            // 576, since that's only correct for 80mm/3" printers.
            // 58mm/2" printers are ~384 dots wide at 203dpi.
            final int printerWidthDots = switch (PaperSize.mm58) {
              PaperSize.mm58 => 384,
              PaperSize.mm80 => 576,
              _ => 384, // safe default if unknown
            };

            // Practical display size for a logo — scale relative to the
            // actual paper width so it doesn't dominate the receipt.
            final int maxLogoWidth = (printerWidthDots * 0.45).round();
            const int maxLogoHeight = 180;

            // Scale down by whichever dimension is more constraining,
            // preserving aspect ratio. Only shrink — never upscale a
            // small logo bigger than its original size.
            double scale = 1.0;
            if (decodedImage.width > maxLogoWidth) {
              scale = maxLogoWidth / decodedImage.width;
            }
            if (decodedImage.height * scale > maxLogoHeight) {
              scale = maxLogoHeight / decodedImage.height;
            }

            if (scale < 1.0) {
              final int targetWidth = (decodedImage.width * scale).round();
              final int targetHeight = (decodedImage.height * scale).round();
              decodedImage = img.copyResize(
                decodedImage,
                width: targetWidth,
                height: targetHeight,
              );
            }

            // Some printer/driver combos ignore the `align` flag for raster
            // images (it only reliably works for text). To guarantee true
            // centering regardless of that, paste the logo onto a full
            // paper-width white canvas, centered horizontally, then print
            // that canvas — it's centered by construction either way.
            final canvas = img.Image(width: printerWidthDots, height: decodedImage.height);
            img.fill(canvas, color: img.ColorRgb8(255, 255, 255));
            final int xOffset = ((printerWidthDots - decodedImage.width) / 2).round();
            img.compositeImage(canvas, decodedImage, dstX: xOffset, dstY: 0);

            bytes += generator.image(canvas, align: PosAlign.center);
          }
        }
      } catch (e) {
        // If the logo fails to load/decode, skip it silently so the
        // rest of the receipt still prints.
      }
    }
    String st_company ='',st_companyAddress='',st_companyPhone='' , footer_description ='';
    st_company = await SharedPreferenceHelper().getCompanyName() ?? "";
    st_companyAddress =
        await SharedPreferenceHelper().getCompanyAddress1() ?? "";
    st_companyPhone = await SharedPreferenceHelper().getCompanyPhoneNo() ?? "";
    footer_description = (await SharedPreferenceHelper().fetchDescriptionPrint())!;

    String formatted ='' , formattedTime='';
    try {
       formatted = DateFormat('dd-MM-yyyy').format(
          DateTime.parse(sales!.salesMaster!.invoiceDate!));
    }catch(_){
      print('Date_conversionError');
    }
    try{
    formattedTime = formatTo12Hour(sales!.salesMaster!.invoiceTime);
    }catch(_){
      print('Time_conversionError');
    }
    // ---------- HEADER ----------
    // At double width (size2) a 58mm/2" printer fits roughly half as many
    // characters per line as normal text (~16 instead of ~32). Wrap the
    // company name to that width ourselves and join with \n in a single
    // text() call, so every line — including wrapped ones — stays centered.
    final List<String> st_companyLines = _wordWrap(st_company, 16);
    // Company name — split into individual lines so each one gets its own
// centering calculation. Passing a single string with embedded '\n'
// only centers the first line correctly, especially at size2 (double
// width) where the character budget per line is much smaller on 2"
// paper — long lines wrap and the wrapped remainder isn't centered.
    for (final line in st_companyLines) {
      if (line.trim().isEmpty) continue;


      bytes += generator.row([
        PosColumn(
          text: '',
          width: 3,
          styles: const PosStyles(align: PosAlign.center, bold: true),
        ),


        PosColumn(
          text: line.trim(),
          width: 6,
          styles: const PosStyles(align: PosAlign.center, bold: true, height: PosTextSize.size2),
        ),

        PosColumn(
          text: '',
          width: 3,
          styles: const PosStyles(align: PosAlign.center, bold: true),
        ),

      ]);

    }

// bytes += generator.hr(ch: '-');

// Address and phone — same issue, split into two separate calls
// instead of concatenating with '\n' into one string.
//     bytes += generator.text(
//       st_companyAddress,
//       styles: const PosStyles(align: PosAlign.center, bold: true),
//     );
    bytes += generator.row([
      PosColumn(
        text: '',
        width: 3,
        styles: const PosStyles(align: PosAlign.center, bold: true),
      ),


      PosColumn(
        text: st_companyAddress.trim(),
        width: 6,
        styles: const PosStyles(align: PosAlign.center, bold: true),
      ),

      PosColumn(
        text: '',
        width: 3,
        styles: const PosStyles(align: PosAlign.center, bold: true),
      ),

    ]);

    bytes += generator.row([


      PosColumn(
        text: '',
        width: 1,
        styles: const PosStyles(align: PosAlign.center, bold: true),
      ),
      PosColumn(
        text:  'Phone No: $st_companyPhone',
        width: 10,
        styles: const PosStyles(align: PosAlign.center, bold: true),
      ),

      PosColumn(
        text: '',
        width: 1,
        styles: const PosStyles(align: PosAlign.center, bold: true),
      ),

    ]);
    bytes += generator.hr(ch: '-');
    // ---------- BILL INFO ----------
    bytes += generator.row([
      PosColumn(
        text: 'Bill No:'+sales!.salesMaster!.invoiceNo.toString(),
        width: 7,
        styles: const PosStyles(align: PosAlign.left, bold: true),
      ),
      PosColumn(
        text: ' '+sales!.salesMaster!.salesType.toString(),
        width: 5,
        styles: const PosStyles(align: PosAlign.right, bold: true),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: 'Date: '+formatted.toString(),
        width: 7,
        styles: const PosStyles(align: PosAlign.left, bold: true),
      ),
      PosColumn(
        text: ' '+formattedTime.toString(),
        width: 5,
        styles: const PosStyles(align: PosAlign.right, bold: true),
      ),
    ]);
    // bytes += generator.row([
    //   PosColumn(text: 'W: LATHA', width: 6, styles: const PosStyles(align: PosAlign.left, bold: true)),
    //   PosColumn(text: 'Table:', width: 6, styles: const PosStyles(align: PosAlign.right, bold: true)),
    // ]);
    bytes += generator.hr(ch: '-');

    // ---------- ITEM TABLE HEADER ----------
    bytes += generator.row([
     // PosColumn(text: 'No', width: 1, styles: const PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(text: 'Item', width: 4, styles: const PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(text: 'Qty', width: 3, styles: const PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(text: 'Rate', width: 2, styles: const PosStyles(align: PosAlign.right, bold: true)),

      PosColumn(text: 'Amt', width: 3, styles: const PosStyles(align: PosAlign.right, bold: true)),
    ]);
    bytes += generator.hr(ch: '-');

    // ---------- ITEM ROWS: line 1 = product name (full width), line 2 = qty/rate/amount ----------
    for (int i = 0; i < sales!.salesDetails.length; i++) {
      int srlNo = i + 1;
      String st_prodName = sales.salesDetails[i].productName.toString();

      double dblQty = 0;
      String st_unitwithQty = '';
      try {
        String? stQty = sales.salesDetails[i].qty.toString();
        dblQty = double.parse(stQty!);
        // st_unitwithQty = dblQty.toString() + ' ' + sales.salesDetails[i].unitName;
        st_unitwithQty = dblQty.toString();
      } catch (_) {}

      String st_rate = sales.salesDetails[i].salesRate.toString();
      String st_total = '';
      try {
        double salesRate = double.parse(sales.salesDetails[i].salesRate);
        double dblTotal = dblQty * salesRate;
        st_total = dblTotal.toStringAsFixed(get_decimalpoints());
      } catch (_) {}

      // Line 1: serial no + product name, full row width
      bytes += generator.text(
        '$srlNo. $st_prodName',
        styles: const PosStyles(align: PosAlign.left, bold: true),
      );

      // Line 2: qty/unit, rate, amount — indented to line up under the heading
      bytes += generator.row([
        PosColumn(
          text: '',
          width: 2,
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          text: st_unitwithQty,
          width: 3,
          styles: const PosStyles(align: PosAlign.right, bold: true),
        ),
        PosColumn(
          text: st_rate,
          width: 4,
          styles: const PosStyles(align: PosAlign.right, bold: true),
        ),
        PosColumn(
          text: st_total,
          width: 3,
          styles: const PosStyles(align: PosAlign.right, bold: true),
        ),
      ]);
      bytes += generator.hr(ch: '-');
    }

    // ---------- NET AMOUNT ----------
    String? st_taxableValue = sales!.salesMaster?.subTotal;
    String? st_TaxAmt = sales!.salesMaster?.vatAmount;
    double dblSGST = double.parse(st_TaxAmt!);
    double dbl_sgst = dblSGST / 2;
    String st_sgst = dbl_sgst.toStringAsFixed(get_decimalpoints());
    String? st_Total = sales!.salesMaster?.grandTotal;
    double dblPayCard = 0, dblPayCash = 0;
    bool arabicTextStatus =false;

    String? st_paycash = sales!.salesMaster?.cashAmount.toString();
    String? st_paycard = sales!.salesMaster?.cardAmount.toString();



    ////////////////////////////////
    // Sub Total — normal size, smaller than Net Amount
    if (vatStatus) {
    bytes += generator.row([
      PosColumn(
        text: 'Sub Total:',
        width: 7,
        styles: const PosStyles(align: PosAlign.left, bold: true),
      ),
      PosColumn(
        text: st_taxableValue!,
        width: 5,
        styles: const PosStyles(align: PosAlign.right, bold: true),
      ),
    ]);

      bytes += generator.row([
        PosColumn(
          text: 'Tax:',
          width: 7,
          styles: const PosStyles(align: PosAlign.left, bold: true),
        ),
        PosColumn(
          text: st_TaxAmt,
          width: 5,
          styles: const PosStyles(align: PosAlign.right, bold: true),
        ),
      ]);
    }

    // Net Amount — largest, unchanged (double height)
    bytes += generator.row([
      PosColumn(
        text: 'Net Amount:',
        width: 7,
        styles: const PosStyles(align: PosAlign.left, bold: true, height: PosTextSize.size2),
      ),
      PosColumn(
        text: st_Total!,
        width: 5,
        styles: const PosStyles(align: PosAlign.right, bold: true, height: PosTextSize.size2),
      ),
    ]);

    // Cash — smaller font, only shown when the cash amount is greater than zero
    double dblPaycashCheck = 0;
    try {
      dblPaycashCheck = double.parse(st_paycash!);
    } catch (_) {}
    if (dblPaycashCheck > 0) {


      bytes += generator.row([
        PosColumn(
          text: 'Cash:',
          width: 7,
          styles: const PosStyles(align: PosAlign.left, bold: true, height: PosTextSize.size1),
        ),
        PosColumn(
          text: st_paycash!,
          width: 5,
          styles: const PosStyles(align: PosAlign.right, bold: true, height: PosTextSize.size1),
        ),
      ]);
    }

    // Card — smaller font, only shown when the card amount is greater than zero
    double dblPaycardCheck = 0;
    try {
      dblPaycardCheck = double.parse(st_paycard!);
    } catch (_) {}
    if (dblPaycardCheck > 0) {
      bytes += generator.row([
        PosColumn(
          text: 'Card:',
          width: 7,
          styles: const PosStyles(align: PosAlign.left, bold: true, fontType: PosFontType.fontB),
        ),
        PosColumn(
          text: st_paycard!,
          width: 5,
          styles: const PosStyles(align: PosAlign.right, bold: true, fontType: PosFontType.fontB),
        ),
      ]);
    }
    bytes += generator.hr(ch: '-');
    String st_OrderNo = '${sales.salesMaster?.billTokenNo ?? ''}';
    // ---------- FOOTER ----------
    bytes += generator.text('('+st_userName+')',styles: const PosStyles(align: PosAlign.center, bold:true));
   // bytes += generator.text('Kot No  : 0', styles: const PosStyles(align: PosAlign.left, bold: true));
    bytes += generator.text(
      'Tocken No : '+st_OrderNo,
      styles: const PosStyles(align: PosAlign.left, bold: true, height: PosTextSize.size2),
    );
    bytes += generator.text(
      footer_description,
      styles: const PosStyles(align: PosAlign.center, bold: true),
    );

    bytes += generator.feed(2);
    bytes += generator.cut();

    return bytes;
  }
  String formatTo12Hour(String time24) {
    final parsed = DateFormat('HH:mm:ss').parse(time24); // adjust pattern below if needed
    return DateFormat('hh:mm a').format(parsed);
  }
}

