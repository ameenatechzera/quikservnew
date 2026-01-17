import 'package:quikservnew/core/usecases/general_usecases.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/vat/domain/repositories/vat_repository.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';

class DeleteVatUseCase implements UseCaseWithParams<MasterResponseModel, int> {
  final VatRepository _vatRepository;

  DeleteVatUseCase(this._vatRepository);

  @override
  ResultFuture<MasterResponseModel> call(int vatId) async {
    return _vatRepository.deleteVat(vatId);
  }
}
