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

  factory LoyaltySearchResult.fromJson(Map<String, dynamic> json) {
    return LoyaltySearchResult(
      status: json["status"] ?? 0,
      error: json["error"] ?? false,
      data: json["data"] == null
          ? []
          : List<LoyaltyCustomer>.from(
              json["data"]!.map((x) => LoyaltyCustomer.fromJson(x)),
            ),
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "error": error,
    "data": data.map((x) => x?.toJson()).toList(),
  };

  @override
  String toString() {
    return "$status, $error, $data, ";
  }

  @override
  List<Object?> get props => [status, error, data];
}

class LoyaltyCustomer extends Equatable {
  const LoyaltyCustomer({
    // required this.loyalityId,
    // required this.custId,
    // required this.customerName,
    // required this.totalPointsEarned,
    // required this.totalEarnedAmount,
    // required this.phoneNo,
    // required this.email,
    // required this.loyaltyName,
    // required this.amountPerPoint,
    // required this.pointValue,
    // required this.minRedeemPoint,
    // required this.redeemValidityDays,
    required this.loyalityId,
    required this.custId,
    required this.customerName,
    required this.totalPointsEarned,
    required this.totalPointRedeemed,
    required this.availablePoints,
    required this.expiredPoints,
    required this.totalEarnedAmount,
    required this.availableAmount,
    required this.expiredAmount,
    required this.phoneNo,
    required this.email,
    required this.loyaltyName,
    required this.amountPerPoint,
    required this.pointValue,
    required this.minRedeemPoint,
    required this.redeemValidityDays,
    required this.billCount,
    required this.lastBillDate,
  });
  final int loyalityId;
  static const String loyalityIdKey = "loyality_id";

  final int custId;
  static const String custIdKey = "cust_id";

  final String customerName;
  static const String customerNameKey = "customer_name";

  final String totalPointsEarned;
  static const String totalPointsEarnedKey = "total_points_earned";

  final String totalPointRedeemed;
  static const String totalPointRedeemedKey = "total_point_redeemed";

  final String availablePoints;
  static const String availablePointsKey = "available_points";

  final String expiredPoints;
  static const String expiredPointsKey = "expired_points";

  final String totalEarnedAmount;
  static const String totalEarnedAmountKey = "total_earned_amount";

  final String availableAmount;
  static const String availableAmountKey = "available_amount";

  final String expiredAmount;
  static const String expiredAmountKey = "expired_amount";

  final String phoneNo;
  static const String phoneNoKey = "phone_no";

  final String email;
  static const String emailKey = "email";

  final String loyaltyName;
  static const String loyaltyNameKey = "loyalty_name";

  final String amountPerPoint;
  static const String amountPerPointKey = "amount_per_point";

  final String pointValue;
  static const String pointValueKey = "point_value";

  final String minRedeemPoint;
  static const String minRedeemPointKey = "min_redeem_point";

  final int redeemValidityDays;
  static const String redeemValidityDaysKey = "redeem_validity_days";

  final int billCount;
  static const String billCountKey = "bill_count";

  final String lastBillDate;
  static const String lastBillDateKey = "last_bill_date";

  LoyaltyCustomer copyWith({
    int? loyalityId,
    int? custId,
    String? customerName,
    String? totalPointsEarned,
    String? totalPointRedeemed,
    String? availablePoints,
    String? expiredPoints,
    String? totalEarnedAmount,
    String? availableAmount,
    String? expiredAmount,
    String? phoneNo,
    String? email,
    String? loyaltyName,
    String? amountPerPoint,
    String? pointValue,
    String? minRedeemPoint,
    int? redeemValidityDays,
    int? billCount,
    String? lastBillDate,
  }) {
    return LoyaltyCustomer(
      loyalityId: loyalityId ?? this.loyalityId,
      custId: custId ?? this.custId,
      customerName: customerName ?? this.customerName,
      totalPointsEarned: totalPointsEarned ?? this.totalPointsEarned,
      totalPointRedeemed: totalPointRedeemed ?? this.totalPointRedeemed,
      availablePoints: availablePoints ?? this.availablePoints,
      expiredPoints: expiredPoints ?? this.expiredPoints,
      totalEarnedAmount: totalEarnedAmount ?? this.totalEarnedAmount,
      availableAmount: availableAmount ?? this.availableAmount,
      expiredAmount: expiredAmount ?? this.expiredAmount,
      phoneNo: phoneNo ?? this.phoneNo,
      email: email ?? this.email,
      loyaltyName: loyaltyName ?? this.loyaltyName,
      amountPerPoint: amountPerPoint ?? this.amountPerPoint,
      pointValue: pointValue ?? this.pointValue,
      minRedeemPoint: minRedeemPoint ?? this.minRedeemPoint,
      redeemValidityDays: redeemValidityDays ?? this.redeemValidityDays,
      billCount: billCount ?? this.billCount,
      lastBillDate: lastBillDate ?? this.lastBillDate,
    );
  }

  factory LoyaltyCustomer.fromJson(Map<String, dynamic> json) {
    return LoyaltyCustomer(
      loyalityId: json["loyality_id"] ?? 0,
      custId: json["cust_id"] ?? 0,
      customerName: json["customer_name"] ?? "",
      totalPointsEarned: json["total_points_earned"] ?? "",
      totalPointRedeemed: json["total_point_redeemed"] ?? "",
      availablePoints: json["available_points"] ?? "",
      expiredPoints: json["expired_points"] ?? "",
      totalEarnedAmount: json["total_earned_amount"] ?? "",
      availableAmount: json["available_amount"] ?? "",
      expiredAmount: json["expired_amount"] ?? "",
      phoneNo: json["phone_no"] ?? "",
      email: json["email"] ?? "",
      loyaltyName: json["loyalty_name"] ?? "",
      amountPerPoint: json["amount_per_point"] ?? "",
      pointValue: json["point_value"] ?? "",
      minRedeemPoint: json["min_redeem_point"] ?? "",
      redeemValidityDays: json["redeem_validity_days"] ?? 0,
      billCount: json["bill_count"] ?? 0,
      lastBillDate: json["last_bill_date"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "loyality_id": loyalityId,
    "cust_id": custId,
    "customer_name": customerName,
    "total_points_earned": totalPointsEarned,
    "total_point_redeemed": totalPointRedeemed,
    "available_points": availablePoints,
    "expired_points": expiredPoints,
    "total_earned_amount": totalEarnedAmount,
    "available_amount": availableAmount,
    "expired_amount": expiredAmount,
    "phone_no": phoneNo,
    "email": email,
    "loyalty_name": loyaltyName,
    "amount_per_point": amountPerPoint,
    "point_value": pointValue,
    "min_redeem_point": minRedeemPoint,
    "redeem_validity_days": redeemValidityDays,
    "bill_count": billCount,
    "last_bill_date": lastBillDate,
  };

  @override
  String toString() {
    return "$loyalityId, $custId, $customerName, "
        "$totalPointsEarned, $totalPointRedeemed, "
        "$availablePoints, $expiredPoints, "
        "$totalEarnedAmount, $availableAmount, "
        "$expiredAmount, $phoneNo, $email, "
        "$loyaltyName, $amountPerPoint, "
        "$pointValue, $minRedeemPoint, "
        "$redeemValidityDays, $billCount, "
        "$lastBillDate";
  }

  @override
  List<Object?> get props => [
    loyalityId,
    custId,
    customerName,
    totalPointsEarned,
    totalPointRedeemed,
    availablePoints,
    expiredPoints,
    totalEarnedAmount,
    availableAmount,
    expiredAmount,
    phoneNo,
    email,
    loyaltyName,
    amountPerPoint,
    pointValue,
    minRedeemPoint,
    redeemValidityDays,
    billCount,
    lastBillDate,
  ];
}
