import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:pdf/widgets.dart' as pw;

import 'dart:ui' as ui;
import 'package:image/image.dart' as img;
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:quikservnew/features/dailyclosingReport/domain/entities/dailyClosingReportResult.dart';
import 'package:quikservnew/features/dailyclosingReport/presentation/screens/dailyCloseReportScreen.dart';
import 'package:quikservnew/features/itemwiseReport/domain/entities/itemwise_report_response.dart';
import 'package:quikservnew/features/sale/presentation/screens/home_screen.dart';
import 'package:quikservnew/features/salesReport/domain/entities/salesDetailsByMasterIdResult.dart';
import 'package:quikservnew/features/salesReport/presentation/bloc/sles_report_cubit.dart';
import 'package:quikservnew/services/shared_preference_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _statusTextController = TextEditingController();

class PrintPage extends StatefulWidget {
  final SalesDetailsByMasterIdResult? sales;
  final List<SummaryReports>? summaryList;
  final List<ExpenseDetail>? expenseList;
  final List<SummaryReport>? itemsList;
  final String? cashBalance;
  final String? bankBalance;
  final String? expenseTotal;
  final String? salesTotal;
  final String? itemWiseSalesTotal;
  final String? dailyCloseReportDate;

  final String pageFrom;
  bool oneLineProductFlag = false;
  bool doubleLineProductFlag = false;

  // final OrdersSaveToServerRequest? salesOrder;

  PrintPage({
    super.key,
    this.sales,
    required this.pageFrom,
    this.summaryList,
    this.expenseList,
    this.itemsList,
    this.cashBalance,
    this.bankBalance,
    this.expenseTotal,
    this.salesTotal,
    this.itemWiseSalesTotal,
    this.dailyCloseReportDate,
  });

  @override
  _PrintPageState createState() => _PrintPageState();
}

class _PrintPageState extends State<PrintPage> {
  List<BluetoothInfo> availableBluetoothDevices = [];
  String st_connectedDevicePref = '',
      st_company = '',
      st_TinNo = '',
      st_companyPhone = '',
      st_companyVatNo = '',
      st_vatType = '',
      st_vatEnabled = '',
      st_companyAddress = '',
      st_companyLogo = '',
      st_userName = '',
      st_baseUrl = '';
  bool deviceListStatus = false;
  bool arabicTextStatus = false;
  bool vatStatus = false;
  bool gstStatus = false;
  bool salesCase = false;
  bool dailyClosingReportStatus = false;
  bool salesOrderStatus = false;
  bool salesReportCase = false;
  String selectedPrinter = '';
  double dbl_bluetoothList = 0;
  double dbl_paymentSuccess = 0;
  String companyNameFontSize = '';
  bool st_companyAdressStatus = false;
  bool st_companyPhoneStatus = false;
  double logoWidth = 0;
  double logoHeight = 0;
  String description = '';

  @override
  void initState() {
    _statusTextController.text = '';
    super.initState();
    checkBluetooth();
    checkDeviceList();
  }

  Future<void> _getBluetoothDevices() async {
    final List<BluetoothInfo> devices =
        await PrintBluetoothThermal.pairedBluetooths;
    setState(() {
      availableBluetoothDevices = devices;
    });
  }

  Future<void> sendBytesInChunks(List<int> bytes) async {
    const chunkSize = 256; // adjust per your printer
    for (int i = 0; i < bytes.length; i += chunkSize) {
      int end = (i + chunkSize < bytes.length) ? i + chunkSize : bytes.length;
      final chunk = bytes.sublist(i, end);
      await PrintBluetoothThermal.writeBytes(chunk);
      await Future.delayed(
        const Duration(milliseconds: 50),
      ); // give printer time
    }
  }

  Future<List<int>> _generateKitchenPrintFromSales() async {
    final profile = await CapabilityProfile.load();
    Generator generator;
    String line;
    print('selectedPrinter $selectedPrinter');

    if (selectedPrinter == '2 inch') {
      generator = Generator(PaperSize.mm58, profile);
      line = '-------------------------------';
    } else {
      generator = Generator(PaperSize.mm80, profile);
      line = '-----------------------------------------------';
    }

    List<int> bytes = [];

    String st_salesTyp = widget.sales?.salesMaster?.salesType ?? '';
    String st_OrderNo = '${widget.sales?.salesMaster?.billTokenNo ?? ''}';

    // bytes.addAll(generator.text(st_OrderNo,
    //     styles: PosStyles(align: PosAlign.center), linesAfter: 0));
    if (selectedPrinter == '2 inch') {
      bytes += generator.row([
        PosColumn(
          text: 'Token No',
          width: 12,
          styles: const PosStyles(
            align: PosAlign.left,
            bold: true,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          ),
        ),
        // PosColumn(
        //   text: st_OrderNo,
        //   width: 8,
        //   styles: const PosStyles(
        //     align: PosAlign.left,
        //     bold: true,
        //     height: PosTextSize.size7,
        //     width: PosTextSize.size4,
        //   ),
        // ),
      ]);
      bytes += generator.row([
        // PosColumn(
        //   text: 'Token No:',
        //   width: 4,
        //   styles: const PosStyles(
        //     align: PosAlign.left,
        //     bold: true,
        //     height: PosTextSize.size1,
        //     width: PosTextSize.size1,
        //   ),
        // ),
        PosColumn(
          text: st_OrderNo,
          width: 12,
          styles: const PosStyles(
            align: PosAlign.left,
            bold: true,
            height: PosTextSize.size7,
            width: PosTextSize.size4,
          ),
        ),
      ]);
    }
    if (selectedPrinter == '3 inch') {
      bytes += generator.row([
        PosColumn(
          text: 'Token No',
          width: 12,
          styles: const PosStyles(
            align: PosAlign.left,
            bold: false, // bold increases visual size
            height: PosTextSize.size1, // smallest
            width: PosTextSize.size1,
          ),
        ),
        // PosColumn(
        //   text: st_OrderNo,
        //   width: 8,
        //   styles: const PosStyles(
        //     align: PosAlign.left,
        //     bold: true,
        //     height: PosTextSize.size2, // ⬅ reduced from size5
        //     width: PosTextSize.size2, // ⬅ reduced from size4
        //   ),
        // ),
      ]);
      bytes += generator.row([
        // PosColumn(
        //   text: 'Token No:',
        //   width: 4,
        //   styles: const PosStyles(
        //     align: PosAlign.left,
        //     bold: false, // bold increases visual size
        //     height: PosTextSize.size1, // smallest
        //     width: PosTextSize.size1,
        //   ),
        // ),
        PosColumn(
          text: st_OrderNo,
          width: 12,
          styles: const PosStyles(
            align: PosAlign.left,
            bold: true,
            height: PosTextSize.size2, // ⬅ reduced from size5
            width: PosTextSize.size2, // ⬅ reduced from size4
          ),
        ),
      ]);
    }
    bytes.addAll(
      generator.text(
        st_salesTyp,
        styles: PosStyles(align: PosAlign.center),
        linesAfter: 0,
      ),
    );

    bytes += await printKotHeading(generator);
    bytes.addAll(
      generator.text(
        line,
        styles: PosStyles(align: PosAlign.center),
        linesAfter: 0,
      ),
    );

    bytes += await printKotItemDetails(generator);
    final details = widget.sales?.salesDetails ?? [];
    int totalItem = 0 , totalQty = 0;
    for (int idx = 0; idx < details.length; idx++) {
      totalQty = totalQty + details[idx].qty;
    }
    bytes.addAll(
      generator.text(
        '',
        styles: PosStyles(align: PosAlign.center),
        linesAfter: 1,
      ),
    );
    bytes += generator.row([
      PosColumn(
        text: 'Total Qty :'+totalQty.toString(),
        width: 6,
        styles: const PosStyles(
          align: PosAlign.left,
          bold: false, // bold increases visual size
          height: PosTextSize.size1, // smallest
          width: PosTextSize.size1,
        ),
      ),
      PosColumn(
        text: 'Total Items: '+details.length.toString(),
        width: 6,
        styles: const PosStyles(
          align: PosAlign.left,
          bold: true,
          height: PosTextSize.size1, // ⬅ reduced from size5
          width: PosTextSize.size1, // ⬅ reduced from size4
        ),
      ),
    ]);
    bytes.addAll(
      generator.text(
        line,
        styles: PosStyles(align: PosAlign.center),
        linesAfter: 0,
      ),
    );

    // Feed only one small line before cut
    bytes.addAll(generator.feed(1));
    bytes += generator.cut(mode: PosCutMode.partial);
    return bytes;
  }

  Future<List<int>> printKotItemDetails(Generator generator) async {
    final List<int> bytes = [];
    final details = widget.sales?.salesDetails ?? [];

    final bool is3in = selectedPrinter == '3 inch';
    final int prodMaxChars = is3in ? 18 : 37; // tune if you want more/less

    for (int idx = 0; idx < details.length; idx++) {
      final item = details[idx];

      // --- raw fields ---
      String rawName = item.productName?.toString() ?? '';
      String rawCode = item.productCode?.toString() ?? '';

      // --- sanitize ---
      String prodName = sanitizeForPrint(rawName);
      String prodCode = sanitizeForPrint(rawCode);

      // --- debug: print runes for the 10th item_bloc (index 9) so we can inspect weird bytes ---
      if (idx == 9) {
        // index 9 -> 10th line
        print('DEBUG ITEM[9] rawName="$rawName" rawCode="$rawCode"');
        print('DEBUG ITEM[9] sanitized name="$prodName" code="$prodCode"');
        print(
          'DEBUG ITEM[9] name runes(hex)=${prodName.runes.map((r) => r.toRadixString(16)).join(",")}',
        );
        print(
          'DEBUG ITEM[9] code runes(hex)=${prodCode.runes.map((r) => r.toRadixString(16)).join(",")}',
        );
      }

      // --- truncate to avoid wrapping into numeric columns ---
      if (prodName.length > prodMaxChars) {
        prodName = prodName.substring(0, prodMaxChars - 1) + '…';
      }

      // --- numeric parsing ---
      final dblQty = double.tryParse(item.qty?.toString() ?? '0') ?? 0.0;
      final salesRate =
          double.tryParse(item.salesRate?.toString() ?? '0') ?? 0.0;
      final qtyStr = dblQty.toStringAsFixed(
        get_decimalpoints(),
      ); // or toString()
      final rateStr = salesRate.toStringAsFixed(get_decimalpoints());
      final totalStr = (dblQty * salesRate).toStringAsFixed(
        get_decimalpoints(),
      );

      final srlNo = (idx + 1).toString();

      // --- Choose printing strategy ---
      // If Malayalam (or other complex script) or for 2" printer, print name on its own line.
      final bool nameOnOwnLine = !is3in || containsMalayalam(prodName);
      final text = printerSafe(item.productName);
      bytes.addAll(
        generator.row([
          PosColumn(
            text: srlNo,
            width: 1,
            styles: PosStyles(align: PosAlign.left),
          ),
          PosColumn(
            text: text,
            width: 8,
            styles: PosStyles(align: PosAlign.left),
          ),
          PosColumn(
            text: qtyStr,
            width: 3,
            styles: PosStyles(align: PosAlign.center),
          ),
          // PosColumn(text: rateStr, width: 3, styles: PosStyles(align: PosAlign.right)),
          // PosColumn(text: totalStr, width: 3, styles: PosStyles(align: PosAlign.right)),
        ]),
      );
    } // end loop

    return bytes;
  }

  String printerSafe(String s) {
    return s
        .replaceAll('…', '...')
        .replaceAll(RegExp(r'[^\x20-\x7E]'), '') // FINAL KILL SWITCH
        .trim();
  }

  Future<List<int>> printKotHeading(Generator generator) async {
    List<int> bytes = [];
    if (selectedPrinter == '3 inch') {
      bytes += generator.row([
        PosColumn(text: 'No', width: 1),
        PosColumn(
          text: 'Item',
          width: 8,
          styles: PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          text: 'Qty',
          width: 3,
          styles: PosStyles(align: PosAlign.right),
        ),
        // PosColumn(
        //     text: 'Rate', width: 2, styles: PosStyles(align: PosAlign.right)),
        // PosColumn(
        //     text: 'Total', width: 2, styles: PosStyles(align: PosAlign.right)),
      ]);
      if (arabicTextStatus) {
        String st_itemheadArabic =
            'معدل    معدل       معدل                  الكمية              الباركود';
        Uint8List imageBytesText = await _textToImage(
          st_itemheadArabic,
          fontSize: 25,
        );
        final decoded = img.decodeImage(imageBytesText)!;
        bytes += generator.image(decoded, align: PosAlign.center);
      }
    }
    if (selectedPrinter == '2 inch') {
      bytes += generator.row([
        // PosColumn(text: 'No', width: 1),
        PosColumn(
          text: 'Item',
          width: 9,
          styles: PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          text: 'Qty',
          width: 3,
          styles: PosStyles(align: PosAlign.center),
        ),
        // PosColumn(
        //     text: 'Rate', width: 3, styles: PosStyles(align: PosAlign.right)),
        // PosColumn(
        //     text: 'Total', width: 3, styles: PosStyles(align: PosAlign.right)),
      ]);
      if (arabicTextStatus) {
        String st_itemheadArabic =
            'معدل     معدل       معدل       الكمية   معدل';
        Uint8List imageBytesText = await _textToImage(
          st_itemheadArabic,
          fontSize: 25,
        );
        final decoded = img.decodeImage(imageBytesText)!;
        bytes += generator.image(decoded, align: PosAlign.center);
      }
    }

    return bytes;
  }

  String sanitizeForPrint(String s) {
    return s
        // Normalize spaces
        .replaceAll('\u00A0', ' ') // NBSP → space
        .replaceAll(RegExp(r'[\r\n]'), ' ') // newlines → space
        // Replace problematic Unicode punctuation
        .replaceAll('…', '...')
        .replaceAll('–', '-')
        .replaceAll('—', '-')
        .replaceAll('“', '"')
        .replaceAll('”', '"')
        .replaceAll('‘', "'")
        .replaceAll('’', "'")
        // Remove remaining control / unsupported chars
        .replaceAll(RegExp(r'[\x00-\x1F\x7F]'), '')
        .replaceAll(RegExp(r'\s+'), ' ') // collapse spaces
        .trim();
  }

  // Future<List<int>> _generateTicket() async {
  //   print('reachedTicketGeneration');
  //   final profile = await CapabilityProfile.load();
  //   var generator = Generator(PaperSize.mm58, profile);
  //   String line = '-----------------------------------------------';
  //   print('selectedPrinter $selectedPrinter');
  //   //selectedPrinter = '3 inch';
  //   if (selectedPrinter == '2 inch') {
  //     print('if $selectedPrinter');
  //     generator = Generator(PaperSize.mm58, profile);
  //     line = '-------------------------------';
  //   }
  //   if (selectedPrinter == '3 inch') {
  //     print('secondIf $selectedPrinter');
  //     line = '-----------------------------------------------';
  //     generator = Generator(PaperSize.mm80, profile);
  //   }
  //
  //   // List<int> bytes = [];
  //
  //   String? st_invNo = widget.sales!.salesMaster?.invoiceNo.toString();
  //   String? st_dateAndTime = widget.sales!.salesMaster?.invoiceDate.toString();
  //   String? st_Time = widget.sales!.salesMaster?.invoiceTime.toString();
  //   List<int> bytes = [];
  //   String? st_paycash = widget.sales!.salesMaster?.cashAmount.toString();
  //   String? st_paycard = widget.sales!.salesMaster?.cardAmount.toString();
  //   bytes = await header_section(
  //     generator,
  //     st_invNo,
  //     st_dateAndTime,
  //     st_Time,
  //     st_paycash,
  //     st_paycard,
  //   );
  //   // String st_QRData = await createQRCode();
  //
  //   bytes += await printHeading(generator);
  //   bytes.addAll(
  //     generator.text(
  //       line,
  //       styles: PosStyles(align: PosAlign.center),
  //       linesAfter: 0,
  //     ),
  //   );
  //
  //   bytes += await printItemDetails(generator);
  //
  //   bytes.addAll(
  //     generator.text(
  //       line,
  //       styles: PosStyles(align: PosAlign.center),
  //       linesAfter: 0,
  //     ),
  //   );
  //
  //   bytes += await printFooter(generator);
  //
  //   bytes += generator.cut();
  //
  //   return bytes;
  // }
  Future<List<int>> _generateDailyClosingReport() async {
    final profile = await CapabilityProfile.load();
    var generator = Generator(PaperSize.mm58, profile);
    String line = '-----------------------------------------------';
    // print('selectedPrinter $selectedPrinter');
    if (selectedPrinter == '2 inch') {
      print('if $selectedPrinter');
      generator = Generator(PaperSize.mm58, profile);
      line = '-------------------------------';
    }
    if (selectedPrinter == '3 inch') {
      print('secondIf $selectedPrinter');
      line = '-----------------------------------------------';
      generator = Generator(PaperSize.mm80, profile);
    }

    List<int> bytes = [];
    bytes.addAll(
      generator.text(
        'Daily Closing Report',
        styles: PosStyles(align: PosAlign.center, bold: true),
        linesAfter: 0,
      ),
    );
    bytes.addAll(
      generator.text(
        '' + widget.dailyCloseReportDate.toString(),
        styles: PosStyles(align: PosAlign.center, bold: true),
        linesAfter: 0,
      ),
    );

    bytes.addAll(
      generator.text(
        line,
        styles: PosStyles(align: PosAlign.center),
        linesAfter: 0,
      ),
    );

    bytes += await printSalesSummary(generator);
    bytes += await printBalance(generator);
    bytes.addAll(
      generator.text(
        line,
        styles: PosStyles(align: PosAlign.center),
        linesAfter: 0,
      ),
    );
    bytes += generator.row([
      PosColumn(
        text: 'Product Wise',
        styles: PosStyles(align: PosAlign.left, bold: true),
        width: 6,
      ),
      PosColumn(
        text: widget.itemWiseSalesTotal!,
        styles: PosStyles(align: PosAlign.right, bold: true),
        width: 6,
      ),
    ]);

    bytes.addAll(
      generator.text(
        line,
        styles: PosStyles(align: PosAlign.center),
        linesAfter: 0,
      ),
    );
    bytes += await printItemSummary(generator);

    bytes.addAll(
      generator.text(
        line,
        styles: PosStyles(align: PosAlign.center),
        linesAfter: 0,
      ),
    );

    // bytes += await printFooter(generator);

    bytes += generator.cut();

    return bytes;
  }

  Future<List<int>> _generateTicket() async {
    final profile = await CapabilityProfile.load();
    Generator generator;

    String line = '-----------------------------------------------';

    if (selectedPrinter == '2 inch') {
      generator = Generator(PaperSize.mm58, profile);
      line = '-------------------------------';
    } else {
      generator = Generator(PaperSize.mm80, profile);
    }

    List<int> bytes = [];

    /// =======================
    /// 🔹 TOP LOGO (CENTER)
    /// =======================

    // final ByteData data = await rootBundle.load('assets/icons/quikserv_icon.png');
    // final Uint8List logoBytes = data.buffer.asUint8List();
    // final image = img.decodeImage(logoBytes);
    //
    // if (image != null) {
    //   bytes += generator.image(image, align: PosAlign.center);
    // }

    bytes += generator.feed(1);

    /// =======================
    /// 🔹 YOUR EXISTING HEADER
    /// =======================

    String? st_invNo = widget.sales!.salesMaster?.invoiceNo.toString();
    String? st_dateAndTime =
        widget.sales!.salesMaster!.invoiceDate.toString() +
        ' ' +
        widget.sales!.salesMaster!.invoiceTime;
    String? st_Time = widget.sales!.salesMaster?.invoiceTime.toString();
    String? st_paycash = widget.sales!.salesMaster?.cashAmount.toString();
    String? st_paycard = widget.sales!.salesMaster?.cardAmount.toString();

    bytes += await header_section(
      generator,
      st_invNo,
      st_dateAndTime,
      st_Time,
      st_paycash,
      st_paycard,
    );

    bytes += await printHeading(generator);

    bytes += generator.text(line, styles: PosStyles(align: PosAlign.center));

    bytes += await printItemDetails(generator);

    bytes += generator.text(line, styles: PosStyles(align: PosAlign.center));

    bytes += await printFooter(generator, st_paycash, st_paycard);

    /// =======================
    /// 🔹 COMPANY DETAILS (BOTTOM)
    /// =======================

    bytes += generator.feed(1);

    bytes += generator.feed(2);

    bytes += generator.cut();

    return bytes;
  }

  Future<pw.Font> loadArabicFont() async {
    final fontData = await rootBundle.load('fonts/Amiri-Regular.ttf');
    return pw.Font.ttf(fontData);
  }

  // Convert Arabic text to image
  Future<Uint8List> _textToImage(String text, {double fontSize = 30}) async {
    final arabicFont = await loadArabicFont();
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    print(arabicFont.fontName);

    canvas.drawColor(Colors.white, ui.BlendMode.srcOver);
    // Use a custom Arabic font (e.g., Amiri font)
    final textStyle = TextStyle(
      fontSize: fontSize,
      fontFamily: 'MyArabicFont', // Your custom Arabic font family
      height: 1.2, // Adjust line height (1.2 = 20% extra space)
      color: Colors.black,
    );
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: textStyle),
      textDirection: ui.TextDirection.rtl, // For Arabic text
      textAlign: TextAlign.left,
    );

    textPainter.layout(maxWidth: 576);

    //final textSize = textPainter.size;
    // Calculate the image width and height based on text size
    double width = textPainter.width;
    double height = textPainter.height;

    // Fix canvas size based on calculated text size
    final imgWidth = width.toInt();
    final imgHeight = height.toInt();

    // Ensure no extra space at the top (align text from the top)
    //canvas.drawColor(Colors.white, ui.BlendMode.srcOver);

    // Paint the text onto the canvas starting from the top-left corner
    textPainter.paint(canvas, Offset(0, 0));
    final picture = recorder.endRecording();
    final img = await picture.toImage(
      imgWidth,
      imgHeight,
    ); // Use the calculated image size
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  Future<void> _connectAndPrint(String mac) async {
    print('macAddress $mac');
    bool connected = await PrintBluetoothThermal.connect(
      macPrinterAddress: mac,
    );
    print('salesOrderStatus $salesOrderStatus');
    // if (connected) {

    print('enteredPrint');
    if (dailyClosingReportStatus) {
      print('dailyClosingReportStatus $dailyClosingReportStatus');
      if (widget.summaryList!.isNotEmpty ||
          widget.expenseList!.isNotEmpty ||
          widget.itemsList!.isNotEmpty) {
        final ticket = await _generateDailyClosingReport();
        await sendBytesInChunks(ticket);
        await PrintBluetoothThermal.disconnect;
        // context.read<SalesReportCubit>().saleSaveFinished(1);
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DailyClosingReportScreen()),
        );
      } else {
        Fluttertoast.showToast(
          msg: "Generate Report And Print..!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } else {
      print('reachedPrint');
      final ticket = await _generateTicket();

      final result = await PrintBluetoothThermal.writeBytes(ticket);
      await Future.delayed(const Duration(seconds: 2));
      final kitchenTicket = await _generateKitchenPrintFromSales();
      await sendBytesInChunks(kitchenTicket);
      //PrintBluetoothThermal.disconnect;
      print('resultPrint $result');
      context.read<SalesReportCubit>().saleSaveFinished(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    print('widget.pageFrom ${widget.pageFrom}');
    if (widget.pageFrom == 'Sales') {
      salesCase = true;
      salesReportCase = false;
      dailyClosingReportStatus = false;
    } else if (widget.pageFrom == 'SalesOrder') {
      salesReportCase = false;
      dailyClosingReportStatus = false;
      salesOrderStatus = true;
    } else if (widget.pageFrom == 'DailyClosingReport') {
      dailyClosingReportStatus = true;
    } else {
      salesCase = false;
      if (deviceListStatus) {
        salesReportCase = false;
      } else {
        salesReportCase = true;
      }
    }

    return Scaffold(
      // appBar: AppBar(title: Text('Bluetooth Thermal Print')),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Visibility(
              visible: deviceListStatus,
              child: Container(
                color: Colors.white,
                height: dbl_bluetoothList,
                width: double.infinity,
                child: ListView.builder(
                  itemCount: availableBluetoothDevices.length,
                  itemBuilder: (context, index) {
                    final device = availableBluetoothDevices[index];
                    return ListTile(
                      title: Text(device.name ?? 'Unknown'),
                      subtitle: Text(device.macAdress ?? ''),
                      onTap: () async {
                        if (device.macAdress != null) {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setString(
                            'bt_device_name',
                            device!.name.toString(),
                          );
                          await prefs.setString(
                            'bt_device_mac',
                            device!.macAdress.toString(),
                          );
                          // SharedPrefrence()
                          //     .setBluetoothMacAddress(device!.macAdress.toString());
                          // SharedPrefrence()
                          //     .setBluetoothDevice(device!.name.toString());
                          // _connectAndPrint(device.macAdress!);
                        }
                      },
                    );
                  },
                ),
              ),
            ),
            Visibility(
              visible: salesCase,
              child: Container(
                width: double.infinity,
                height: dbl_paymentSuccess,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Lottie.asset('assets/success_animation.json'),
                    ),
                    // Add your animation file here
                    const SizedBox(height: 20),
                    const Visibility(
                      visible: true,
                      child: Text(
                        'Payment Successful!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: salesReportCase,
              child: Visibility(
                child: Container(
                  width: double.infinity,
                  height: 500,
                  color: Colors.white,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _statusTextController.text,
                        style: TextStyle(color: Colors.black, fontSize: 22),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: true,
              child: Container(
                color: Colors.white,
                child: BlocConsumer<SalesReportCubit, SlesReportState>(
                  listener: (context, state) {
                    if (state is SaleFinishSuccess) {
                      print('Finished');

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      });
                    }
                  },
                  builder: (context, state) {
                    return const Column(children: []);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> checkDeviceList() async {
    final baseUrl = await SharedPreferenceHelper().getBaseUrl();
    if (baseUrl == null || baseUrl.isEmpty) {
      throw Exception("Base URL not set");
    }

    st_connectedDevicePref = (await SharedPreferenceHelper()
        .loadSelectedPrinter())!;
    selectedPrinter = (await SharedPreferenceHelper()
        .loadSelectedPrinterSize())!;
    companyNameFontSize = (await (SharedPreferenceHelper()
        .fetchCompanyNameFontSize()))!;
    st_companyAdressStatus = (await SharedPreferenceHelper()
        .fetchCompanyAddressInPrintStatus())!;
    st_companyPhoneStatus = (await SharedPreferenceHelper()
        .fetchCompanyPhoneInPrintStatus())!;
    description = (await SharedPreferenceHelper().fetchDescriptionPrint())!;
    st_company = await SharedPreferenceHelper().getCompanyName() ?? "";
    st_companyAddress =
        await SharedPreferenceHelper().getCompanyAddress1() ?? "";
    st_companyLogo = await SharedPreferenceHelper().getCompanyLogo() ?? "";
    st_companyPhone = await SharedPreferenceHelper().getCompanyPhoneNo() ?? "";
    st_baseUrl = await SharedPreferenceHelper().getBaseUrl() ?? "";

    logoHeight = (await SharedPreferenceHelper().fetchLogoHeight())!;
    logoWidth = (await SharedPreferenceHelper().fetchLogoWidth())!;
    print('st_connectedDevicePref $st_connectedDevicePref');
    print('selectedPrinter $selectedPrinter');
    print('logoHeight $logoHeight');
    print('logoWidth $logoWidth');
    print('companyNameFontSize $companyNameFontSize');
    print('st_baseUrl $st_baseUrl');
    // await SharedPrefrence().getBluetoothMacAddress().then((value) async {
    //   print('st_connectedDevicePref $value');
    //   st_connectedDevicePref = value.toString();
    // });
    // await SharedPrefrence().getCompanyName().then((value) async {
    //   print('getCompanyName $value');
    //   st_company = value.toString();
    // });
    // await SharedPrefrence().getCompanyPhone().then((value) async {
    //   print('getCompanyPhone $value');
    //   st_companyPhone = value.toString();
    // });
    // await SharedPrefrence().getCompanyAddress().then((value) async {
    //   print('getCompanyAddress $value');
    //   st_companyAddress = value.toString();
    // });
    // await SharedPrefrence().getCompanyVatNo().then((value) async {
    //   print('getCompanyVatNo $value');
    //   st_companyVatNo = value.toString();
    // });
    // await SharedPrefrence().getVatType().then((value) async {
    //   print('st_vatType $value');
    //   st_vatType = value.toString();
    // });
    // await SharedPrefrence().getVatEnabledStatus().then((value) async {
    //   print('st_vatEnabled $value');
    //   st_vatEnabled = value.toString();
    // });
    // await SharedPrefrence().getUserName().then((value) async {
    //   print('getUserName $value');
    //   st_userName = value.toString();
    // });
    // SharedPrefrence().loadSelectedPrinter().then((selected) {
    //   if(selected!.isNotEmpty) {
    //     selectedPrinter = selected;
    //     print('selectedPrinter $selectedPrinter');
    //   }
    //   else{
    //     selectedPrinter ='No print';
    //   }
    // });
    if (st_vatEnabled == '1') {
      if (st_vatType == 'VAT') {
        vatStatus = true;
        gstStatus = false;
      } else if (st_vatType == 'GST') {
        vatStatus = true;
        gstStatus = true;
      } else {
        vatStatus = false;
        gstStatus = false;
      }
    } else {
      vatStatus = false;
      gstStatus = false;
    }

    if (st_connectedDevicePref.isEmpty) {
      deviceListStatus = true;
      _getBluetoothDevices();
    } else {
      deviceListStatus = false;

      _connectAndPrint(st_connectedDevicePref);
    }
  }

  //Print Header while thermal print Haris
  Future<List<int>> header_section(
    Generator generator,
    String? st_invNo,
    String? st_dateAndTime,
    String? st_time,
    String? st_paycash,
    String? st_paycard,
  ) async {
    final ByteData data = await rootBundle.load(
      'assets/icons/quikservlogo.png',
    );
    final Uint8List imageBytes = data.buffer.asUint8List();
    List<int> bytes = [];
    ///////////////////////////////////////
    double dblPayCard = 0, dblPayCash = 0;

    ////////////////////////////////////////
    String line = '-----------------------------------------------';
    print('selectedPrinterHARIS $selectedPrinter');
    int logoWidthInt = 0;
    int logoHeightInt = 0;

    if (selectedPrinter == '2 inch') {
      print('if $selectedPrinter');
      if (logoHeight > 100) {}
      if (logoWidth > 100) {}

      line = '-------------------------------';
    }
    if (selectedPrinter == '3 inch') {
      print('secondIf $selectedPrinter');
      // Case 1
      if (logoHeight > 100 && logoHeight < 150) {
        logoWidthInt = 540; //550
      }
      if (logoWidth > 100 && logoWidth < 150) {
        logoHeightInt = 250; //250
      }
      // Case 2
      if (logoHeight > 150) {
        logoWidthInt = 570;
      }
      if (logoWidth > 150) {
        logoHeightInt = 300;
      }
      //Case 3
      if (logoHeight < 100 && logoHeight > 50) {
        logoWidthInt = 400;
      }
      if (logoWidth < 100 && logoWidth > 50) {
        logoHeightInt = 200;
      }

      //Case 3
      if (logoHeight < 50) {
        logoWidthInt = 200;
      }
      if (logoWidth < 50) {
        logoHeightInt = 100;
      }
      line = '-----------------------------------------------';
    }
    final imageURL = st_companyLogo;
    print('imageURL $imageURL');
    // Decode image using `image` package
    final img.Image? image = img.decodeImage(imageBytes);

    if (selectedPrinter == '2 inch') {
      final paperWidth = 384; // 58mm printer safe width

      final logoBytes = await loadLogoFromUrl(imageURL);

      if (logoBytes != null) {
        // ✅ Force safe width (max 300–350 for safety)
        final resized = img.copyResize(
          logoBytes,
          width: 300, // safer than dynamic large value
        );

        // Create centered canvas
        final canvas = img.Image(width: paperWidth, height: resized.height);

        img.fill(canvas, color: img.ColorRgb8(255, 255, 255));

        final offsetX = (paperWidth - resized.width) ~/ 2;

        img.compositeImage(canvas, resized, dstX: offsetX, dstY: 0);

        final grayscale = img.grayscale(canvas);

        bytes += generator.image(grayscale, align: PosAlign.center);
      }
    }

    // if (selectedPrinter == '3 inch') {
    //   if (image != null) {
    //     //   // Resize if too large (max width depends on paper size: ~384 px for 58mm)
    //     //final img.Image resized = img.copyResize(image, width: 150,height: 150);
    //     final resized = img.copyResize(image, width: logoWidthInt, height: logoHeightInt);
    //     bytes += generator.image(
    //       resized, // The data to encode
    //       // QRSize from 1 (smallest) to 8 (largest)
    //       align: PosAlign.center,
    //     );
    //   }
    // }
    if (selectedPrinter == '3 inch') {
      // 🔥 Load logo from network
      final paperWidth = 576; // 80mm printer
      final logoBytes = await loadLogoFromUrl(imageURL);

      if (logoBytes != null) {
        final resized = img.copyResize(
          logoBytes,
          width: logoWidthInt,
          height: logoHeightInt,
        );
        final canvas = img.Image(width: paperWidth, height: resized.height);

        img.fill(canvas, color: img.ColorRgb8(255, 255, 255));

        // Calculate center position
        final offsetX = (paperWidth - resized.width) ~/ 2;

        // Draw resized logo at center
        // img.copyInto(canvas, resized, dstX: offsetX);
        img.compositeImage(canvas, resized, dstX: offsetX, dstY: 0);

        final grayscale = img.grayscale(canvas);

        bytes += generator.image(grayscale);
      }
    }
    // st_company ='TEST COMPANY';

    int compnyFontSize = 0;
    try {
      compnyFontSize = int.parse(companyNameFontSize);
    } catch (_) {
      compnyFontSize = 0;
    }

    final textSize = _getTextSize(compnyFontSize);

    bytes += generator.text(
      st_company,
      styles: PosStyles(
        align: PosAlign.center,
        bold: true,
        height: textSize,
        width: textSize,
      ),
      linesAfter: 0,
    );

    // bytes += generator.text(
    //   st_company,
    //   styles: PosStyles(
    //     align: PosAlign.center,
    //     bold: true,
    //     height: PosTextSize.size1,
    //     width: PosTextSize.size1,
    //   ),
    //   linesAfter: 0,
    // );

    if (st_companyAddress.length > 1) {
      if (st_companyAdressStatus) {
        bytes += generator.text(
          '' + st_companyAddress,
          styles: PosStyles(
            align: PosAlign.center, // ✅ Centered
            bold: false,
          ),
          linesAfter: 0,
        );
      }
    }
    if (st_companyPhone.length > 1) {
      if (st_companyPhoneStatus) {
        bytes += generator.text(
          'Phone No: ' + st_companyPhone,
          styles: const PosStyles(
            align: PosAlign.center, // ✅ Centered
            bold: false,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          ),
          linesAfter: 0,
        );
      }
    }
    if (vatStatus) {
      bytes += generator.text(
        'GST No: ' + st_companyVatNo,
        styles: PosStyles(
          align: PosAlign.center, // ✅ Centered
          bold: false,
        ),
        linesAfter: 0,
      );
    }
    // bytes.addAll(generator.text(
    //   line,
    //   styles: PosStyles(align: PosAlign.center),
    //   linesAfter: 0,
    // ));
    if (vatStatus) {
      bytes += generator.text(
        'SIMPLIFIED TAX INVOICE',
        styles: PosStyles(
          align: PosAlign.center, // ✅ Centered
          bold: true,
          height: PosTextSize.size2,
          width: PosTextSize.size1,
        ),
        linesAfter: 0,
      );
    } else {
      String st_OrderNo = '${widget.sales?.salesMaster?.billTokenNo ?? ''}';

      // bytes.addAll(generator.text(st_OrderNo,
      //     styles: PosStyles(align: PosAlign.center), linesAfter: 0));

        bytes += generator.row([
          PosColumn(
            text: 'INVOICE',
            width: 6,
            styles: const PosStyles(
              align: PosAlign.right,
              bold: true,
              height: PosTextSize.size1,
              width: PosTextSize.size1,
            ),
          ),

          PosColumn(
            text: 'Token\n'+st_OrderNo,
            width: 6,
            styles: const PosStyles(
              align: PosAlign.right,
              bold: true,
              height: PosTextSize.size1,
              width: PosTextSize.size1,
            ),
          ),
        ]);
      // bytes += generator.text(
      //   'INVOICE',
      //   styles: PosStyles(
      //     align: PosAlign.center, // ✅ Centered
      //     bold: false,
      //     height: PosTextSize.size1,
      //     width: PosTextSize.size1,
      //   ),
      //   linesAfter: 0,
      // );
    }

    if (arabicTextStatus) {
      if (vatStatus) {
        if (selectedPrinter == '3 inch') {
          String arabicHead = "فاتورة ضريبية مبسطة                   .";
          Uint8List imageBytesText = await _textToImage(
            arabicHead,
            fontSize: 30,
          );
          final decoded = img.decodeImage(imageBytesText)!;
          bytes += generator.image(decoded, align: PosAlign.center);
        }
        if (selectedPrinter == '2 inch') {
          String arabicHead = "فاتورة ضريبية مبسطة";
          Uint8List imageBytesText = await _textToImage(
            arabicHead,
            fontSize: 30,
          );
          final decoded = img.decodeImage(imageBytesText)!;
          bytes += generator.image(decoded, align: PosAlign.center);
        }
      } else {
        if (selectedPrinter == '2 inch') {
          String arabicHead = "فاتورة       .";
          Uint8List imageBytesText = await _textToImage(
            arabicHead,
            fontSize: 30,
          );
          final decoded = img.decodeImage(imageBytesText)!;
          bytes += generator.image(decoded, align: PosAlign.center);
        }
        if (selectedPrinter == '3 inch') {
          String arabicHead = "فاتورة                              .";
          Uint8List imageBytesText = await _textToImage(
            arabicHead,
            fontSize: 30,
          );
          final decoded = img.decodeImage(imageBytesText)!;
          bytes += generator.image(decoded, align: PosAlign.center);
        }
      }
    }

    final st_userName = await SharedPreferenceHelper().getStaffName();
    st_invNo = st_invNo;
    String st_InvNo = st_invNo!;
    String st_Staff = st_userName;

    String st_invoiceTextPrin = 'مدفوع: ' + '' + st_InvNo;

    String st_StaffText = 'المدفوع: ' + '' + st_Staff;
    if (selectedPrinter == '3 inch') {
      if (st_invoiceTextPrin.length < 30) {
        int length_staff = st_invoiceTextPrin.length;
        length_staff = 30 - length_staff;
        for (int i = 0; i < length_staff; i++) {
          st_invoiceTextPrin = st_invoiceTextPrin + ' ';
        }
      } else {
        st_invoiceTextPrin = st_invoiceTextPrin.substring(0, 25);
      }
      if (st_StaffText.length < 20) {
        int length_invNo = st_StaffText.length;
        length_invNo = 20 - length_invNo;
        for (int i = 0; i < length_invNo; i++) {
          st_StaffText = st_StaffText + ' ';
        }
      } else {
        st_StaffText = st_StaffText.substring(0, 30);
      }
    }
    if (selectedPrinter == '2 inch') {
      if (st_invoiceTextPrin.length < 23) {
        int length_staff = st_invoiceTextPrin.length;
        length_staff = 23 - length_staff;
        for (int i = 0; i < length_staff; i++) {
          st_invoiceTextPrin = st_invoiceTextPrin + ' ';
        }
      } else {
        st_invoiceTextPrin = st_invoiceTextPrin.substring(0, 23);
      }
      if (st_StaffText.length < 20) {
        int length_invNo = st_StaffText.length;
        length_invNo = 20 - length_invNo;
        for (int i = 0; i < length_invNo; i++) {
          st_StaffText = st_StaffText + ' ';
        }
      } else {
        st_StaffText = st_StaffText.substring(0, 30);
      }
    }

    String st_timeam_pm = convertRailwayTimeToAmPm(st_time!);
    if (arabicTextStatus) {
      String st_fullText = st_invoiceTextPrin + st_StaffText;
      Uint8List imageBytesTextFirst = await _textToImage(
        st_fullText,
        fontSize: 28,
      );
      final decodedFirst = img.decodeImage(imageBytesTextFirst)!;
      bytes += generator.image(decodedFirst, align: PosAlign.left);

      ///second row
      String st_salesDate = _formatDateDMY(st_dateAndTime.toString())!;

      String st_ampm = st_timeam_pm.substring(
        st_timeam_pm.length - 2,
        st_timeam_pm.length,
      );
      st_timeam_pm = st_timeam_pm.substring(0, st_timeam_pm.length - 2);

      print('st_ampm $st_ampm');
      String st_dateTextPrin = 'مدفوع: ' + '' + st_salesDate;
      // String st_TimeText =
      //     'المدفوع: ' + '' + st_timeam_pm!;
      st_timeam_pm = st_timeam_pm.trim() + st_ampm.trim();
      String st_TimeText = 'المدفوع: ' + st_timeam_pm;
      print('st_dateTextPrin ${st_dateTextPrin.length}');

      print('st_timeam_pm $st_timeam_pm');
      print('st_TimeText $st_TimeText');
      if (selectedPrinter == '3 inch') {
        if (st_dateTextPrin!.length < 30) {
          int length_staff = st_dateTextPrin.length;
          length_staff = 30 - length_staff;
          for (int i = 0; i < length_staff; i++) {
            st_dateTextPrin = st_dateTextPrin! + ' ';
          }
        } else {
          st_dateTextPrin = st_dateTextPrin.substring(0, 30);
        }

        print('st_TimeText ${st_timeam_pm.length}');
        if (st_TimeText.length < 30) {
          int length_staff = st_TimeText.length;
          length_staff = 30 - length_staff;
          for (int i = 0; i < length_staff; i++) {
            st_TimeText = st_TimeText! + ' ';
          }
        } else {
          st_TimeText = st_TimeText.substring(0, 30);
        }
      }
      String st_fullDateText = st_dateTextPrin + '    ' + st_TimeText;

      Uint8List imageBytesText = await _textToImage(
        st_fullDateText,
        fontSize: 25,
      );
      final decoded = img.decodeImage(imageBytesText)!;
      bytes += generator.image(decoded, align: PosAlign.right);
    } else {
      bytes += generator.row([
        PosColumn(
          text: '#' + st_invNo!.toString(),
          styles: PosStyles(height: PosTextSize.size1, align: PosAlign.left),
          width: 4,
        ),
        PosColumn(
          text: 'Staff : ' + st_userName,
          width: 8,
          styles: const PosStyles(
            height: PosTextSize.size1,
            align: PosAlign.right,
          ),
        ),
      ]);
      bytes += generator.row([
        PosColumn(
          text: 'Date:' + _formatDateDMY(st_dateAndTime.toString())!,
          width: 12,
          styles: PosStyles(height: PosTextSize.size1, align: PosAlign.left),
        ),
        // PosColumn(
        //   text: 'Time : ' + st_timeam_pm.toString(),
        //   width: 6,
        //   styles: PosStyles(height: PosTextSize.size1, align: PosAlign.right),
        // ),
      ]);
    }

    if (vatStatus) {
      bytes += generator.row([
        PosColumn(
          text: 'Section:IN DOOR',
          width: 6,
          styles: PosStyles(height: PosTextSize.size1, align: PosAlign.left),
        ),
        PosColumn(
          text: 'TABLE: TBL 2',
          width: 6,
          styles: PosStyles(height: PosTextSize.size1, align: PosAlign.right),
        ),
      ]);
    }

    if (vatStatus) {
      bytes += generator.row([
        PosColumn(
          text: 'Order Mode : Dine In',
          width: 12,
          styles: PosStyles(height: PosTextSize.size1, align: PosAlign.left),
        ),
      ]);
    }

    bytes.addAll(
      generator.text(
        line,
        styles: PosStyles(align: PosAlign.center),
        linesAfter: 0,
      ),
    );
    return bytes;
  }

  String? _formatDateDMY(String? dateStr) {
    DateTime dateTime = DateTime.parse(
      dateStr!,
    ); // Parse the string into a DateTime object
    String formattedDate = DateFormat(
      'dd-MM-yyyy HH:mm:ss',
    ).format(dateTime); // Format the DateTime object
    return formattedDate;
  }

  Future<List<int>> printHeading(Generator generator) async {
    List<int> bytes = [];
    if (selectedPrinter == '3 inch') {
      bytes += generator.row([
        PosColumn(text: 'No', width: 1),
        PosColumn(
          text: 'Item',
          width: 5,
          styles: PosStyles(align: PosAlign.center),
        ),
        PosColumn(
          text: 'Qty',
          width: 2,
          styles: PosStyles(align: PosAlign.right),
        ),
        PosColumn(
          text: 'Rate',
          width: 2,
          styles: PosStyles(align: PosAlign.right),
        ),
        PosColumn(
          text: 'Total',
          width: 2,
          styles: PosStyles(align: PosAlign.right),
        ),
      ]);
      if (arabicTextStatus) {
        String st_itemheadArabic =
            'معدل    معدل       معدل                  الكمية              الباركود';
        Uint8List imageBytesText = await _textToImage(
          st_itemheadArabic,
          fontSize: 25,
        );
        final decoded = img.decodeImage(imageBytesText)!;
        bytes += generator.image(decoded, align: PosAlign.center);
      }
    }
    if (selectedPrinter == '2 inch') {
      bytes += generator.row([
        PosColumn(text: 'No', width: 1),
        PosColumn(
          text: 'Item',
          width: 3,
          styles: PosStyles(align: PosAlign.center),
        ),
        PosColumn(
          text: 'Qty',
          width: 2,
          styles: PosStyles(align: PosAlign.right),
        ),
        PosColumn(
          text: 'Rate',
          width: 3,
          styles: PosStyles(align: PosAlign.right),
        ),
        PosColumn(
          text: 'Total',
          width: 3,
          styles: PosStyles(align: PosAlign.right),
        ),
      ]);
      if (arabicTextStatus) {
        String st_itemheadArabic =
            'معدل     معدل       معدل       الكمية   معدل';
        Uint8List imageBytesText = await _textToImage(
          st_itemheadArabic,
          fontSize: 25,
        );
        final decoded = img.decodeImage(imageBytesText)!;
        bytes += generator.image(decoded, align: PosAlign.center);
      }
    }

    return bytes;
  }

  Future<List<int>> printItemSummary(Generator generator) async {
    String line = '-------------------------------';
    List<int> bytes = [];
    for (int i = 0; i < widget.itemsList!.length; i++) {
      print('CashAmount ${widget.itemsList?[i].productName.toString()}');
      int srlNo = i + 1;
      String? st_prodName = widget.itemsList?[i].productName.toString();
      String? st_qty = widget.itemsList?[i].qty.toString();
      String? st_SubTotal = widget.itemsList?[i].subTotal.toString();
      String? st_tax = widget.itemsList?[i].taxAmount.toString();

      //if(selectedPrinter=='3 inch') {
      try {
        bytes += generator.row([
          PosColumn(
            text: st_prodName!,
            width: 12,
            styles: const PosStyles(align: PosAlign.left, bold: true),
          ),
        ]);
      } catch (_) {
        Uint8List imageBytesText = await _textToImage(
          st_prodName!,
          fontSize: 25,
        );
        final decoded = img.decodeImage(imageBytesText)!;
        bytes += generator.image(decoded, align: PosAlign.left);
      }
      bytes += generator.row([
        PosColumn(
          text: 'Qty',
          styles: PosStyles(align: PosAlign.left),
          width: 4,
        ),
        PosColumn(
          text: 'Sub',
          styles: PosStyles(align: PosAlign.left),
          width: 4,
        ),
        PosColumn(
          text: 'Tax',
          styles: PosStyles(align: PosAlign.right),
          width: 4,
        ),
      ]);
      bytes += generator.row([
        PosColumn(
          text: st_qty!,
          styles: PosStyles(align: PosAlign.left),
          width: 4,
        ),
        PosColumn(
          text: st_SubTotal!,
          styles: PosStyles(align: PosAlign.left),
          width: 4,
        ),
        PosColumn(
          text: st_tax!,
          styles: PosStyles(align: PosAlign.right),
          width: 4,
        ),
      ]);

      // }
      // bytes += escSetLineSpacing(1);
      // bytes.addAll(generator.feed(0)); // instead of feed(1) or feed(2)
    }
    return bytes;
  }

  Future<List<int>> printSalesSummary(Generator generator) async {
    String line = '-------------------------------';
    List<int> bytes = [];
    for (int i = 0; i < widget.summaryList!.length; i++) {
      print('CashAmount ${widget.summaryList?[i].cashAmount.toString()}');
      int srlNo = i + 1;
      String? st_cashAmt = widget.summaryList?[i].cashAmount.toString();
      String? st_cardAmt = widget.summaryList?[i].cardAmount.toString();
      String? st_creditAmt = widget.summaryList?[i].creditAmount.toString();

      double dbl_cashAmt = 0;
      try {
        dbl_cashAmt = double.parse(st_cashAmt!);
      } catch (_) {}
      String st_cashAmtDisplay = dbl_cashAmt.toStringAsFixed(
        get_decimalpoints(),
      );

      if (selectedPrinter == '3 inch') {
        line = '------------------------------------------';
        bytes += generator.row([
          PosColumn(
            text: srlNo.toString(),
            styles: PosStyles(align: PosAlign.left),
            width: 1,
          ),
          PosColumn(
            text: st_cashAmt!,
            width: 5,
            styles: const PosStyles(align: PosAlign.left),
          ),
          PosColumn(
            text: st_cardAmt.toString(),
            width: 3,
            styles: PosStyles(align: PosAlign.right),
          ),
          PosColumn(
            text: st_creditAmt!,
            width: 3,
            styles: PosStyles(align: PosAlign.right),
          ),
        ]);
      }
      if (selectedPrinter == '2 inch') {
        bytes += generator.row([
          PosColumn(
            text: 'Sales Total',
            styles: PosStyles(align: PosAlign.left, bold: true),
            width: 6,
          ),
          PosColumn(
            text: widget.salesTotal!,
            width: 6,
            styles: const PosStyles(align: PosAlign.right, bold: true),
          ),
        ]);
        bytes.addAll(
          generator.text(
            line,
            styles: PosStyles(align: PosAlign.center),
            linesAfter: 0,
          ),
        );

        bytes += generator.row([
          PosColumn(
            text: 'Cash',
            styles: PosStyles(align: PosAlign.left),
            width: 6,
          ),
          PosColumn(
            text: st_cashAmtDisplay,
            width: 6,
            styles: const PosStyles(align: PosAlign.right),
          ),
        ]);
        bytes += generator.row([
          PosColumn(
            text: 'Card',
            styles: PosStyles(align: PosAlign.left),
            width: 6,
          ),
          PosColumn(
            text: st_cardAmt!,
            width: 6,
            styles: const PosStyles(align: PosAlign.right),
          ),
        ]);
        bytes += generator.row([
          PosColumn(
            text: 'Credit',
            styles: PosStyles(align: PosAlign.left),
            width: 6,
          ),
          PosColumn(
            text: st_creditAmt!,
            width: 6,
            styles: const PosStyles(align: PosAlign.right),
          ),
        ]);
      }
      //bytes += escSetLineSpacing(0);
      //bytes.addAll(generator.feed(0)); // instead of feed(1) or feed(2)
    }
    bytes.addAll(
      generator.text(
        line,
        styles: PosStyles(align: PosAlign.center),
        linesAfter: 0,
      ),
    );

    bytes += generator.row([
      PosColumn(
        text: 'Expense Total',
        width: 6,
        styles: const PosStyles(align: PosAlign.left, bold: true),
      ),
      PosColumn(
        text: '0.00'.toString(),
        width: 6,
        styles: PosStyles(align: PosAlign.right, bold: true),
      ),
    ]);
    bytes.addAll(
      generator.text(
        line,
        styles: PosStyles(align: PosAlign.center),
        linesAfter: 0,
      ),
    );

    for (int i = 0; i < widget.expenseList!.length; i++) {
      print('CashAmount ${widget.expenseList?[i].ledgerName.toString()}');
      int srlNo = i + 1;
      String? st_ledgerName = widget.expenseList?[i].ledgerName.toString();
      String? st_amount = widget.expenseList?[i].amount.toString();

      if (selectedPrinter == '3 inch') {
        bytes += generator.row([
          PosColumn(
            text: st_ledgerName!,
            width: 6,
            styles: const PosStyles(align: PosAlign.left),
          ),
          PosColumn(
            text: st_amount.toString(),
            width: 6,
            styles: PosStyles(align: PosAlign.right),
          ),
        ]);
      }
      if (selectedPrinter == '2 inch') {
        bytes += generator.row([
          PosColumn(
            text: st_ledgerName!,
            width: 6,
            styles: const PosStyles(align: PosAlign.left),
          ),
          PosColumn(
            text: st_amount.toString(),
            width: 6,
            styles: PosStyles(align: PosAlign.right),
          ),
        ]);
      }
      //bytes += escSetLineSpacing(5);
      //bytes.addAll(generator.feed(0)); // instead of feed(1) or feed(2)
    }
    return bytes;
  }

  Future<List<int>> printBalance(Generator generator) async {
    String line = '-------------------------------';
    if (selectedPrinter == '3 inch') {
      print('secondIf $selectedPrinter');
      line = '-----------------------------------------------';
    }
    List<int> bytes = [];

    // bytes.addAll(generator.text(
    //   line,
    //   styles: PosStyles(align: PosAlign.center),
    //   linesAfter: 0,
    // ));

    bytes += generator.row([
      PosColumn(
        text: 'Balance',
        width: 12,
        styles: const PosStyles(align: PosAlign.center, bold: true),
      ),
    ]);
    bytes.addAll(
      generator.text(
        line,
        styles: PosStyles(align: PosAlign.center),
        linesAfter: 0,
      ),
    );

    bytes += generator.row([
      PosColumn(
        text: 'Cash',
        width: 6,
        styles: const PosStyles(align: PosAlign.left, bold: true),
      ),
      PosColumn(
        text: widget.cashBalance!,
        width: 6,
        styles: const PosStyles(align: PosAlign.right, bold: true),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: 'Card',
        width: 6,
        styles: const PosStyles(align: PosAlign.left, bold: true),
      ),
      PosColumn(
        text: widget.bankBalance!,
        width: 6,
        styles: const PosStyles(align: PosAlign.right, bold: true),
      ),
    ]);

    return bytes;
  }

  Future<List<int>> printItemDetails(Generator generator) async {
    List<int> bytes = [];
    for (int i = 0; i < widget.sales!.salesDetails.length; i++) {
      int srlNo = i + 1;
      String? st_prodName = widget.sales?.salesDetails[i].productName
          .toString();
      String? st_prodNameArabic = '', st_unitwithQty = '', st_taxTotal = '';

      print('st_prodName $st_prodName');
      double dblQty = 0;
      try {
        String? stQty = widget.sales?.salesDetails[i].qty.toString();
        dblQty = double.parse(stQty!);

        //intQty = dblQty.floor();
        st_unitwithQty =
            dblQty.toString() + ' ' + widget.sales!.salesDetails[i].unitName;
        //print(intQty); // Output: 2
      } catch (_) {}

      if (st_unitwithQty!.length < 10) {
        int checkLength = 10 - st_unitwithQty.length;
        for (int i = 0; i < checkLength; i++) {
          st_unitwithQty = (st_unitwithQty! + '   ');
        }
      }

      st_taxTotal = widget.sales!.salesMaster!.vatAmount;

      String? st_barcode = '';
      String? st_rate = widget.sales?.salesDetails[i].salesRate;
      String? st_total = ' ';
      try {
        double salesRate = double.parse(
          widget.sales!.salesDetails[i].salesRate,
        );
        double dblTotal = dblQty * salesRate;
        st_total = dblTotal.toStringAsFixed(get_decimalpoints());
      } catch (_) {}
      //String? st_vatPercent = widget.sales?.salesDetails[i].vatPercentage;
      // print('st_vatPercent $st_vatPercent');

      st_barcode = widget.sales!.salesDetails[i].productCode.toString();
      if (st_barcode!.length > 5) {
        st_barcode = st_barcode.substring(0, 5);
      } else {
        int qtyLength = st_barcode.length;
        int spaceLength = 5 - qtyLength;
        for (int i = 0; i < spaceLength; i++) {
          st_barcode = st_barcode.toString() + ' ';
        }
      }
      if (st_unitwithQty!.length > 12) {
        st_unitwithQty = st_unitwithQty.substring(0, 12);
      } else {
        int qtyLength = st_unitwithQty.length;
        int spaceLength = 12 - qtyLength;
        for (int i = 0; i < spaceLength; i++) {
          st_unitwithQty = st_unitwithQty.toString() + ' ';
        }
      }
      if (st_rate!.length > 10) {
        st_rate = st_rate.substring(0, 10);
      } else {
        int rateLength = st_rate.length;
        int spaceLength = 10 - rateLength;
        for (int i = 0; i < spaceLength; i++) {
          st_rate = st_rate.toString() + ' ';
        }
      }
      if (st_total!.length > 12) {
        st_total = st_total.substring(0, 12);
      } else {
        int totalLength = st_total.length;
        int spaceLength = 12 - totalLength;
        for (int i = 0; i < spaceLength; i++) {
          st_total = st_total.toString() + ' ';
        }
      }
      if (selectedPrinter == '3 inch') {
        bytes += generator.row([
          PosColumn(
            text: srlNo.toString(),
            styles: PosStyles(align: PosAlign.left),
            width: 1,
          ),
          PosColumn(
            text: st_prodName!,
            width: 5,
            styles: const PosStyles(align: PosAlign.left),
          ),
          PosColumn(
            text: dblQty.toString(),
            width: 2,
            styles: PosStyles(align: PosAlign.right),
          ),
          PosColumn(
            text: st_rate!,
            width: 2,
            styles: PosStyles(align: PosAlign.right),
          ),
          PosColumn(
            text: st_total!,
            width: 2,
            styles: PosStyles(align: PosAlign.right),
          ),
        ]);
      }
      if (selectedPrinter == '2 inch') {
        bool malayalamWordStatus = containsMalayalam(st_prodName!);
        print('malayalamWordStatus $malayalamWordStatus');
        if (malayalamWordStatus) {
          Uint8List imageBytesText = await _textToImage(
            st_prodName!,
            fontSize: 23,
          );
          final decoded = img.decodeImage(imageBytesText)!;
          bytes += generator.image(decoded, align: PosAlign.left);
          bytes += generator.row([
            PosColumn(
              text: srlNo.toString(),
              styles: PosStyles(align: PosAlign.left),
              width: 1,
            ),
            PosColumn(text: '',
                width: 3,
                styles: const PosStyles(align: PosAlign.left)),
            PosColumn(
              text: dblQty.toString(),
              width: 2,
              styles: PosStyles(align: PosAlign.right),
            ),
            PosColumn(
              text: st_rate!,
              width: 3,
              styles: PosStyles(align: PosAlign.right),
            ),
            PosColumn(
              text: st_total!,
              width: 3,
              styles: PosStyles(align: PosAlign.right),
            ),
          ]);
        } else {
          bytes += generator.text(
            st_prodName,
            styles: PosStyles(
              align: PosAlign.left,
              bold: true,
              height: PosTextSize.size1,
              width: PosTextSize.size1,
            ),
            linesAfter: 1,
          );
          bytes += generator.row([
            PosColumn(
              text: srlNo.toString(),
              styles: PosStyles(align: PosAlign.left),
              width: 1,
            ),

            PosColumn(text: '',
                width: 3,
                styles: const PosStyles(align: PosAlign.left)),
            PosColumn(
              text: dblQty.toString(),
              width: 2,
              styles: PosStyles(align: PosAlign.right),
            ),
            PosColumn(
              text: st_rate!,
              width: 3,
              styles: PosStyles(align: PosAlign.right),
            ),
            PosColumn(
              text: st_total!,
              width: 3,
              styles: PosStyles(align: PosAlign.right),
            ),
          ]);
        }
      }
      bytes += escSetLineSpacing(5);
      bytes.addAll(generator.feed(0)); // instead of feed(1) or feed(2)
    }
    return bytes;
  }

  /// ESC 3 n: Set line spacing to `n` dots (0–255)
  List<int> escSetLineSpacing(int n) {
    return [0x1B, 0x33, n];
  }

  Future<List<int>> printFooter(
    Generator generator,
    String? st_paycash,
    String? st_paycard,
  ) async {
    List<int> bytes = [];
    String line = '-----------------------------------------------';
    if (selectedPrinter == '2 inch') {
      print('if $selectedPrinter');

      line = '-------------------------------';
    }
    if (selectedPrinter == '3 inch') {
      print('secondIf $selectedPrinter');
      line = '-----------------------------------------------';
    }
    String? st_taxableValue = widget.sales!.salesMaster?.subTotal;
    String? st_TaxAmt = widget.sales!.salesMaster?.vatAmount;
    double dblSGST = double.parse(st_TaxAmt!);
    double dbl_sgst = dblSGST / 2;
    String st_sgst = dbl_sgst.toStringAsFixed(get_decimalpoints());
    String? st_Total = widget.sales!.salesMaster?.grandTotal;
    double dblPayCard = 0, dblPayCash = 0;
    try {
      dblPayCard = double.parse(st_paycard!);
    } catch (_) {}
    try {
      dblPayCash = double.parse(st_paycash!);
    } catch (_) {}

    if (selectedPrinter == '3 inch') {
      if (vatStatus) {
        bytes += generator.text(
          'Taxable Value : ' + st_taxableValue!,
          styles: PosStyles(
            align: PosAlign.right, // ✅ Centered
            bold: false,
          ),
          linesAfter: 0,
        );
      }
      if (arabicTextStatus) {
        String st_vatArabic =
            'المدفوع                                                         .';
        Uint8List imageBytesText = await _textToImage(
          st_vatArabic,
          fontSize: 25,
        );
        final decoded = img.decodeImage(imageBytesText)!;
        bytes += generator.image(decoded, align: PosAlign.right);
      }

      if (gstStatus) {
        if (arabicTextStatus) {
          bytes += generator.text(
            'GST : ' + st_TaxAmt!,
            styles: PosStyles(
              align: PosAlign.left, // ✅ Centered
              bold: false,
            ),

            linesAfter: 0,
          );
          String st_vatArabic = 'المدفوع';
          Uint8List imageBytesText = await _textToImage(
            st_vatArabic,
            fontSize: 25,
          );
          final decoded = img.decodeImage(imageBytesText)!;
          bytes += generator.image(decoded, align: PosAlign.right);
        } else {
          bytes += generator.text(
            'GST : ' + st_TaxAmt!,
            styles: PosStyles(
              align: PosAlign.left, // ✅ Centered
              bold: false,
            ),

            linesAfter: 0,
          );
          bytes += generator.text(
            'SGST : ' + st_sgst!,
            styles: PosStyles(
              align: PosAlign.left, // ✅ Centered
              bold: false,
            ),

            linesAfter: 0,
          );
          bytes += generator.text(
            'CGST : ' + st_sgst!,
            styles: PosStyles(
              align: PosAlign.left, // ✅ Centered
              bold: false,
            ),
            linesAfter: 0,
          );
        }
      }
      if (vatStatus) {
        if (arabicTextStatus) {
          bytes += generator.text(
            'Tax : ' + st_TaxAmt!,
            styles: PosStyles(
              align: PosAlign.left, // ✅ Centered
              bold: false,
            ),

            linesAfter: 0,
          );
          String st_vatArabic = 'المدفوع';
          Uint8List imageBytesText = await _textToImage(
            st_vatArabic,
            fontSize: 25,
          );
          final decoded = img.decodeImage(imageBytesText)!;
          bytes += generator.image(decoded, align: PosAlign.right);
        } else {
          bytes += generator.text(
            'Tax : ' + st_TaxAmt!,
            styles: PosStyles(
              align: PosAlign.left, // ✅ Centered
              bold: false,
            ),

            linesAfter: 0,
          );
        }
      }

      if (arabicTextStatus) {
        String st_totalPaidText = ' : NET TOTAL  ';

        String st_totalPaidTextPrint =
            '   إجمالي المدفوع' + '   ' + st_totalPaidText;
        st_totalPaidTextPrint =
            st_Total.toString() + '  ' + st_totalPaidTextPrint;

        Uint8List imageBytesText = await _textToImage(
          st_totalPaidTextPrint,
          fontSize: 33,
        );
        final decoded = img.decodeImage(imageBytesText)!;
        bytes += generator.image(decoded, align: PosAlign.right);
      } else {
        bytes += generator.text(
          'NET TOTAL : ' + st_Total!,
          styles: PosStyles(
            align: PosAlign.right, // ✅ Centered
            bold: false,
            height: PosTextSize.size2,
            width: PosTextSize.size1,
          ),
          linesAfter: 0,
        );
      }
    }


    if (selectedPrinter == '2 inch') {
      if (vatStatus) {
        bytes += generator.text(
          'Taxable Value : ' + st_taxableValue!,
          styles: PosStyles(
            align: PosAlign.right, // ✅ Centered
            bold: false,
          ),
          linesAfter: 0,
        );
      }
      if (arabicTextStatus) {
        String st_vatArabic = '         المدفوع    ';
        Uint8List imageBytesText = await _textToImage(
          st_vatArabic,
          fontSize: 25,
        );
        final decoded = img.decodeImage(imageBytesText)!;
        bytes += generator.image(decoded, align: PosAlign.right);
      }
      if (gstStatus) {
        if (arabicTextStatus) {
          bytes += generator.text(
            'GST : ' + st_TaxAmt!,
            styles: PosStyles(
              align: PosAlign.left, // ✅ Centered
              bold: false,
            ),

            linesAfter: 0,
          );
          String st_vatArabic = 'المدفوع';
          Uint8List imageBytesText = await _textToImage(
            st_vatArabic,
            fontSize: 25,
          );
          final decoded = img.decodeImage(imageBytesText)!;
          bytes += generator.image(decoded, align: PosAlign.right);
        } else {
          bytes += generator.text(
            'GST : ' + st_TaxAmt!,
            styles: PosStyles(
              align: PosAlign.left, // ✅ Centered
              bold: false,
            ),
            linesAfter: 0,
          );
          bytes += generator.text(
            'SGST : ' + st_sgst!,
            styles: PosStyles(
              align: PosAlign.left, // ✅ Centered
              bold: false,
            ),

            linesAfter: 0,
          );
          bytes += generator.text(
            'CGST : ' + st_sgst!,
            styles: PosStyles(
              align: PosAlign.left, // ✅ Centered
              bold: false,
            ),
            linesAfter: 0,
          );
        }
      }
      if (vatStatus) {
        if (arabicTextStatus) {
          bytes += generator.text(
            'Tax : ' + st_TaxAmt!,
            styles: PosStyles(
              align: PosAlign.left, // ✅ Centered
              bold: false,
            ),

            linesAfter: 0,
          );
          String st_vatArabic = '       المدفوع';
          Uint8List imageBytesText = await _textToImage(
            st_vatArabic,
            fontSize: 25,
          );
          final decoded = img.decodeImage(imageBytesText)!;
          bytes += generator.image(decoded, align: PosAlign.left);
        } else {
          bytes += generator.text(
            'Tax : ' + st_TaxAmt!,
            styles: PosStyles(
              align: PosAlign.left, // ✅ Centered
              bold: false,
            ),

            linesAfter: 0,
          );
        }
      }

      if (arabicTextStatus) {
        String st_totalPaidText = ' : NET TOTAL  ';

        String st_totalPaidTextPrint =
            ' إجمالي المدفوع' + ' ' + st_totalPaidText;
        st_totalPaidTextPrint =
            st_Total.toString() + ' ' + st_totalPaidTextPrint;

        Uint8List imageBytesText = await _textToImage(
          st_totalPaidTextPrint,
          fontSize: 25,
        );
        final decoded = img.decodeImage(imageBytesText)!;
        bytes += generator.image(decoded, align: PosAlign.right);
      } else {
        bytes += generator.text(
          'NET TOTAL : ' + st_Total!,
          styles: PosStyles(
            align: PosAlign.right, // ✅ Centered
            bold: false,
            height: PosTextSize.size2,
            width: PosTextSize.size1,
          ),
          linesAfter: 0,
        );
      }
    }
    String st_payCard = dblPayCard.toStringAsFixed(get_decimalpoints());
    String st_payCash = dblPayCash.toStringAsFixed(get_decimalpoints());
    if (dblPayCard > 0 && dblPayCash > 0) {
      bytes += generator.row([
        PosColumn(
          text: 'Cash:' + st_payCash.toString(),
          width: 6,
          styles: PosStyles(height: PosTextSize.size1, align: PosAlign.left),
        ),
        PosColumn(
          text: 'Card :' + st_payCard.toString(),
          width: 6,
          styles: PosStyles(height: PosTextSize.size1, align: PosAlign.right),
        ),
      ]);
    } else {
      if (dblPayCard > 0) {
        bytes += generator.row([
          PosColumn(
            text: 'Card  :' + st_payCard.toString(),
            width: 12,
            styles: PosStyles(height: PosTextSize.size1, align: PosAlign.left),
          ),
        ]);
      }
      if (dblPayCash > 0) {
        bytes += generator.row([
          PosColumn(
            text: ' Cash :' + st_payCash.toString(),
            width: 12,
            styles: PosStyles(height: PosTextSize.size1, align: PosAlign.left),
          ),
        ]);
      }
    }
    bytes.addAll(
      generator.text(
        line,
        styles: PosStyles(align: PosAlign.center),
        linesAfter: 1,
      ),
    );
    bytes += generator.text(
      'THANK YOU..!',
      styles: PosStyles(
        align: PosAlign.center, // ✅ Centered
        bold: false,
        height: PosTextSize.size2,
        width: PosTextSize.size1,
      ),
      linesAfter: 0,
    );
    bytes += generator.text(
      description,
      styles: PosStyles(
        align: PosAlign.center, // ✅ Centered
        bold: false,
        height: PosTextSize.size2,
        width: PosTextSize.size1,
      ),
      linesAfter: 0,
    );
    return bytes;
  }

  void checkBluetooth() async {
    final bluetoothState = await FlutterBluePlus.bondedDevices;
    double screenHeight = MediaQuery.of(context).size.height;

    if (bluetoothState.isEmpty) {
      setState(() {
        dbl_paymentSuccess = screenHeight;
        deviceListStatus = false;
        _statusTextController.text = 'Printer is Not Connected..!';
      });
      Fluttertoast.showToast(
        msg: "Bluetooth is off state ",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      print("Bluetooth is OFF");
      // context.read<SaleCubit>().saleSaveFinished(2);
    } else {
      setState(() {
        dbl_paymentSuccess = screenHeight / 2;
        dbl_bluetoothList = screenHeight / 2;
        deviceListStatus = true;
        _statusTextController.text =
            'Bluetooth is on..Check your printer connection';
      });
      Fluttertoast.showToast(
        msg: "Bluetooth is on state ",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      print("Bluetooth is ON");
      // context.read<SaleCubit>().saleSaveFinished(10);
    }
  }

  String convertRailwayTimeToAmPm(String railwayTime) {
    try {
      // Assuming railwayTime is in "HH:mm" format (e.g., "14:30")
      final inputFormat = DateFormat("HH:mm:ss");
      final outputFormat = DateFormat("hh:mm a");

      // Parse the string to DateTime
      DateTime dateTime = inputFormat.parse(railwayTime);

      // Format it to AM/PM
      String amPmTime = outputFormat.format(dateTime);
      return amPmTime;
    } catch (e) {
      print("Error: $e");
      return railwayTime; // fallback to original if error
    }
  }

  bool containsArabic(String text) {
    final arabicRegExp = RegExp(r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF]');
    return arabicRegExp.hasMatch(text);
  }

  bool containsMalayalam(String text) {
    final malayalamRegExp = RegExp(r'[\u0D00-\u0D7F]');
    return malayalamRegExp.hasMatch(text);
  }
}

Future<img.Image?> loadLogoFromUrl(String url) async {
  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Uint8List bytes = response.bodyBytes;

      // Decode image to image package format
      img.Image? image = img.decodeImage(bytes);

      return image;
    } else {
      print("Failed to load image: ${response.statusCode}");
    }
  } catch (e) {
    print("Error loading logo: $e");
  }

  return null;
}

int get_decimalpoints() {
  final int decimal_points = 2;
  return decimal_points;
}

Future<Uint8List?> loadNetworkImage(String imageUrl) async {
  final response = await http.get(Uri.parse(imageUrl));

  if (response.statusCode == 200) {
    return response.bodyBytes;
  } else {
    print("Failed to load image");
    return null;
  }
}

PosTextSize _getTextSize(int size) {
  if (size >= 25) return PosTextSize.size2; // Large
  return PosTextSize.size1; // Normal
}
