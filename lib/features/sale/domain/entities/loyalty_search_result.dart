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

  final List<LoyaltyCustomer> data;
  static const String dataKey = "data";


  LoyaltySearchResult copyWith({
    int? status,
    bool? error,
    List<LoyaltyCustomer>? data,
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
      data: json["data"] == null ? [] : List<LoyaltyCustomer>.from(json["data"]!.map((x) => LoyaltyCustomer.fromJson(x))),
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

class LoyaltyCustomer extends Equatable {
  LoyaltyCustomer({
    required this.loyalityId,
    required this.custId,
    required this.customerName,
    required this.totalPointsEarned,
    required this.totalEarnedAmount,
    required this.phoneNo,
    required this.email,
    required this.loyaltyName,
    required this.amountPerPoint,
    required this.pointValue,
    required this.minRedeemPoint,
    required this.redeemValidityDays,
  });

  final int loyalityId;
  static const String loyalityIdKey = "loyality_id";

  final int custId;
  static const String custIdKey = "cust_id";

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

  final String pointValue;
  static const String pointPerAmountKey = "point_value";

  final String minRedeemPoint;
  static const String minRedeemPointKey = "min_redeem_point";

  final int redeemValidityDays;
  static const String redeemValidityDaysKey = "redeem_validity_days";


  LoyaltyCustomer copyWith({
    int? loyalityId,
    int? custId,
    String? customerName,
    String? totalPointsEarned,
    String? totalEarnedAmount,
    String? phoneNo,
    String? email,
    String? loyaltyName,
    String? amountPerPoint,
    String? pointValue,
    String? minRedeemPoint,
    int? redeemValidityDays,
  }) {
    return LoyaltyCustomer(
      loyalityId: loyalityId ?? this.loyalityId,
      custId: custId ?? this.custId,
      customerName: customerName ?? this.customerName,
      totalPointsEarned: totalPointsEarned ?? this.totalPointsEarned,
      totalEarnedAmount: totalEarnedAmount ?? this.totalEarnedAmount,
      phoneNo: phoneNo ?? this.phoneNo,
      email: email ?? this.email,
      loyaltyName: loyaltyName ?? this.loyaltyName,
      amountPerPoint: amountPerPoint ?? this.amountPerPoint,
      pointValue: pointValue ?? this.pointValue,
      minRedeemPoint: minRedeemPoint ?? this.minRedeemPoint,
      redeemValidityDays: redeemValidityDays ?? this.redeemValidityDays,
    );
  }

  factory LoyaltyCustomer.fromJson(Map<String, dynamic> json){
    return LoyaltyCustomer(
      loyalityId: json["loyality_id"] ?? 0,
      custId: json["cust_id"] ?? 0,
      customerName: json["customer_name"] ?? "",
      totalPointsEarned: json["total_points_earned"] ?? "",
      totalEarnedAmount: json["total_earned_amount"] ?? "",
      phoneNo: json["phone_no"] ?? "",
      email: json["email"] ?? "",
      loyaltyName: json["loyalty_name"] ?? "",
      amountPerPoint: json["amount_per_point"] ?? "",
      pointValue: json["point_value"] ?? "",
      minRedeemPoint: json["min_redeem_point"] ?? "",
      redeemValidityDays: json["redeem_validity_days"] ?? 0,

    );
  }

  Map<String, dynamic> toJson() => {
    "loyality_id": loyalityId,
    "cust_id": custId,
    "customer_name": customerName,
    "total_points_earned": totalPointsEarned,
    "total_earned_amount": totalEarnedAmount,
    "phone_no": phoneNo,
    "email": email,
    "loyalty_name": loyaltyName,
    "amount_per_point": amountPerPoint,
    "point_value": pointValue,
    "min_redeem_point": minRedeemPoint,
    "redeem_validity_days": redeemValidityDays,
  };

  @override
  String toString(){
    return "$loyalityId, $custId, $customerName, $totalPointsEarned, $totalEarnedAmount, $phoneNo, $email, $loyaltyName, $amountPerPoint, $pointValue, $minRedeemPoint, $redeemValidityDays, ";
  }

  @override
  List<Object?> get props => [
    loyalityId, custId, customerName, totalPointsEarned, totalEarnedAmount, phoneNo, email, loyaltyName, amountPerPoint, pointValue, minRedeemPoint, redeemValidityDays, ];
}
