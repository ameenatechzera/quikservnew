part of 'user_creation_cubit.dart';

@immutable
sealed class UserCreationState {}

final class UserCreationInitial extends UserCreationState {}

final class FetchUserTypesInitial extends UserCreationState {}

final class SaveUserInitial extends UserCreationState {}

class FetchUserTypesFailure extends UserCreationState {
  final String error;

   FetchUserTypesFailure(this.error);
}
class SaveUserFailure extends UserCreationState {
  final String error;

  SaveUserFailure(this.error);
}
class FetchUserTypesLoaded extends UserCreationState {
  final List<UserTypes> userTypes;

  FetchUserTypesLoaded({required this.userTypes});

}
class SaveUserCompleted extends UserCreationState {
  final MasterResponseModel result;

  SaveUserCompleted({required this.result});

}