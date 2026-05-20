import 'package:quikservnew/features/settings/domain/entities/loyalty_customer_entity.dart';

class Loyalty_Customer_Model extends LoyaltyCustomerListResult{
  Loyalty_Customer_Model({required super.success, required super.data});

  factory Loyalty_Customer_Model.fromJson(Map<String, dynamic> json){
    return Loyalty_Customer_Model(
      success: json["success"] ?? false,
      data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );
  }
}