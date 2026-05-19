import 'package:quikservnew/features/settings/domain/entities/loyaltyListResult.dart';

class LoyaltyListModel extends LoyaltyCardListResult{
  LoyaltyListModel({required super.success, required super.data});
  factory LoyaltyListModel.fromJson(Map<String, dynamic> json){
    return LoyaltyListModel(
      success: json["success"] ?? false,
      data: json["data"] == null ? [] : List<LoyaltyList>.from(json["data"]!.map((x) => LoyaltyList.fromJson(x))),
    );
  }
}