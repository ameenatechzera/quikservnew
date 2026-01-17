import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';
import 'package:quikservnew/features/units/data/models/fetch_unit_model.dart';
import 'package:quikservnew/features/units/domain/parameters/save_unit_parameter.dart';
import 'package:quikservnew/features/units/domain/parameters/update_unit_parameter.dart';
import 'package:quikservnew/features/units/domain/usecases/delete_unit_fromserver_usecase.dart';
import 'package:quikservnew/features/units/domain/usecases/fetch_unitsfromserver_usecase.dart';
import 'package:quikservnew/features/units/domain/usecases/save_unit_toserver_usecase.dart';
import 'package:quikservnew/features/units/domain/usecases/update_unit_usecase.dart';

part 'unit_state.dart';

class UnitCubit extends Cubit<UnitState> {
  final FetchUnitsUseCase _fetchUnitsUseCase;
  final SaveUnitUseCase _saveUnitUseCase;
  final DeleteUnitUseCase _deleteUnitUseCase;
  final EditUnitUseCase _editUnitUseCase;

  UnitCubit({
    required FetchUnitsUseCase fetchUnitsUseCase,
    required SaveUnitUseCase saveUnitUseCase,
    required DeleteUnitUseCase deleteUnitUseCase,
    required EditUnitUseCase editUnitUseCase,
  }) : _fetchUnitsUseCase = fetchUnitsUseCase,
       _saveUnitUseCase = saveUnitUseCase,
       _deleteUnitUseCase = deleteUnitUseCase,
       _editUnitUseCase = editUnitUseCase,
       super(UnitInitial());

  /// 🔥 Called this method to fetch units
  Future<void> fetchUnits() async {
    emit(UnitLoading());

    final response = await _fetchUnitsUseCase();

    response.fold(
      (failure) => emit(UnitError(error: failure.message)),
      (response) => emit(UnitLoaded(units: response)),
    );
  }

  /// 🔹 Save a new unit with its own loading/error states
  Future<void> saveUnit(SaveUnitRequestModel request) async {
    emit(UnitSaveLoading());
    final response = await _saveUnitUseCase(request);
    response.fold(
      (failure) => emit(UnitSaveError(error: failure.message)),
      (response) => emit(UnitSaved(response: response)),
    );

    // Optionally refresh the list after saving
    await fetchUnits();
  } /* ================= DELETE ================= */

  Future<void> deleteUnit(int unitId) async {
    emit(UnitDeleteLoading());

    final result = await _deleteUnitUseCase(unitId);

    result.fold(
      (failure) => emit(UnitDeleteError(error: failure.message)),
      (success) => emit(UnitDeleted(response: success)),
    );
    // await fetchUnits();
  }

  /// ================= EDIT =================
  Future<void> editUnit(int unitId, EditUnitRequestModel request) async {
    emit(UnitEditLoading());

    final result = await _editUnitUseCase(unitId, request);

    result.fold(
      (failure) => emit(UnitEditError(error: failure.message)),
      (success) => emit(UnitEdited(response: success)),
    );

    await fetchUnits();
  }
}
