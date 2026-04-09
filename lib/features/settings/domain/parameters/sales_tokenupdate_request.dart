import 'package:equatable/equatable.dart';

class UpdateSalesTokenRequest extends Equatable {
  final String dbname;
  final String branchId;
  final String tokenNo;
  final String userId;

  const UpdateSalesTokenRequest({
    required this.dbname,
    required this.branchId,
    required this.tokenNo,
    required this.userId,
  });

  @override
  List<Object?> get props => [dbname, branchId, tokenNo, userId];

  Map<String, dynamic> toJson() => {
    "db_name": dbname,
    "branchId": branchId,
    "billTokenNo": tokenNo,
    "ModifiedUser": userId,
  };
}
