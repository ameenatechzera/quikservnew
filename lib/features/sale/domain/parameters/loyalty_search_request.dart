import 'package:equatable/equatable.dart';

class LoyaltySearchRequest extends Equatable{
  final String search;



  const LoyaltySearchRequest({required this.search });

  @override
  List<Object?> get props => [ search ];

  Map<String, dynamic> toJson() => {

    "search": search,

  };
}