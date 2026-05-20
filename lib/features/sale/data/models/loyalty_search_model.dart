import 'package:quikservnew/features/sale/domain/entities/loyalty_search_result.dart';

class LoyaltySearchModel extends LoyaltySearchResult{
  LoyaltySearchModel({required super.status, required super.error, required super.data});

  factory LoyaltySearchModel.fromJson(Map<String, dynamic> json){
    return LoyaltySearchModel(
      status: json["status"] ?? 0,
      error: json["error"] ?? false,
      data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );
  }

}