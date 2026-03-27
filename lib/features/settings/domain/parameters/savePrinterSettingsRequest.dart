import 'package:equatable/equatable.dart';

class SavePrinterSettingsRequest extends Equatable {
  SavePrinterSettingsRequest({
    required this.printType,
    required this.ipAddressWithPort,
    required this.mainPrinter,
    required this.kitchenPrinter,
    required this.kitchenPrintStatus,
    required this.paperSize,
    required this.printFooterText,
    required this.branchId,
    required this.createdUser,

    //added on 25-03-2026
    required this.mainBluettothPrinterId,
    required this.kitchenBluetoothPrinterId,
    required this.mainBluetoothPrinterName,
    required this.kitchenBluetoothPrinterName,
    required this.companyDescription,
    required this.printInvoiceKotDelay,
    required this.logoheight,
    required this.logowidth,
    required this.companyAddressVisible,
    required this.companyPhonenoVisible,
    required this.companyNameFontSize,
    required this.kotPrintStatus,


  });

  final String printType;
  static const String printTypeKey = "printType";

  final String ipAddressWithPort;
  static const String ipAddressWithPortKey = "IpAddress_withPort";

  final String mainPrinter;
  static const String mainPrinterKey = "mainPrinter";

  final String kitchenPrinter;
  static const String kitchenPrinterKey = "kitchenPrinter";

  final String kitchenPrintStatus;
  static const String kitchenPrintStatusKey = "KitchenPrintStatus";

  final String paperSize;
  static const String paperSizeKey = "paperSize";

  final String printFooterText;
  static const String printFooterTextKey = "printFooterText";

  final int branchId;
  static const String branchIdKey = "branchId";

  final int createdUser;
  static const String createdUserKey = "CreatedUser";

  //new

  final int mainBluettothPrinterId;
  static const String mainBluettothPrinterIdKey = "mainBluettothPrinterId";

  final int kitchenBluetoothPrinterId;
  static const String kitchenBluetoothPrinterIdKey = "kitchenBluetoothPrinterId";

  final String mainBluetoothPrinterName;
  static const String mainBluetoothPrinterNameKey = "mainBluetoothPrinterName";

  final String kitchenBluetoothPrinterName;
  static const String kitchenBluetoothPrinterNameKey = "kitchenBluetoothPrinterName";

  final String companyDescription;
  static const String companyDescriptionKey = "companyDescription";

  final String printInvoiceKotDelay;
  static const String printInvoiceKotDelayKey = "printInvoiceKotDelay";

  final String logoheight;
  static const String logoheightKey = "logoheight";

  final String logowidth;
  static const String logowidthKey = "logowidth";

  final String companyAddressVisible;
  static const String companyAddressVisibleKey = "companyAddressVisible";

  final String companyPhonenoVisible;
  static const String companyPhonenoVisibleKey = "companyPhonenoVisible";

  final String companyNameFontSize;
  static const String companyNameFontSizeKey = "companyNameFontSize";

  final String kotPrintStatus;
  static const String kotPrintStatusKey = "kotPrintStatus";



  SavePrinterSettingsRequest copyWith({
    String? printType,
    String? ipAddressWithPort,
    String? mainPrinter,
    String? kitchenPrinter,
    String? kitchenPrintStatus,
    String? paperSize,
    String? printFooterText,
    int? branchId,
    int? createdUser,

    int? mainBluettothPrinterId,
    int? kitchenBluetoothPrinterId,
    String? mainBluetoothPrinterName,
    String? kitchenBluetoothPrinterName,
    String? companyDescription,
    String? printInvoiceKotDelay,
    String? logoheight,
    String? logowidth,
    String? companyAddressVisible,
    String? companyPhonenoVisible,
    String? companyNameFontSize,
    String? kotPrintStatus,





  }) {
    return SavePrinterSettingsRequest(
      printType: printType ?? this.printType,
      ipAddressWithPort: ipAddressWithPort ?? this.ipAddressWithPort,
      mainPrinter: mainPrinter ?? this.mainPrinter,
      kitchenPrinter: kitchenPrinter ?? this.kitchenPrinter,
      kitchenPrintStatus: kitchenPrintStatus ?? this.kitchenPrintStatus,
      paperSize: paperSize ?? this.paperSize,
      printFooterText: printFooterText ?? this.printFooterText,
      branchId: branchId ?? this.branchId,
      createdUser: createdUser ?? this.createdUser,

      mainBluettothPrinterId: mainBluettothPrinterId ?? this.mainBluettothPrinterId,
      kitchenBluetoothPrinterId: kitchenBluetoothPrinterId ?? this.kitchenBluetoothPrinterId,
      mainBluetoothPrinterName: mainBluetoothPrinterName ?? this.mainBluetoothPrinterName,
      kitchenBluetoothPrinterName: kitchenBluetoothPrinterName ?? this.kitchenBluetoothPrinterName,
      companyDescription: companyDescription ?? this.companyDescription,
      printInvoiceKotDelay: printInvoiceKotDelay ?? this.printInvoiceKotDelay,
      logoheight: logoheight ?? this.logoheight,
      logowidth: logowidth ?? this.logowidth,
      companyAddressVisible: companyAddressVisible ?? this.companyAddressVisible,
      companyPhonenoVisible: companyPhonenoVisible ?? this.companyPhonenoVisible,
      companyNameFontSize: companyNameFontSize ?? this.companyNameFontSize,
      kotPrintStatus: kotPrintStatus ?? this.kotPrintStatus
    );
  }

  factory SavePrinterSettingsRequest.fromJson(Map<String, dynamic> json){
    return SavePrinterSettingsRequest(
      printType: json["printType"] ?? "",
      ipAddressWithPort: json["IpAddress_withPort"] ?? "",
      mainPrinter: json["mainPrinter"] ?? "",
      kitchenPrinter: json["kitchenPrinter"] ?? "",
      kitchenPrintStatus: json["KitchenPrintStatus"] ?? "",
      paperSize: json["paperSize"] ?? "",
      printFooterText: json["printFooterText"] ?? "",
      branchId: json["branchId"] ?? 0,
      createdUser: json["CreatedUser"] ?? 0,

      mainBluettothPrinterId: json["mainBluettothPrinterId"] ?? 0,
      kitchenBluetoothPrinterId: json["kitchenBluetoothPrinterId"] ?? 0,
      mainBluetoothPrinterName: json["mainBluetoothPrinterName"] ?? "",
      kitchenBluetoothPrinterName: json["kitchenBluetoothPrinterName"] ?? "",
      companyDescription: json["companyDescription"] ?? "",
      printInvoiceKotDelay: json["printInvoiceKotDelay"] ?? "",
      logoheight: json["logoheight"] ?? "",
      logowidth: json["logowidth"] ?? "",
      companyAddressVisible: json["companyAddressVisible"] ?? "",
      companyPhonenoVisible: json["companyPhonenoVisible"] ?? "",
      companyNameFontSize: json["companyNameFontSize"] ?? "",
      kotPrintStatus: json["kotPrintStatus"] ?? "",


    );
  }

  Map<String, dynamic> toJson() => {
    "printType": printType,
    "IpAddress_withPort": ipAddressWithPort,
    "mainPrinter": mainPrinter,
    "kitchenPrinter": kitchenPrinter,
    "KitchenPrintStatus": kitchenPrintStatus,
    "paperSize": paperSize,
    "printFooterText": printFooterText,
    "branchId": branchId,
    "CreatedUser": createdUser,

    "mainBluettothPrinterId": mainBluettothPrinterId,
    "kitchenBluetoothPrinterId": kitchenBluetoothPrinterId,
    "mainBluetoothPrinterName": mainBluetoothPrinterName,
    "kitchenBluetoothPrinterName": kitchenBluetoothPrinterName,
    "companyDescription": companyDescription,
    "printInvoiceKotDelay": printInvoiceKotDelay,
    "logoheight": logoheight,
    "logowidth": logowidth,
    "companyAddressVisible": companyAddressVisible,
    "companyPhonenoVisible": companyPhonenoVisible,
    "companyNameFontSize": companyNameFontSize,
    "kotPrintStatus": kotPrintStatus,
  };

  @override
  String toString(){
    return "$printType, $ipAddressWithPort, $mainPrinter, $kitchenPrinter, $kitchenPrintStatus, $paperSize, $printFooterText, $branchId, $createdUser, ";
  }

  @override
  List<Object?> get props => [
    printType, ipAddressWithPort, mainPrinter, kitchenPrinter, kitchenPrintStatus, paperSize, printFooterText, branchId, createdUser, ];
}
