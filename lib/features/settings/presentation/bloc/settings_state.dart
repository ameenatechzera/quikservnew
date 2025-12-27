part of 'settings_cubit.dart';

sealed class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object> get props => [];
}

final class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final FetchSettingsResponseModel settings;

  const SettingsLoaded({required this.settings});
}

class SettingsError extends SettingsState {
  final String error;

  const SettingsError({required this.error});
}

class PrintTypeSelected extends SettingsState {
  final String st_PrintType;

  const PrintTypeSelected(this.st_PrintType);

  @override
  List<Object> get props => [st_PrintType];
}
