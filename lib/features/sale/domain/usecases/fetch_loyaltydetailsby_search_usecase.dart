import 'package:quikservnew/core/usecases/general_usecases.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/sale/domain/entities/loyalty_search_result.dart';
import 'package:quikservnew/features/sale/domain/parameters/loyalty_search_request.dart';
import 'package:quikservnew/features/sale/domain/repositories/sale_repository.dart';

class FetchLoyaltyDetailsBySearchUseCase
    implements UseCaseWithParams<LoyaltySearchResult, LoyaltySearchRequest> {
  final SalesRepository _salesRepository;

  FetchLoyaltyDetailsBySearchUseCase(this._salesRepository);

  @override
  ResultFuture<LoyaltySearchResult> call(LoyaltySearchRequest params) async {
    return _salesRepository.fetchLoyaltyDetailsBySearch(params);
  }
}