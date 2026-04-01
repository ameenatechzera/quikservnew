import 'package:equatable/equatable.dart';

class CommonResult extends Equatable {
  CommonResult({
    required this.status,
    required this.message,
  });

  final bool status;
  final String message;

  CommonResult copyWith({
    bool? status,
    String? message,
  }) {
    return CommonResult(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
  factory CommonResult.fromJson(Map<String, dynamic> json){
    return CommonResult(
      status: json["status"] ?? 0,

      message: json["message"] ?? "",

    );
  }
  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };

  @override
  String toString(){
    return "$status, $message, ";
  }

  @override
  List<Object?> get props => [
    status, message, ];
}