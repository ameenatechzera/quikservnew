import 'package:quikservnew/core/usecases/general_usecases.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/vat/domain/entities/add_vat_entity.dart';
import 'package:quikservnew/features/vat/domain/repositories/vat_repository.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';

class AddVatUseCase
    implements UseCaseWithParams<MasterResponseModel, AddVatRequestModel> {
  final VatRepository _vatRepository;

  AddVatUseCase(this._vatRepository);

  @override
  ResultFuture<MasterResponseModel> call(AddVatRequestModel params) async {
    return _vatRepository.addVat(params);
  }
}
