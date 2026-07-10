import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

class ThermalPrinterService {
  Future<List<int>> generateReceipt() async {
    List<int> bytes = [];

    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile); // 3 inch printer

    // ---------- HEADER ----------
    bytes += generator.text(
      'OLAPPURA SEAFOOD RESTAURANT',
      styles: const PosStyles(align: PosAlign.center, bold: true),
    );
    bytes += generator.text(
      'Sea Food Restaurant',
      styles: const PosStyles(align: PosAlign.center),
    );
    bytes += generator.hr(ch: '-');
    bytes += generator.text('NEAR MVD OFFICE', styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text('THARAYIL BUSSTAND', styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text('PERINTHALMANNA', styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text('PH : 97444 42636', styles: const PosStyles(align: PosAlign.center));
    bytes += generator.hr(ch: '-');

    // ---------- BILL INFO ----------
    bytes += generator.row([
      PosColumn(
        text: 'Bill No: 31301',
        width: 7,
        styles: const PosStyles(align: PosAlign.left, bold: true),
      ),
      PosColumn(
        text: 'CASH BILL',
        width: 5,
        styles: const PosStyles(align: PosAlign.right, bold: true),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: 'Date: 10/07/26',
        width: 7,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: '01:37 PM',
        width: 5,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += generator.row([
      PosColumn(text: 'W: LATHA', width: 6, styles: const PosStyles(align: PosAlign.left)),
      PosColumn(text: 'Table:', width: 6, styles: const PosStyles(align: PosAlign.right)),
    ]);
    bytes += generator.hr(ch: '-');

    // ---------- ITEM TABLE HEADER ----------
    bytes += generator.row([
      PosColumn(text: 'No', width: 1, styles: const PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(text: 'Item', width: 5, styles: const PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(text: 'Rate', width: 2, styles: const PosStyles(align: PosAlign.right, bold: true)),
      PosColumn(text: 'Qty', width: 1, styles: const PosStyles(align: PosAlign.right, bold: true)),
      PosColumn(text: 'Amt', width: 3, styles: const PosStyles(align: PosAlign.right, bold: true)),
    ]);
    bytes += generator.hr(ch: '-');

    // ---------- ITEM ROWS (hardcoded, single line — fits fine on 80mm) ----------
    bytes += generator.row([
      PosColumn(text: '1', width: 1, styles: const PosStyles(align: PosAlign.left)),
      PosColumn(text: 'ALS', width: 5, styles: const PosStyles(align: PosAlign.left)),
      PosColumn(text: '90.00', width: 2, styles: const PosStyles(align: PosAlign.right)),
      PosColumn(text: '1', width: 1, styles: const PosStyles(align: PosAlign.right)),
      PosColumn(text: '90.00', width: 3, styles: const PosStyles(align: PosAlign.right)),
    ]);
    bytes += generator.row([
      PosColumn(text: '2', width: 1, styles: const PosStyles(align: PosAlign.left)),
      PosColumn(text: 'KEMEEN ROAST', width: 5, styles: const PosStyles(align: PosAlign.left)),
      PosColumn(text: '330.00', width: 2, styles: const PosStyles(align: PosAlign.right)),
      PosColumn(text: '1', width: 1, styles: const PosStyles(align: PosAlign.right)),
      PosColumn(text: '330.00', width: 3, styles: const PosStyles(align: PosAlign.right)),
    ]);
    bytes += generator.hr(ch: '-');

    // ---------- NET AMOUNT ----------
    bytes += generator.row([
      PosColumn(
        text: 'Net Amount:',
        width: 7,
        styles: const PosStyles(align: PosAlign.left, bold: true, height: PosTextSize.size2),
      ),
      PosColumn(
        text: '420.00',
        width: 5,
        styles: const PosStyles(align: PosAlign.right, bold: true, height: PosTextSize.size2),
      ),
    ]);
    bytes += generator.hr(ch: '-');

    // ---------- FOOTER ----------
    bytes += generator.text('(Cashier)', styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text('Kot No  : 0', styles: const PosStyles(align: PosAlign.left));
    bytes += generator.text(
      'Tocken No : 17',
      styles: const PosStyles(align: PosAlign.left, bold: true, height: PosTextSize.size2),
    );
    bytes += generator.text('THANK YOU VISIT AGAIN', styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text('Powered by SherSoft', styles: const PosStyles(align: PosAlign.center));

    bytes += generator.feed(2);
    bytes += generator.cut();

    return bytes;
  }
}

// ---------- USAGE EXAMPLE ----------
//
// class PrintController {
//   final ThermalPrinterService _printerService = ThermalPrinterService();
//
//   Future<List<int>> _generateTicket() async {
//     return await _printerService.generateReceipt();
//   }
//
//   Future<void> printReceipt() async {
//     final connected = await PrintBluetoothThermal.connectionStatus;
//     if (!connected) {
//       print('Printer not connected');
//       return;
//     }
//
//     final ticket = await _generateTicket();
//     final result = await PrintBluetoothThermal.writeBytes(ticket);
//     print('Print result: $result');
//   }
// }