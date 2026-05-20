import 'package:equatable/equatable.dart';

class LoyaltySearchResult extends Equatable {
  LoyaltySearchResult({
    required this.status,
    required this.error,
    required this.data,
  });

  final int status;
  static const String statusKey = "status";

  final bool error;
  static const String errorKey = "error";

  final List<Datum> data;
  static const String dataKey = "data";


  LoyaltySearchResult copyWith({
    int? status,
    bool? error,
    List<Datum>? data,
  }) {
    return LoyaltySearchResult(
      status: status ?? this.status,
      error: error ?? this.error,
      data: data ?? this.data,
    );
  }

  factory LoyaltySearchResult.fromJson(Map<String, dynamic> json){
    return LoyaltySearchResult(
      status: json["status"] ?? 0,
      error: json["error"] ?? false,
      data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "error": error,
    "data": data.map((x) => x?.toJson()).toList(),
  };

  @override
  String toString(){
    return "$status, $error, $data, ";
  }

  @override
  List<Object?> get props => [
    status, error, data, ];
}

class Datum extends Equatable {
  Datum({
    required this.customerName,
    required this.totalPointsEarned,
    required this.totalEarnedAmount,
    required this.phoneNo,
    required this.email,
    required this.loyaltyName,
    required this.amountPerPoint,
    required this.minRedeemAmount,
    required this.redeemValidityDays,
  });

  final String customerName;
  static const String customerNameKey = "customer_name";

  final String totalPointsEarned;
  static const String totalPointsEarnedKey = "total_points_earned";

  final String totalEarnedAmount;
  static const String totalEarnedAmountKey = "total_earned_amount";

  final String phoneNo;
  static const String phoneNoKey = "phone_no";

  final String email;
  static const String emailKey = "email";

  final String loyaltyName;
  static const String loyaltyNameKey = "loyalty_name";

  final String amountPerPoint;
  static const String amountPerPointKey = "amount_per_point";

  final String minRedeemAmount;
  static const String minRedeemAmountKey = "min_redeem_amount";

  final int redeemValidityDays;
  static const String redeemValidityDaysKey = "redeem_validity_days";


  Datum copyWith({
    String? customerName,
    String? totalPointsEarned,
    String? totalEarnedAmount,
    String? phoneNo,
    String? email,
    String? loyaltyName,
    String? amountPerPoint,
    String? minRedeemAmount,
    int? redeemValidityDays,
  }) {
    return Datum(
      customerName: customerName ?? this.customerName,
      totalPointsEarned: totalPointsEarned ?? this.totalPointsEarned,
      totalEarnedAmount: totalEarnedAmount ?? this.totalEarnedAmount,
      phoneNo: phoneNo ?? this.phoneNo,
      email: email ?? this.email,
      loyaltyName: loyaltyName ?? this.loyaltyName,
      amountPerPoint: amountPerPoint ?? this.amountPerPoint,
      minRedeemAmount: minRedeemAmount ?? this.minRedeemAmount,
      redeemValidityDays: redeemValidityDays ?? this.redeemValidityDays,
    );
  }

  factory Datum.fromJson(Map<String, dynamic> json){
    return Datum(
      customerName: json["customer_name"] ?? "",
      totalPointsEarned: json["total_points_earned"] ?? "",
      totalEarnedAmount: json["total_earned_amount"] ?? "",
      phoneNo: json["phone_no"] ?? "",
      email: json["email"] ?? "",
      loyaltyName: json["loyalty_name"] ?? "",
      amountPerPoint: json["amount_per_point"] ?? "",
      minRedeemAmount: json["min_redeem_amount"] ?? "",
      redeemValidityDays: json["redeem_validity_days"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "customer_name": customerName,
    "total_points_earned": totalPointsEarned,
    "total_earned_amount": totalEarnedAmount,
    "phone_no": phoneNo,
    "email": email,
    "loyalty_name": loyaltyName,
    "amount_per_point": amountPerPoint,
    "min_redeem_amount": minRedeemAmount,
    "redeem_validity_days": redeemValidityDays,
  };

  @override
  String toString(){
    return "$customerName, $totalPointsEarned, $totalEarnedAmount, $phoneNo, $email, $loyaltyName, $amountPerPoint, $minRedeemAmount, $redeemValidityDays, ";
  }

  @override
  List<Object?> get props => [
    customerName, totalPointsEarned, totalEarnedAmount, phoneNo, email, loyaltyName, amountPerPoint, minRedeemAmount, redeemValidityDays, ];
}
