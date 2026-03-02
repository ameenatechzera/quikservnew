import 'package:equatable/equatable.dart';

class SalesCountGraphResult extends Equatable {
  SalesCountGraphResult({
    required this.status,
    required this.error,
    required this.period,
    required this.data,
  });

  final int status;
  static const String statusKey = "status";

  final bool error;
  static const String errorKey = "error";

  final String period;
  static const String periodKey = "period";

  final List<SaleCountGraphList> data;
  static const String dataKey = "data";


  SalesCountGraphResult copyWith({
    int? status,
    bool? error,
    String? period,
    List<SaleCountGraphList>? data,
  }) {
    return SalesCountGraphResult(
      status: status ?? this.status,
      error: error ?? this.error,
      period: period ?? this.period,
      data: data ?? this.data,
    );
  }

  factory SalesCountGraphResult.fromJson(Map<String, dynamic> json){
    return SalesCountGraphResult(
      status: json["status"] ?? 0,
      error: json["error"] ?? false,
      period: json["period"] ?? "",
      data: json["data"] == null ? [] : List<SaleCountGraphList>.from(json["data"]!.map((x) => SaleCountGraphList.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "error": error,
    "period": period,
    "data": data.map((x) => x?.toJson()).toList(),
  };

  @override
  String toString(){
    return "$status, $error, $period, $data, ";
  }

  @override
  List<Object?> get props => [
    status, error, period, data, ];
}

class SaleCountGraphList extends Equatable {
  SaleCountGraphList({
    required this.name,
    required this.value,
  });

  final String name;
  static const String nameKey = "name";

  final String value;
  static const String valueKey = "value";


  SaleCountGraphList copyWith({
    String? name,
    String? value,
  }) {
    return SaleCountGraphList(
      name: name ?? this.name,
      value: value ?? this.value,
    );
  }

  factory SaleCountGraphList.fromJson(Map<String, dynamic> json){
    return SaleCountGraphList(
      name: json["name"] ?? "",
      value: json["value"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "value": value,
  };

  @override
  String toString(){
    return "$name, $value, ";
  }

  @override
  List<Object?> get props => [
    name, value, ];
}
