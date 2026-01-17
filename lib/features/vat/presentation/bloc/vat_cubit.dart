import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';
import 'package:quikservnew/features/vat/data/models/fetch_vat_model.dart';
import 'package:quikservnew/features/vat/domain/entities/add_vat_entity.dart';
import 'package:quikservnew/features/vat/domain/parameters/update_vat_parameter.dart';
import 'package:quikservnew/features/vat/domain/usecases/add_vat_usecase.dart';
import 'package:quikservnew/features/vat/domain/usecases/delete_vat_usecase.dart';
import 'package:quikservnew/features/vat/domain/usecases/fetch_vat_usecase.dart';
import 'package:quikservnew/features/vat/domain/usecases/update_vat_usecase.dart';

part 'vat_state.dart';

class VatCubit extends Cubit<VatState> {
  final FetchVatUseCase _fetchVatUseCase;
  final AddVatUseCase _addVatUseCase;
  final DeleteVatUseCase _deleteVatUseCase;
  final EditVatUseCase _editVatUseCase;

  VatCubit({
    required FetchVatUseCase fetchVatUseCase,
    required AddVatUseCase addVatUseCase,
    required DeleteVatUseCase deleteVatUseCase,
    required EditVatUseCase editVatUseCase,
  }) : _fetchVatUseCase = fetchVatUseCase,
       _addVatUseCase = addVatUseCase,
       _deleteVatUseCase = deleteVatUseCase,
       _editVatUseCase = editVatUseCase,
       super(VatInitial());

  /// 🔥 Call this method to fetch VAT
  Future<void> fetchVat() async {
    emit(VatLoading());

    final response = await _fetchVatUseCase();

    response.fold(
      (failure) => emit(VatError(error: failure.message)),
      (response) => emit(VatLoaded(vat: response)),
    );
  }

  /// 🔹 Add VAT (same structure as fetchVat)
  Future<void> addVat(AddVatRequestModel request) async {
    emit(VatAddLoading());

    final response = await _addVatUseCase(request);

    response.fold(
      (failure) => emit(VatAddError(error: failure.message)),
      (response) => emit(VatAdded(response: response)),
    );
    await fetchVat();
  }

  /// 🔹 Delete VAT
  Future<void> deleteVat(int vatId) async {
    emit(VatDeleteLoading());

    final response = await _deleteVatUseCase(vatId);

    response.fold(
      (failure) => emit(VatDeleteError(error: failure.message)),
      (response) => emit(VatDeleted(response: response)),
    );

    await fetchVat(); // refresh after deletion
  }

  /// 🔹 Update VAT
  Future<void> updateVat(int vatId, EditVatRequestModel request) async {
    emit(VatEditLoading());

    final response = await _editVatUseCase(vatId, request);

    response.fold(
      (failure) => emit(VatEditError(error: failure.message)),
      (response) => emit(VatEdited(response: response)),
    );

    await fetchVat(); // refresh after update
  }
}
