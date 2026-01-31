import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:quikservnew/features/masters/domain/entities/cashierlist_result.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';
import 'package:quikservnew/features/masters/domain/entities/supplierlist_result.dart';
import 'package:quikservnew/features/masters/domain/entities/user_types_result.dart';
import 'package:quikservnew/features/masters/domain/parameters/save_user_parameters.dart';
import 'package:quikservnew/features/masters/domain/usecase/fetch_cashierlist_usecase.dart';
import 'package:quikservnew/features/masters/domain/usecase/fetch_supplierlist_usecase.dart';
import 'package:quikservnew/features/masters/domain/usecase/fetch_usertypes_usecase.dart';
import 'package:quikservnew/features/masters/domain/usecase/save_usertypes_usecase.dart';

part 'user_creation_state.dart';

class UserCreationCubit extends Cubit<UserCreationState> {
  final FetchUserTypesUseCase _fetchUserTypesUseCase;
  final SaveUserUseCase _saveUserTypesUseCase;
  final FetchSupplierListUseCase _fetchSupplierListUseCase;
  final FetchCashierListUseCase _fetchCashierListUseCase;
  UserCreationCubit({
    required FetchUserTypesUseCase fetchUserTypesUseCase,
    required SaveUserUseCase saveUserTypesUseCase,
    required FetchSupplierListUseCase fetchSupplierListUseCase,
    required FetchCashierListUseCase fetchCashierListUseCase,
  }) : _fetchUserTypesUseCase = fetchUserTypesUseCase,
       _saveUserTypesUseCase = saveUserTypesUseCase,
       _fetchSupplierListUseCase = fetchSupplierListUseCase,
       _fetchCashierListUseCase = fetchCashierListUseCase,
       super(UserCreationInitial());
  // --------------------- API Fetch ---------------------
  Future<void> fetchUserTypes() async {
    emit(FetchUserTypesInitial());

    try {
      final result = await _fetchUserTypesUseCase();

      result.fold(
        (failure) {
          emit(FetchUserTypesFailure(failure.message));
        },
        (userTypeResponse) {
          emit(FetchUserTypesLoaded(userTypes: userTypeResponse.details));
        },
      );
    } catch (e, stacktrace) {
      // Handle unexpected exceptions
      print('❌ Exception during loginUser: $e');
      print('Stacktrace: $stacktrace');
      emit(FetchUserTypesFailure('An unexpected error occurred'));
    }
  }

  // --------------------- API Fetch User types---------------------
  Future<void> fetchUserTypesFromUserCreation() async {
    emit(FetchUserTypesInitial());

    try {
      final result = await _fetchUserTypesUseCase();

      result.fold(
        (failure) {
          emit(FetchUserTypesFailure(failure.message));
        },
        (userTypeResponse) {
          emit(
            FetchUserTypesFromCreationLoaded(
              userTypes: userTypeResponse.details,
            ),
          );
        },
      );
    } catch (e, stacktrace) {
      // Handle unexpected exceptions
      print('❌ Exception during loginUser: $e');
      print('Stacktrace: $stacktrace');
      emit(FetchUserTypesFailure('An unexpected error occurred'));
    }
  }

  // --------------------- API Save User ---------------------
  Future<void> saveUser(SaveUserParameters request) async {
    emit(SaveUserInitial());

    try {
      final response = await _saveUserTypesUseCase(request);

      response.fold((failure) => emit(SaveUserFailure(failure.message)), (
        response,
      ) {
        emit(SaveUserCompleted(result: response));
      });
    } catch (e, stacktrace) {
      // Handle unexpected exceptions
      print('❌ Exception during loginUser: $e');
      print('Stacktrace: $stacktrace');
      emit(SaveUserFailure('An unexpected error occurred'));
    }
  }

  // --------------------- API Fetch Suppliers ---------------------
  Future<void> fetchSupplierList() async {
    emit(FetchSupplierListInitial());

    try {
      final result = await _fetchSupplierListUseCase();

      result.fold(
        (failure) {
          emit(FetchSupplierListFailure(failure.message));
        },
        (supplierListResponse) {
          emit(
            FetchSupplierListLoaded(supplierList: supplierListResponse.details),
          );
        },
      );
    } catch (e, stacktrace) {
      // Handle unexpected exceptions
      print('❌ Exception during loginUser: $e');
      print('Stacktrace: $stacktrace');
      emit(FetchSupplierListFailure('An unexpected error occurred'));
    }
  }

  // --------------------- API Fetch Cashiers ---------------------
  Future<void> fetchCashierList() async {
    emit(FetchCashierListInitial());

    try {
      final result = await _fetchCashierListUseCase();

      result.fold(
        (failure) {
          emit(FetchUserTypesFailure(failure.message));
        },
        (cashierResponse) {
          emit(FetchCashierListLoaded(cashierList: cashierResponse.details));
        },
      );
    } catch (e, stacktrace) {
      // Handle unexpected exceptions
      print('❌ Exception during loginUser: $e');
      print('Stacktrace: $stacktrace');
      emit(FetchUserTypesFailure('An unexpected error occurred'));
    }
  }
}
