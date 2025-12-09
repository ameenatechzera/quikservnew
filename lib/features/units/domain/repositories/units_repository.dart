import 'package:quikservnew/core/utils/typedef.dart';
import 'package:quikservnew/features/units/data/models/fetch_unit_model.dart';

abstract class UnitsRepository {
  ResultFuture<FetchUnitResponseModel> fetchUnits();
}
