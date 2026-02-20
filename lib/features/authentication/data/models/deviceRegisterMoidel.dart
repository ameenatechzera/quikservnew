


import 'package:quikservnew/features/authentication/domain/entities/deviceRegisterResult.dart';

class DeviceRegisterModel extends DeviceRegisterResult{
  DeviceRegisterModel({required super.status, required super.error, required super.data});
  factory DeviceRegisterModel.fromJson(Map<String, dynamic> json){
    return DeviceRegisterModel(
      status: json["status"] ?? 0,
      error: json["error"] ?? false,
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }
}