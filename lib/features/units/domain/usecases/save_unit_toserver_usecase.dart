import 'package:quikservnew/core/usecases/general_usecases.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';
import 'package:quikservnew/features/units/domain/parameters/save_unit_parameter.dart';
import 'package:quikservnew/features/units/domain/repositories/units_repository.dart';

class SaveUnitUseCase
    implements UseCaseWithParams<MasterResponseModel, SaveUnitRequestModel> {
  final UnitsRepository _unitsRepository;

  SaveUnitUseCase(this._unitsRepository);

  @override
  ResultFuture<MasterResponseModel> call(SaveUnitRequestModel params) async {
    return _unitsRepository.saveUnitToSServer(params); // ✅ Correct type
  }
}
