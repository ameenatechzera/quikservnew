import 'package:quikservnew/features/masters/domain/entities/user_types_result.dart';

class UserTypesModel extends UserTypesResult{
  UserTypesModel({required super.status, required super.error, required super.message, required super.details});

  factory UserTypesModel.fromJson(Map<String, dynamic> json){
    return UserTypesModel(
      status: json["status"] ?? 0,
      error: json["error"] ?? false,
      message: json["message"] ?? "",
      details: json["details"] == null ? [] : List<UserTypes>.from(json["details"]!.map((x) => UserTypes.fromJson(x))),
    );
  }
}