import 'package:equatable/equatable.dart';

class UserTypesResult extends Equatable {
  UserTypesResult({
    required this.status,
    required this.error,
    required this.message,
    required this.details,
  });

  final int status;
  static const String statusKey = "status";

  final bool error;
  static const String errorKey = "error";

  final String message;
  static const String messageKey = "message";

  final List<UserTypes> details;
  static const String detailsKey = "details";


  UserTypesResult copyWith({
    int? status,
    bool? error,
    String? message,
    List<UserTypes>? details,
  }) {
    return UserTypesResult(
      status: status ?? this.status,
      error: error ?? this.error,
      message: message ?? this.message,
      details: details ?? this.details,
    );
  }

  factory UserTypesResult.fromJson(Map<String, dynamic> json){
    return UserTypesResult(
      status: json["status"] ?? 0,
      error: json["error"] ?? false,
      message: json["message"] ?? "",
      details: json["details"] == null ? [] : List<UserTypes>.from(json["details"]!.map((x) => UserTypes.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "error": error,
    "message": message,
    "details": details.map((x) => x?.toJson()).toList(),
  };

  @override
  String toString(){
    return "$status, $error, $message, $details, ";
  }

  @override
  List<Object?> get props => [
    status, error, message, details, ];
}

class UserTypes extends Equatable {
  UserTypes({
    required this.typeId,
    required this.userType,
    required this.activeStatus,
    required this.branchId,
    required this.createdDate,
    required this.createdUser,
    required this.modifiedDate,
    required this.modifiedUser,
  });

  final int typeId;
  static const String typeIdKey = "typeId";

  final String userType;
  static const String userTypeKey = "userType";

  final int activeStatus;
  static const String activeStatusKey = "active_status";

  final int branchId;
  static const String branchIdKey = "branchId";

  final dynamic createdDate;
  static const String createdDateKey = "CreatedDate";

  final dynamic createdUser;
  static const String createdUserKey = "CreatedUser";

  final dynamic modifiedDate;
  static const String modifiedDateKey = "ModifiedDate";

  final dynamic modifiedUser;
  static const String modifiedUserKey = "ModifiedUser";


  UserTypes copyWith({
    int? typeId,
    String? userType,
    int? activeStatus,
    int? branchId,
    dynamic? createdDate,
    dynamic? createdUser,
    dynamic? modifiedDate,
    dynamic? modifiedUser,
  }) {
    return UserTypes(
      typeId: typeId ?? this.typeId,
      userType: userType ?? this.userType,
      activeStatus: activeStatus ?? this.activeStatus,
      branchId: branchId ?? this.branchId,
      createdDate: createdDate ?? this.createdDate,
      createdUser: createdUser ?? this.createdUser,
      modifiedDate: modifiedDate ?? this.modifiedDate,
      modifiedUser: modifiedUser ?? this.modifiedUser,
    );
  }

  factory UserTypes.fromJson(Map<String, dynamic> json){
    return UserTypes(
      typeId: json["typeId"] ?? 0,
      userType: json["userType"] ?? "",
      activeStatus: json["active_status"] ?? 0,
      branchId: json["branchId"] ?? 0,
      createdDate: json["CreatedDate"],
      createdUser: json["CreatedUser"],
      modifiedDate: json["ModifiedDate"],
      modifiedUser: json["ModifiedUser"],
    );
  }

  Map<String, dynamic> toJson() => {
    "typeId": typeId,
    "userType": userType,
    "active_status": activeStatus,
    "branchId": branchId,
    "CreatedDate": createdDate,
    "CreatedUser": createdUser,
    "ModifiedDate": modifiedDate,
    "ModifiedUser": modifiedUser,
  };

  @override
  String toString(){
    return "$typeId, $userType, $activeStatus, $branchId, $createdDate, $createdUser, $modifiedDate, $modifiedUser, ";
  }

  @override
  List<Object?> get props => [
    typeId, userType, activeStatus, branchId, createdDate, createdUser, modifiedDate, modifiedUser, ];
}
