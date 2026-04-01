import 'package:equatable/equatable.dart';

class WeeklyGraphReportResult extends Equatable {
  const WeeklyGraphReportResult({required this.period, required this.data});

  final String period;
  static const String periodKey = "period";

  final List<WeeklyList> data;
  static const String dataKey = "data";

  WeeklyGraphReportResult copyWith({String? period, List<WeeklyList>? data}) {
    return WeeklyGraphReportResult(
      period: period ?? this.period,
      data: data ?? this.data,
    );
  }

  factory WeeklyGraphReportResult.fromJson(Map<String, dynamic> json) {
    return WeeklyGraphReportResult(
      period: json["period"] ?? "",
      data: json["data"] == null
          ? []
          : List<WeeklyList>.from(
              json["data"]!.map((x) => WeeklyList.fromJson(x)),
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

class WeeklyList extends Equatable {
  const WeeklyList({required this.name, required this.value});

  final String name;
  static const String nameKey = "name";

  final String value;
  static const String valueKey = "value";

  WeeklyList copyWith({String? name, String? value}) {
    return WeeklyList(name: name ?? this.name, value: value ?? this.value);
  }

  factory WeeklyList.fromJson(Map<String, dynamic> json) {
    return WeeklyList(name: json["name"] ?? "", value: json["value"] ?? "");
  }

  Map<String, dynamic> toJson() => {"name": name, "value": value};

  @override
  String toString() {
    return "$name, $value, ";
  }

  @override
  List<Object?> get props => [name, value];
}
