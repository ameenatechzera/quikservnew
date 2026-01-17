import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';
import 'package:quikservnew/features/units/data/models/fetch_unit_model.dart';
import 'package:quikservnew/features/units/domain/parameters/save_unit_parameter.dart';
import 'package:quikservnew/features/units/domain/parameters/update_unit_parameter.dart';

abstract class UnitsRepository {
  ResultFuture<FetchUnitResponseModel> fetchUnits();
  ResultFuture<MasterResponseModel> saveUnitToSServer(
    SaveUnitRequestModel request,
  );
  ResultFuture<MasterResponseModel> deleteUnitFromServer(int unitId);
  ResultFuture<MasterResponseModel> updateUnitFromServer(
    int unitId,
    EditUnitRequestModel request,
  );
}
