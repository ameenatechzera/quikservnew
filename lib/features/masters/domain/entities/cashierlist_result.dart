import 'package:equatable/equatable.dart';

class CashierListResponse extends Equatable {
  CashierListResponse({
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

  final List<CashierList> details;
  static const String detailsKey = "details";

  CashierListResponse copyWith({
    int? status,
    bool? error,
    String? message,
    List<CashierList>? details,
  }) {
    return CashierListResponse(
      status: status ?? this.status,
      error: error ?? this.error,
      message: message ?? this.message,
      details: details ?? this.details,
    );
  }

  factory CashierListResponse.fromJson(Map<String, dynamic> json) {
    return CashierListResponse(
      status: json["status"] ?? 0,
      error: json["error"] ?? false,
      message: json["message"] ?? "",
      details: json["details"] == null
          ? []
          : List<CashierList>.from(
              json["details"]!.map((x) => CashierList.fromJson(x)),
            ),
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "error": error,
    "message": message,
    "details": details.map((x) => x.toJson()).toList(),
  };

  @override
  String toString() {
    return "$status, $error, $message, $details, ";
  }

  @override
  List<Object?> get props => [status, error, message, details];
}

class CashierList extends Equatable {
  CashierList({
    required this.id,
    required this.userType,
    required this.username,
    required this.password,
    required this.isactive,
    required this.name,
    required this.createdDate,
    required this.createdUser,
    required this.modifiedDate,
    required this.modifiedUser,
  });

  final int id;
  static const String idKey = "id";

  final int userType;
  static const String userTypeKey = "user_type";

  final String username;
  static const String usernameKey = "username";

  final String password;
  static const String passwordKey = "password";

  final int isactive;
  static const String isactiveKey = "isactive";

  final String name;
  static const String nameKey = "name";

  final dynamic createdDate;
  static const String createdDateKey = "CreatedDate";

  final dynamic createdUser;
  static const String createdUserKey = "CreatedUser";

  final dynamic modifiedDate;
  static const String modifiedDateKey = "ModifiedDate";

  final dynamic modifiedUser;
  static const String modifiedUserKey = "ModifiedUser";

  CashierList copyWith({
    int? id,
    int? userType,
    String? username,
    String? password,
    int? isactive,
    String? name,
    dynamic createdDate,
    dynamic createdUser,
    dynamic modifiedDate,
    dynamic modifiedUser,
  }) {
    return CashierList(
      id: id ?? this.id,
      userType: userType ?? this.userType,
      username: username ?? this.username,
      password: password ?? this.password,
      isactive: isactive ?? this.isactive,
      name: name ?? this.name,
      createdDate: createdDate ?? this.createdDate,
      createdUser: createdUser ?? this.createdUser,
      modifiedDate: modifiedDate ?? this.modifiedDate,
      modifiedUser: modifiedUser ?? this.modifiedUser,
    );
  }

  factory CashierList.fromJson(Map<String, dynamic> json) {
    return CashierList(
      id: json["id"] ?? 0,
      userType: json["user_type"] ?? 0,
      username: json["username"] ?? "",
      password: json["password"] ?? "",
      isactive: json["isactive"] ?? 0,
      name: json["name"] ?? "",
      createdDate: json["CreatedDate"],
      createdUser: json["CreatedUser"],
      modifiedDate: json["ModifiedDate"],
      modifiedUser: json["ModifiedUser"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_type": userType,
    "username": username,
    "password": password,
    "isactive": isactive,
    "name": name,
    "CreatedDate": createdDate,
    "CreatedUser": createdUser,
    "ModifiedDate": modifiedDate,
    "ModifiedUser": modifiedUser,
  };

  @override
  String toString() {
    return "$id, $userType, $username, $password, $isactive, $name, $createdDate, $createdUser, $modifiedDate, $modifiedUser, ";
  }

  @override
  List<Object?> get props => [
    id,
    userType,
    username,
    password,
    isactive,
    name,
    createdDate,
    createdUser,
    modifiedDate,
    modifiedUser,
  ];
}
