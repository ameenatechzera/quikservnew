import 'package:equatable/equatable.dart';

class TokenUpdateResult extends Equatable {
  TokenUpdateResult({
    required this.status,
    required this.error,
    required this.message,
  });

  final int status;
  static const String statusKey = "status";

  final bool error;
  static const String errorKey = "error";

  final String message;
  static const String messageKey = "message";


  TokenUpdateResult copyWith({
    int? status,
    bool? error,
    String? message,
  }) {
    return TokenUpdateResult(
      status: status ?? this.status,
      error: error ?? this.error,
      message: message ?? this.message,
    );
  }

  factory TokenUpdateResult.fromJson(Map<String, dynamic> json){
    return TokenUpdateResult(
      status: json["status"] ?? 0,
      error: json["error"] ?? false,
      message: json["message"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "error": error,
    "message": message,
  };

  @override
  String toString(){
    return "$status, $error, $message, ";
  }

  @override
  List<Object?> get props => [
    status, error, message, ];
}
