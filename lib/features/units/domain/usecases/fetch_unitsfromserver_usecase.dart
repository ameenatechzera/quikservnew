import 'package:quikservnew/core/usecases/general_usecases.dart';
import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/units/data/models/fetch_unit_model.dart';
import 'package:quikservnew/features/units/domain/repositories/units_repository.dart';

class FetchUnitsUseCase
    implements UseCaseWithoutParams<FetchUnitResponseModel> {
  final UnitsRepository _unitsRepository;

  FetchUnitsUseCase(this._unitsRepository);

  @override
  ResultFuture<FetchUnitResponseModel> call() async {
    return _unitsRepository.fetchUnits();
  }
}
