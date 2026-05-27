import 'package:equatable/equatable.dart';

class LoyaltyCustomerListResult extends Equatable {
  LoyaltyCustomerListResult({required this.success, required this.data});

  final bool success;
  static const String successKey = "success";

  final List<Datum> data;
  static const String dataKey = "data";

  LoyaltyCustomerListResult copyWith({bool? success, List<Datum>? data}) {
    return LoyaltyCustomerListResult(
      success: success ?? this.success,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data.map((x) => x?.toJson()).toList(),
  };

  @override
  String toString() {
    return "$success, $data, ";
  }

  @override
  List<Object?> get props => [success, data];
}

class Datum extends Equatable {
  Datum({
    required this.custId,
    required this.customerName,
    required this.phoneNo,
    required this.email,
    required this.loyalityId,
    required this.createdDate,
    required this.createdUser,
    required this.modifiedDate,
    required this.modifiedUser,
    required this.loyalityName,
  });

  final int custId;
  static const String custIdKey = "custId";

  final String customerName;
  static const String customerNameKey = "customerName";

  final String phoneNo;
  static const String phoneNoKey = "phoneNo";

  final String loyalityName;
  static const String loyalityNameKey = "loyalityName";

  final String email;
  static const String emailKey = "email";

  final int loyalityId;
  static const String loyalityIdKey = "loyalityId";

  final DateTime? createdDate;
  static const String createdDateKey = "createdDate";

  final String createdUser;
  static const String createdUserKey = "createdUser";

  final dynamic modifiedDate;
  static const String modifiedDateKey = "modifiedDate";

  final dynamic modifiedUser;
  static const String modifiedUserKey = "modifiedUser";

  Datum copyWith({
    int? custId,
    String? customerName,
    String? phoneNo,
    String? email,
    int? loyalityId,
    DateTime? createdDate,
    String? createdUser,
    String? loyalityName,
    dynamic? modifiedDate,
    dynamic? modifiedUser,
  }) {
    return Datum(
      custId: custId ?? this.custId,
      customerName: customerName ?? this.customerName,
      phoneNo: phoneNo ?? this.phoneNo,
      email: email ?? this.email,
      loyalityId: loyalityId ?? this.loyalityId,
      createdDate: createdDate ?? this.createdDate,
      createdUser: createdUser ?? this.createdUser,
      modifiedDate: modifiedDate ?? this.modifiedDate,
      modifiedUser: modifiedUser ?? this.modifiedUser,
      loyalityName: loyalityName ?? this.loyalityName,
    );
  }

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      custId: json["custId"] ?? 0,
      customerName: json["customerName"] ?? "",
      phoneNo: json["phoneNo"] ?? "",
      email: json["email"] ?? "",
      loyalityId: json["loyalityId"] ?? 0,
      createdDate: DateTime.tryParse(json["createdDate"] ?? ""),
      createdUser: json["createdUser"] ?? "",
      modifiedDate: json["modifiedDate"],
      modifiedUser: json["modifiedUser"],
      loyalityName: json["loyalityName"],
    );
  }

  Map<String, dynamic> toJson() => {
    "custId": custId,
    "customerName": customerName,
    "phoneNo": phoneNo,
    "email": email,
    "loyalityId": loyalityId,
    "createdDate": createdDate?.toIso8601String(),
    "createdUser": createdUser,
    "modifiedDate": modifiedDate,
    "modifiedUser": modifiedUser,
    "loyalityName": loyalityName,
  };

  @override
  String toString() {
    return "$custId, $customerName, $phoneNo, $email, $loyalityId, $createdDate, $createdUser, $modifiedDate, $modifiedUser, $loyalityName";
  }

  @override
  List<Object?> get props => [
    custId,
    customerName,
    phoneNo,
    email,
    loyalityId,
    createdDate,
    createdUser,
    modifiedDate,
    modifiedUser,
    loyalityName,
  ];
}
