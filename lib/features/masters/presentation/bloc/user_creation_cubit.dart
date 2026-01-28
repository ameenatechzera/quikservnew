import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:quikservnew/features/masters/domain/entities/master_result_response_entity.dart';
import 'package:quikservnew/features/masters/domain/entities/user_types_result.dart';
import 'package:quikservnew/features/masters/domain/parameters/save_user_parameters.dart';
import 'package:quikservnew/features/masters/domain/usecase/fetch_usertypes_usecase.dart';
import 'package:quikservnew/features/masters/domain/usecase/save_usertypes_usecase.dart';

part 'user_creation_state.dart';

class UserCreationCubit extends Cubit<UserCreationState> {
  final FetchUserTypesUseCase _fetchUserTypesUseCase;
  final SaveUserUseCase _saveUserTypesUseCase;
  UserCreationCubit({
    required FetchUserTypesUseCase fetchUserTypesUseCase,
    required SaveUserUseCase saveUserTypesUseCase,
  }) : _fetchUserTypesUseCase = fetchUserTypesUseCase,
       _saveUserTypesUseCase = saveUserTypesUseCase,
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
}
