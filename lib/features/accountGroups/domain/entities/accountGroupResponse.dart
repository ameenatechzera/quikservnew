import 'package:equatable/equatable.dart';

class AccountGroupResponse extends Equatable {
  AccountGroupResponse({
    required this.status,
    required this.error,
    required this.message,
    required this.data,
  });

  final int status;
  static const String statusKey = "status";

  final bool error;
  static const String errorKey = "error";

  final String message;
  static const String messageKey = "message";

  final List<AccountGroups> data;
  static const String dataKey = "data";


  AccountGroupResponse copyWith({
    int? status,
    bool? error,
    String? message,
    List<AccountGroups>? data,
  }) {
    return AccountGroupResponse(
      status: status ?? this.status,
      error: error ?? this.error,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory AccountGroupResponse.fromJson(Map<String, dynamic> json){
    return AccountGroupResponse(
      status: json["status"] ?? 0,
      error: json["error"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] == null ? [] : List<AccountGroups>.from(json["data"]!.map((x) => AccountGroups.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "error": error,
    "message": message,
    "data": data.map((x) => x?.toJson()).toList(),
  };

  @override
  String toString(){
    return "$status, $error, $message, $data, ";
  }

  @override
  List<Object?> get props => [
    status, error, message, data, ];
}

class AccountGroups extends Equatable {
  AccountGroups({
    required this.groupId,
    required this.accountGroupCode,
    required this.accountGroupName,
    required this.groupUnder,
    required this.groupUnderName,
    required this.narration,
    required this.ledgerNextNo,
    required this.branchId,
    required this.datumDefault,
    required this.createdDate,
    required this.createdUser,
    required this.modifiedDate,
    required this.modifiedUser,
  });

  final int groupId;
  static const String groupIdKey = "groupId";

  final String accountGroupCode;
  static const String accountGroupCodeKey = "AccountGroupCode";

  final String accountGroupName;
  static const String accountGroupNameKey = "accountGroupName";

  final int groupUnder;
  static const String groupUnderKey = "groupUnder";

  final String groupUnderName;
  static const String groupUnderNameKey = "groupUnderName";

  final String narration;
  static const String narrationKey = "narration";

  final int ledgerNextNo;
  static const String ledgerNextNoKey = "LedgerNextNo";

  final dynamic branchId;
  static const String branchIdKey = "branchId";

  final bool datumDefault;
  static const String datumDefaultKey = "default";

  final dynamic createdDate;
  static const String createdDateKey = "CreatedDate";

  final dynamic createdUser;
  static const String createdUserKey = "CreatedUser";

  final dynamic modifiedDate;
  static const String modifiedDateKey = "ModifiedDate";

  final dynamic modifiedUser;
  static const String modifiedUserKey = "ModifiedUser";


  AccountGroups copyWith({
    int? groupId,
    String? accountGroupCode,
    String? accountGroupName,
    int? groupUnder,
    String? groupUnderName,
    String? narration,
    int? ledgerNextNo,
    dynamic? branchId,
    bool? datumDefault,
    dynamic? createdDate,
    dynamic? createdUser,
    dynamic? modifiedDate,
    dynamic? modifiedUser,
  }) {
    return AccountGroups(
      groupId: groupId ?? this.groupId,
      accountGroupCode: accountGroupCode ?? this.accountGroupCode,
      accountGroupName: accountGroupName ?? this.accountGroupName,
      groupUnder: groupUnder ?? this.groupUnder,
      groupUnderName: groupUnderName ?? this.groupUnderName,
      narration: narration ?? this.narration,
      ledgerNextNo: ledgerNextNo ?? this.ledgerNextNo,
      branchId: branchId ?? this.branchId,
      datumDefault: datumDefault ?? this.datumDefault,
      createdDate: createdDate ?? this.createdDate,
      createdUser: createdUser ?? this.createdUser,
      modifiedDate: modifiedDate ?? this.modifiedDate,
      modifiedUser: modifiedUser ?? this.modifiedUser,
    );
  }

  factory AccountGroups.fromJson(Map<String, dynamic> json){
    return AccountGroups(
      groupId: json["groupId"] ?? 0,
      accountGroupCode: json["AccountGroupCode"] ?? "",
      accountGroupName: json["accountGroupName"] ?? "",
      groupUnder: json["groupUnder"] ?? 0,
      groupUnderName: json["groupUnderName"] ?? "",
      narration: json["narration"] ?? "",
      ledgerNextNo: json["LedgerNextNo"] ?? 0,
      branchId: json["branchId"],
      datumDefault: json["default"] ?? false,
      createdDate: json["CreatedDate"],
      createdUser: json["CreatedUser"],
      modifiedDate: json["ModifiedDate"],
      modifiedUser: json["ModifiedUser"],
    );
  }

  Map<String, dynamic> toJson() => {
    "groupId": groupId,
    "AccountGroupCode": accountGroupCode,
    "accountGroupName": accountGroupName,
    "groupUnder": groupUnder,
    "groupUnderName": groupUnderName,
    "narration": narration,
    "LedgerNextNo": ledgerNextNo,
    "branchId": branchId,
    "default": datumDefault,
    "CreatedDate": createdDate,
    "CreatedUser": createdUser,
    "ModifiedDate": modifiedDate,
    "ModifiedUser": modifiedUser,
  };

  @override
  String toString(){
    return "$groupId, $accountGroupCode, $accountGroupName, $groupUnder, $groupUnderName, $narration, $ledgerNextNo, $branchId, $datumDefault, $createdDate, $createdUser, $modifiedDate, $modifiedUser, ";
  }

  @override
  List<Object?> get props => [
    groupId, accountGroupCode, accountGroupName, groupUnder, groupUnderName, narration, ledgerNextNo, branchId, datumDefault, createdDate, createdUser, modifiedDate, modifiedUser, ];
}
