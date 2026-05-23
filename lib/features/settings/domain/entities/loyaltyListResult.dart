import 'package:equatable/equatable.dart';

class LoyaltyCardListResult extends Equatable {
  LoyaltyCardListResult({
    required this.success,
    required this.data,
  });

  final bool success;
  static const String successKey = "success";

  final List<LoyaltyList> data;
  static const String dataKey = "data";


  LoyaltyCardListResult copyWith({
    bool? success,
    List<LoyaltyList>? data,
  }) {
    return LoyaltyCardListResult(
      success: success ?? this.success,
      data: data ?? this.data,
    );
  }

  factory LoyaltyCardListResult.fromJson(Map<String, dynamic> json){
    return LoyaltyCardListResult(
      success: json["success"] ?? false,
      data: json["data"] == null ? [] : List<LoyaltyList>.from(json["data"]!.map((x) => LoyaltyList.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data.map((x) => x?.toJson()).toList(),
  };

  @override
  String toString(){
    return "$success, $data, ";
  }

  @override
  List<Object?> get props => [
    success, data, ];
}

class LoyaltyList extends Equatable {
  LoyaltyList({
    required this.loyalityId,
    required this.loyalityName,
    required this.amountPerPoint,
    required this.minRedeemPoint,
    required this.redeemValidityDays,
    required this.activeStatus,
    required this.createdUser,
    required this.createdDate,
    required this.modifiedUser,
    required this.modifiedDate,
  });

  final int loyalityId;
  static const String loyalityIdKey = "loyalityId";

  final String loyalityName;
  static const String loyalityNameKey = "loyalityName";

  final String amountPerPoint;
  static const String amountPerPointKey = "amountPerPoint";

  final String minRedeemPoint;
  static const String minRedeemPointKey = "minRedeemPoint";

  final int redeemValidityDays;
  static const String redeemValidityDaysKey = "redeemValidityDays";

  final bool activeStatus;
  static const String activeStatusKey = "activeStatus";

  final String createdUser;
  static const String createdUserKey = "createdUser";

  final DateTime? createdDate;
  static const String createdDateKey = "createdDate";

  final String modifiedUser;
  static const String modifiedUserKey = "modifiedUser";

  final DateTime? modifiedDate;
  static const String modifiedDateKey = "modifiedDate";


  LoyaltyList copyWith({
    int? loyalityId,
    String? loyalityName,
    String? amountPerPoint,
    String? minRedeemAmt,
    int? redeemValidityDays,
    bool? activeStatus,
    String? createdUser,
    DateTime? createdDate,
    String? modifiedUser,
    DateTime? modifiedDate,
  }) {
    return LoyaltyList(
      loyalityId: loyalityId ?? this.loyalityId,
      loyalityName: loyalityName ?? this.loyalityName,
      amountPerPoint: amountPerPoint ?? this.amountPerPoint,
      minRedeemPoint: minRedeemAmt ?? this.minRedeemPoint,
      redeemValidityDays: redeemValidityDays ?? this.redeemValidityDays,
      activeStatus: activeStatus ?? this.activeStatus,
      createdUser: createdUser ?? this.createdUser,
      createdDate: createdDate ?? this.createdDate,
      modifiedUser: modifiedUser ?? this.modifiedUser,
      modifiedDate: modifiedDate ?? this.modifiedDate,
    );
  }

  factory LoyaltyList.fromJson(Map<String, dynamic> json){
    return LoyaltyList(
      loyalityId: json["loyalityId"] ?? 0,
      loyalityName: json["loyalityName"] ?? "",
      amountPerPoint: json["amountPerPoint"] ?? "",
      minRedeemPoint: json["minRedeemPoint"] ?? "",
      redeemValidityDays: json["redeemValidityDays"] ?? 0,
      activeStatus: json["activeStatus"] ?? false,
      createdUser: json["createdUser"] ?? "",
      createdDate: DateTime.tryParse(json["createdDate"] ?? ""),
      modifiedUser: json["modifiedUser"] ?? "",
      modifiedDate: DateTime.tryParse(json["modifiedDate"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "loyalityId": loyalityId,
    "loyalityName": loyalityName,
    "amountPerPoint": amountPerPoint,
    "minRedeemPoint": minRedeemPoint,
    "redeemValidityDays": redeemValidityDays,
    "activeStatus": activeStatus,
    "createdUser": createdUser,
    "createdDate": createdDate?.toIso8601String(),
    "modifiedUser": modifiedUser,
    "modifiedDate": modifiedDate?.toIso8601String(),
  };

  @override
  String toString(){
    return "$loyalityId, $loyalityName, $amountPerPoint, $minRedeemPoint, $redeemValidityDays, $activeStatus, $createdUser, $createdDate, $modifiedUser, $modifiedDate, ";
  }

  @override
  List<Object?> get props => [
    loyalityId, loyalityName, amountPerPoint, minRedeemPoint, redeemValidityDays, activeStatus, createdUser, createdDate, modifiedUser, modifiedDate, ];
}
