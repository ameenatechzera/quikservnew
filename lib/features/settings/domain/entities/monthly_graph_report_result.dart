import 'package:equatable/equatable.dart';

class MonthlyGraphReportResult extends Equatable {
  const MonthlyGraphReportResult({required this.period, required this.data});

  final String period;
  static const String periodKey = "period";

  final List<MonthlyReportList> data;
  static const String dataKey = "data";

  MonthlyGraphReportResult copyWith({
    String? period,
    List<MonthlyReportList>? data,
  }) {
    return MonthlyGraphReportResult(
      period: period ?? this.period,
      data: data ?? this.data,
    );
  }

  factory MonthlyGraphReportResult.fromJson(Map<String, dynamic> json) {
    return MonthlyGraphReportResult(
      period: json["period"] ?? "",
      data: json["data"] == null
          ? []
          : List<MonthlyReportList>.from(
              json["data"]!.map((x) => MonthlyReportList.fromJson(x)),
            ),
    );
  }

  Map<String, dynamic> toJson() => {
    "period": period,
    "data": data.map((x) => x.toJson()).toList(),
  };

  @override
  String toString() {
    return "$period, $data, ";
  }

  @override
  List<Object?> get props => [period, data];
}

class MonthlyReportList extends Equatable {
  const MonthlyReportList({required this.name, required this.value});

  final String name;
  static const String nameKey = "name";

  final String value;
  static const String valueKey = "value";

  MonthlyReportList copyWith({String? name, String? value}) {
    return MonthlyReportList(
      name: name ?? this.name,
      value: value ?? this.value,
    );
  }

  factory MonthlyReportList.fromJson(Map<String, dynamic> json) {
    return MonthlyReportList(
      name: json["name"] ?? "",
      value: json["value"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {"name": name, "value": value};

  @override
  String toString() {
    return "$name, $value, ";
  }

  @override
  List<Object?> get props => [name, value];
}
