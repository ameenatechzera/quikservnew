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

final class FetchMonthlyGraphLoading extends SettingsState {}

final class FetchSalesCountGraphLoading extends SettingsState {}

final class FetchCustomSalesGraphLoading extends SettingsState {}

class SavePrinterSettingsInitial extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final FetchSettingsResponseModel settings;

  const SettingsLoaded({required this.settings});
}
class savePrinterSettingsError extends SettingsState {
  final String error;

  savePrinterSettingsError(this.error);

  @override
  List<Object> get props => [error];
}

class PrinterSettingsSaved extends SettingsState {
  final PrinterSettingsSaveResult printersSaveResult;

  PrinterSettingsSaved(this.printersSaveResult);

  @override
  List<Object> get props => [printersSaveResult];
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

class FetchMonthlyGraphError extends SettingsState {
  final String message;
  FetchMonthlyGraphError(this.message);

  @override
  List<Object> get props => [message];
}

class FetchSalesCountGraphError extends SettingsState {
  final String message;
  FetchSalesCountGraphError(this.message);

  @override
  List<Object> get props => [message];
}

class FetchCustomSalesGraphError extends SettingsState {
  final String message;
  FetchCustomSalesGraphError(this.message);

  @override
  List<Object> get props => [message];
}

class FetchSalesTokenSuccess extends SettingsState {
  final TokenDetailsResult tokenResult;
  FetchSalesTokenSuccess(this.tokenResult);

  @override
  List<Object> get props => [tokenResult];
}

class FetchMonthlyGraphSuccess extends SettingsState {
  final MonthlyGraphReportResult graphResult;
  FetchMonthlyGraphSuccess(this.graphResult);

  @override
  List<Object> get props => [graphResult];
}

class FetchYearlyGraphSuccess extends SettingsState {
  final MonthlyGraphReportResult graphResult;
  FetchYearlyGraphSuccess(this.graphResult);

  @override
  List<Object> get props => [graphResult];
}

class FetchWeeklyGraphSuccess extends SettingsState {
  final MonthlyGraphReportResult graphResult;
  FetchWeeklyGraphSuccess(this.graphResult);

  @override
  List<Object> get props => [graphResult];
}
class FetchDailyGraphSuccess extends SettingsState {
  final MonthlyGraphReportResult graphResult;
  FetchDailyGraphSuccess(this.graphResult);

  @override
  List<Object> get props => [graphResult];
}

class FetchSalesCountGraphSuccess extends SettingsState {
  final SalesCountGraphResult graphResult;
  FetchSalesCountGraphSuccess(this.graphResult);

  @override
  List<Object> get props => [graphResult];
}

class FetchCustomSalesGraphSuccess extends SettingsState {
  final MonthlyGraphReportResult graphResult;
  FetchCustomSalesGraphSuccess(this.graphResult);

  @override
  List<Object> get props => [graphResult];
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
