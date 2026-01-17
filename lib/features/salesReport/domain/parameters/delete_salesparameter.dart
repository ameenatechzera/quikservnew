import 'package:equatable/equatable.dart';

class SalesDeleteByMasterIdRequest extends Equatable{
  final String masterId;



  const SalesDeleteByMasterIdRequest({required this.masterId });

  @override
  List<Object?> get props => [ masterId ];

  Map<String, dynamic> toJson() => {

    "SalesMasterId": masterId,

  };
}