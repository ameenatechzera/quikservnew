part of 'user_creation_cubit.dart';

@immutable
sealed class UserCreationState {}

final class UserCreationInitial extends UserCreationState {}

final class FetchUserTypesInitial extends UserCreationState {}

final class FetchCashierListInitial extends UserCreationState {}

final class FetchSupplierListInitial extends UserCreationState {}

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

class FetchUserTypesFromCreationLoaded extends UserCreationState {
  final List<UserTypes> userTypes;

  FetchUserTypesFromCreationLoaded({required this.userTypes});

}
class SaveUserCompleted extends UserCreationState {
  final MasterResponseModel result;

  SaveUserCompleted({required this.result});

}

class FetchCashierListLoaded extends UserCreationState {
  final List<CashierList> cashierList;

  FetchCashierListLoaded({required this.cashierList});

}
class FetchSupplierListLoaded extends UserCreationState {
  final List<SupplierList> supplierList;

  FetchSupplierListLoaded({required this.supplierList});

}
class FetchCashierListFailure extends UserCreationState {
  final String error;

  FetchCashierListFailure(this.error);
}

class FetchSupplierListFailure extends UserCreationState {
  final String error;

  FetchSupplierListFailure(this.error);
}