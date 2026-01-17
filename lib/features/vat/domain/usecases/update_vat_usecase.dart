import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';
import 'package:quikservnew/features/vat/domain/parameters/update_vat_parameter.dart';
import 'package:quikservnew/features/vat/domain/repositories/vat_repository.dart';

class EditVatUseCase {
  final VatRepository _vatRepository;

  EditVatUseCase(this._vatRepository);

  ResultFuture<MasterResponseModel> call(
    int vatId,
    EditVatRequestModel request,
  ) async {
    return _vatRepository.updateVatFromServer(vatId, request);
  }
}
