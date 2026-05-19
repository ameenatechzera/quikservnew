import 'package:equatable/equatable.dart';

class LoyaltyCardSaveRequest extends Equatable {
  final String dbname;
  final String branchId;
  final String tokenNo;
  final String loyaltyName;
  final String amountPerPoint;
  final String minRedeemAmt;
  final String redeemValidityDays;
  final String activeStatus;



  const LoyaltyCardSaveRequest({
    required this.dbname,
    required this.branchId,
    required this.tokenNo,
    required this.loyaltyName,
    required this.amountPerPoint,
    required this.minRedeemAmt,
    required this.redeemValidityDays,
    required this.activeStatus,

  });

  @override
  List<Object?> get props => [dbname, branchId, tokenNo, loyaltyName ,
    amountPerPoint ,minRedeemAmt , redeemValidityDays ,activeStatus];

  Map<String, dynamic> toJson() => {
    "db_name": dbname,
    "branchId": branchId,
    "billTokenNo": tokenNo,
    "loyalityName": loyaltyName,
    "amountPerPoint": amountPerPoint,
    "minRedeemAmt": minRedeemAmt,
    "redeemValidityDays": redeemValidityDays,
    "activeStatus": activeStatus,

  };


}
