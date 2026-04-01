import 'package:quikservnew/features/settings/domain/entities/printer_save_result.dart';

class PrinterSettingsResultModel extends PrinterSettingsSaveResult {
  PrinterSettingsResultModel({
    required super.status,
    required super.error,
    required super.message,
  });
  factory PrinterSettingsResultModel.fromJson(Map<String, dynamic> json) {
    return PrinterSettingsResultModel(
      status: json["status"] ?? 0,
      error: json["error"] ?? false,
      message: json["message"] ?? "",
    );
  }
}
