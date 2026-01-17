
import 'package:equatable/equatable.dart';

class
UpdateSalesTokenRequest extends Equatable{
  final String db_name;
  final String branchId;
  final String tokenNo;
  final String userId;


  const UpdateSalesTokenRequest({ required this.db_name , required this.branchId , required this.tokenNo, required this.userId});



  @override
  List<Object?> get props => [  db_name, branchId ,tokenNo,userId];


  Map<String, dynamic> toJson() => {
    "db_name": db_name,
    "branchId": branchId,
    "billTokenNo":tokenNo,
    "ModifiedUser": userId

  };
}