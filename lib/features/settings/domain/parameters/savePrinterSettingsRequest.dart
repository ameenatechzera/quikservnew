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
  });

  final String printType;
  static const String printTypeKey = "printType";

  final String ipAddressWithPort;
  static const String ipAddressWithPortKey = "IpAddress_withPort";

  final String mainPrinter;
  static const String mainPrinterKey = "mainPrinter";

  final String kitchenPrinter;
  static const String kitchenPrinterKey = "kitchenPrinter";

  final int kitchenPrintStatus;
  static const String kitchenPrintStatusKey = "KitchenPrintStatus";

  final String paperSize;
  static const String paperSizeKey = "paperSize";

  final String printFooterText;
  static const String printFooterTextKey = "printFooterText";

  final int branchId;
  static const String branchIdKey = "branchId";

  final int createdUser;
  static const String createdUserKey = "CreatedUser";


  SavePrinterSettingsRequest copyWith({
    String? printType,
    String? ipAddressWithPort,
    String? mainPrinter,
    String? kitchenPrinter,
    int? kitchenPrintStatus,
    String? paperSize,
    String? printFooterText,
    int? branchId,
    int? createdUser,
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
    );
  }

  factory SavePrinterSettingsRequest.fromJson(Map<String, dynamic> json){
    return SavePrinterSettingsRequest(
      printType: json["printType"] ?? "",
      ipAddressWithPort: json["IpAddress_withPort"] ?? "",
      mainPrinter: json["mainPrinter"] ?? "",
      kitchenPrinter: json["kitchenPrinter"] ?? "",
      kitchenPrintStatus: json["KitchenPrintStatus"] ?? 0,
      paperSize: json["paperSize"] ?? "",
      printFooterText: json["printFooterText"] ?? "",
      branchId: json["branchId"] ?? 0,
      createdUser: json["CreatedUser"] ?? 0,
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
  };

  @override
  String toString(){
    return "$printType, $ipAddressWithPort, $mainPrinter, $kitchenPrinter, $kitchenPrintStatus, $paperSize, $printFooterText, $branchId, $createdUser, ";
  }

  @override
  List<Object?> get props => [
    printType, ipAddressWithPort, mainPrinter, kitchenPrinter, kitchenPrintStatus, paperSize, printFooterText, branchId, createdUser, ];
}
