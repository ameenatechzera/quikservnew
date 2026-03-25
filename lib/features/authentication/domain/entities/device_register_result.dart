import 'package:equatable/equatable.dart';

class DeviceRegisterResult extends Equatable {
  DeviceRegisterResult({
    required this.status,
    required this.error,
    required this.data,
  });

  final int status;
  static const String statusKey = "status";

  final bool error;
  static const String errorKey = "error";

  final Data? data;
  static const String dataKey = "data";


  DeviceRegisterResult copyWith({
    int? status,
    bool? error,
    Data? data,
  }) {
    return DeviceRegisterResult(
      status: status ?? this.status,
      error: error ?? this.error,
      data: data ?? this.data,
    );
  }

  factory DeviceRegisterResult.fromJson(Map<String, dynamic> json){
    return DeviceRegisterResult(
      status: json["status"] ?? 0,
      error: json["error"] ?? false,
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "error": error,
    "data": data?.toJson(),
  };

  @override
  String toString(){
    return "$status, $error, $data, ";
  }

  @override
  List<Object?> get props => [
    status, error, data, ];
}

class Data extends Equatable {
  Data({
    required this.result,
    required this.message,
  });

  final bool result;
  static const String resultKey = "result";

  final String message;
  static const String messageKey = "message";


  Data copyWith({
    bool? result,
    String? message,
  }) {
    return Data(
      result: result ?? this.result,
      message: message ?? this.message,
    );
  }

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      result: json["result"] ?? false,
      message: json["message"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
  };

  @override
  String toString(){
    return "$result, $message, ";
  }

  @override
  List<Object?> get props => [
    result, message, ];
}
