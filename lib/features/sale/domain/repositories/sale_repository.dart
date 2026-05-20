import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/sale/domain/entities/loyalty_search_result.dart';
import 'package:quikservnew/features/sale/domain/entities/sale_save_response_entity.dart';
import 'package:quikservnew/features/sale/domain/parameters/loyalty_search_request.dart';
import 'package:quikservnew/features/sale/domain/parameters/sale_save_request_parameter.dart';

abstract class SalesRepository {
  ResultFuture<SalesResponseEntity> saveSale(SaveSaleRequest request);
  ResultFuture<LoyaltySearchResult> fetchLoyaltyDetailsBySearch(LoyaltySearchRequest request);

}
