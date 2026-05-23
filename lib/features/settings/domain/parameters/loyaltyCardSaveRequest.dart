import 'package:equatable/equatable.dart';

class LoyaltyCardSaveRequest extends Equatable {
  final String dbname;
  final String branchId;
  final String tokenNo;
  final String loyaltyName;
  final String amountPerPoint;
  final String minRedeemPoint;
  final String redeemValidityDays;
  final String activeStatus;
  final String pointValue;



  const LoyaltyCardSaveRequest({
    required this.dbname,
    required this.branchId,
    required this.tokenNo,
    required this.loyaltyName,
    required this.amountPerPoint,
    required this.minRedeemPoint,
    required this.redeemValidityDays,
    required this.activeStatus,
    required this.pointValue

  });

  @override
  List<Object?> get props => [dbname, branchId, tokenNo, loyaltyName ,
    amountPerPoint ,minRedeemPoint , redeemValidityDays ,activeStatus, pointValue];

  Map<String, dynamic> toJson() => {
    "db_name": dbname,
    "branchId": branchId,
    "billTokenNo": tokenNo,
    "loyalityName": loyaltyName,
    "amountPerPoint": amountPerPoint,
    "minRedeemPoint": minRedeemPoint,
    "redeemValidityDays": redeemValidityDays,
    "activeStatus": activeStatus,
    "pointValue":pointValue

  };


}
