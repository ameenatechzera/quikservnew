import 'package:equatable/equatable.dart';

class LoyaltyCardSaveResult extends Equatable {
  LoyaltyCardSaveResult({
    required this.success,
    required this.loyalityId,
  });

  final bool success;
  static const String successKey = "success";

  final int loyalityId;
  static const String loyalityIdKey = "loyalityId";


  LoyaltyCardSaveResult copyWith({
    bool? success,
    int? loyalityId,
  }) {
    return LoyaltyCardSaveResult(
      success: success ?? this.success,
      loyalityId: loyalityId ?? this.loyalityId,
    );
  }

  factory LoyaltyCardSaveResult.fromJson(Map<String, dynamic> json){
    return LoyaltyCardSaveResult(
      success: json["success"] ?? false,
      loyalityId: json["loyalityId"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "loyalityId": loyalityId,
  };

  @override
  String toString(){
    return "$success, $loyalityId, ";
  }

  @override
  List<Object?> get props => [
    success, loyalityId, ];
}
