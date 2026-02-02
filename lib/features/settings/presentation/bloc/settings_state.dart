part of 'settings_cubit.dart';

sealed class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object> get props => [];
}

final class SettingsInitial extends SettingsState {}

final class FetchSalesTokenLoading extends SettingsState {}

class UpdateSalesTokenLoading extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final FetchSettingsResponseModel settings;

  const SettingsLoaded({required this.settings});
}

class SettingsError extends SettingsState {
  final String error;

  const SettingsError({required this.error});
}

class FetchSalesTokenError extends SettingsState {
  final String message;
  FetchSalesTokenError(this.message);

  @override
  List<Object> get props => [message];
}

class FetchSalesTokenSuccess extends SettingsState {
  final TokenDetailsResult tokenResult;
  FetchSalesTokenSuccess(this.tokenResult);

  @override
  List<Object> get props => [tokenResult];
}

class PrintTypeSelected extends SettingsState {
  final String st_PrintType;

  const PrintTypeSelected(this.st_PrintType);

  @override
  List<Object> get props => [st_PrintType];
}

class UpdateSalesTokenError extends SettingsState {
  final String message;
  UpdateSalesTokenError(this.message);

  @override
  List<Object> get props => [message];
}

class UpdateSalesTokenSuccess extends SettingsState {
  final TokenUpdateResult commonResult;
  UpdateSalesTokenSuccess(this.commonResult);

  @override
  List<Object> get props => [commonResult];
}

class SaveAccountSettingsLoading extends SettingsState {}

class SaveAccountSettingsSuccess extends SettingsState {
  final MasterResponseModel response;

  const SaveAccountSettingsSuccess(this.response);
}

class SaveAccountSettingsError extends SettingsState {
  final String error;

  const SaveAccountSettingsError({required this.error});
}
