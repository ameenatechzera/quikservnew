import 'package:quikservnew/core/usecases/general_usecases.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';
import 'package:quikservnew/features/units/domain/repositories/units_repository.dart';

class DeleteUnitUseCase implements UseCaseWithParams<MasterResponseModel, int> {
  final UnitsRepository _unitsRepository;

  DeleteUnitUseCase(this._unitsRepository);

  @override
  ResultFuture<MasterResponseModel> call(int unitId) async {
    return _unitsRepository.deleteUnitFromServer(unitId);
  }
}
