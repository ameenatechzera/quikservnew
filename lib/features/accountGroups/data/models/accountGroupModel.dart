import 'package:quikservnew/features/accountGroups/domain/entities/accountGroupResponse.dart';

class AccountGroupModel extends AccountGroupResponse{
  AccountGroupModel({required super.status, required super.error, required super.message, required super.data});

  factory AccountGroupModel.fromJson(Map<String, dynamic> json){
    return AccountGroupModel(
      status: json["status"] ?? 0,
      error: json["error"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] == null ? [] : List<AccountGroups>.from(json["data"]!.map((x) => AccountGroups.fromJson(x))),
    );
  }

}