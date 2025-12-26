import 'package:quikservnew/core/usecases/general_usecases.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/sale/domain/entities/sale_save_response_entity.dart';
import 'package:quikservnew/features/sale/domain/parameters/sale_save_request_parameter.dart';
import 'package:quikservnew/features/sale/domain/repositories/sale_repository.dart';

class SaveSaleUseCase
    implements UseCaseWithParams<SalesResponseEntity, SaveSaleRequest> {
  final SalesRepository _salesRepository;

  SaveSaleUseCase(this._salesRepository);

  @override
  ResultFuture<SalesResponseEntity> call(SaveSaleRequest params) async {
    return _salesRepository.saveSale(params);
  }
}
