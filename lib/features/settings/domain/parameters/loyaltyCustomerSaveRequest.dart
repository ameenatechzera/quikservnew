import 'package:equatable/equatable.dart';

class LoyaltyCustomerSaveRequest extends Equatable {
final String dbname;
final String branchId;
final String customerName;
final String phoneNo;
final String email;
final String loyaltyId;




const LoyaltyCustomerSaveRequest({
required this.dbname,
required this.branchId,
required this.customerName,
required this.phoneNo,
required this.email,
required this.loyaltyId

});

@override
List<Object?> get props => [dbname, branchId, customerName ,
  phoneNo ,email ,loyaltyId];

Map<String, dynamic> toJson() => {
"db_name": dbname,
"branchId": branchId,
"customerName": customerName,
"phoneNo": phoneNo,
"email": email,
"loyalityId": loyaltyId,


};


}
