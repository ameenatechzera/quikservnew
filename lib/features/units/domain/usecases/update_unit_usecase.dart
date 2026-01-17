import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';
import 'package:quikservnew/features/units/domain/parameters/update_unit_parameter.dart';
import 'package:quikservnew/features/units/domain/repositories/units_repository.dart';

class EditUnitUseCase {
  final UnitsRepository _unitsRepository;

  EditUnitUseCase(this._unitsRepository);

  ResultFuture<MasterResponseModel> call(
    int unitId,
    EditUnitRequestModel request,
  ) async {
    return _unitsRepository.updateUnitFromServer(unitId, request);
  }
}
