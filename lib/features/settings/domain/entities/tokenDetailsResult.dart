import 'package:equatable/equatable.dart';

class TokenDetailsResult extends Equatable {
  TokenDetailsResult({
    required this.status,
    required this.error,
    required this.message,
    required this.salesBillToken,
  });

  final int status;
  static const String statusKey = "status";

  final bool error;
  static const String errorKey = "error";

  final String message;
  static const String messageKey = "message";

  final List<SalesBillToken> salesBillToken;
  static const String salesBillTokenKey = "SalesBillToken";


  TokenDetailsResult copyWith({
    int? status,
    bool? error,
    String? message,
    List<SalesBillToken>? salesBillToken,
  }) {
    return TokenDetailsResult(
      status: status ?? this.status,
      error: error ?? this.error,
      message: message ?? this.message,
      salesBillToken: salesBillToken ?? this.salesBillToken,
    );
  }

  factory TokenDetailsResult.fromJson(Map<String, dynamic> json){
    return TokenDetailsResult(
      status: json["status"] ?? 0,
      error: json["error"] ?? false,
      message: json["message"] ?? "",
      salesBillToken: json["SalesBillToken"] == null ? [] : List<SalesBillToken>.from(json["SalesBillToken"]!.map((x) => SalesBillToken.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "error": error,
    "message": message,
    "SalesBillToken": salesBillToken.map((x) => x?.toJson()).toList(),
  };

  @override
  String toString(){
    return "$status, $error, $message, $salesBillToken, ";
  }

  @override
  List<Object?> get props => [
    status, error, message, salesBillToken, ];
}

class SalesBillToken extends Equatable {
  SalesBillToken({
    required this.billTokenId,
    required this.billDate,
    required this.billTokenNo,
    required this.userId,
    required this.branchId,
  });

  final int billTokenId;
  static const String billTokenIdKey = "billTokenId";

  final String? billDate;
  static const String billDateKey = "billDate";

  final String billTokenNo;
  static const String billTokenNoKey = "billTokenNo";

  final int userId;
  static const String userIdKey = "userId";

  final int branchId;
  static const String branchIdKey = "branchId";


  SalesBillToken copyWith({
    int? billTokenId,
    String? billDate,
    String? billTokenNo,
    int? userId,
    int? branchId,
  }) {
    return SalesBillToken(
      billTokenId: billTokenId ?? this.billTokenId,
      billDate: billDate ?? this.billDate,
      billTokenNo: billTokenNo ?? this.billTokenNo,
      userId: userId ?? this.userId,
      branchId: branchId ?? this.branchId,
    );
  }

  factory SalesBillToken.fromJson(Map<String, dynamic> json){
    return SalesBillToken(
      billTokenId: json["billTokenId"] ?? "",
      billDate: json["billDate"] ?? "",
      billTokenNo: json["billTokenNo"] ?? "",
      userId: json["userId"] ?? "",
      branchId: json["branchId"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "billTokenId": billTokenId,
    "billDate": billDate,
    "billTokenNo": billTokenNo,
    "userId": userId,
    "branchId": branchId,
  };

  @override
  String toString(){
    return "$billTokenId, $billDate, $billTokenNo, $userId, $branchId, ";
  }

  @override
  List<Object?> get props => [
    billTokenId, billDate, billTokenNo, userId, branchId, ];
}
