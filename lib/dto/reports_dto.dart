import 'package:json_annotation/json_annotation.dart';

part 'reports_dto.g.dart';

@JsonSerializable()
class ReportsDto {
  DateTime startDate;
  DateTime endDate;
  double totalCost;
  double costPerDay;
  double costPerKm;
  int totalDistance;
  int distancePerDay;
  List<CostPerMonth> costPerMonth;

  ReportsDto(
      {required this.startDate,
      required this.endDate,
      required this.totalCost,
      required this.costPerDay,
      required this.costPerKm,
      required this.totalDistance,
      required this.distancePerDay,
      required this.costPerMonth});

  factory ReportsDto.fromJson(Map<String, dynamic> json) =>
      _$ReportsDtoFromJson(json);
}

@JsonSerializable()
class CostPerMonth {
  int monthNumber;
  double totalCost;

  CostPerMonth({required this.monthNumber, required this.totalCost});

  factory CostPerMonth.fromJson(Map<String, dynamic> json) =>
      _$CostPerMonthFromJson(json);
}
