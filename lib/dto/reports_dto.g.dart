// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reports_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportsDto _$ReportsDtoFromJson(Map<String, dynamic> json) => ReportsDto(
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      totalCost: (json['totalCost'] as num).toDouble(),
      costPerDay: (json['costPerDay'] as num).toDouble(),
      costPerKm: (json['costPerKm'] as num).toDouble(),
      totalDistance: json['totalDistance'] as int,
      distancePerDay: json['distancePerDay'] as int,
      costPerMonth: (json['costPerMonth'] as List<dynamic>)
          .map((e) => CostPerMonth.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ReportsDtoToJson(ReportsDto instance) =>
    <String, dynamic>{
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'totalCost': instance.totalCost,
      'costPerDay': instance.costPerDay,
      'costPerKm': instance.costPerKm,
      'totalDistance': instance.totalDistance,
      'distancePerDay': instance.distancePerDay,
      'costPerMonth': instance.costPerMonth,
    };

CostPerMonth _$CostPerMonthFromJson(Map<String, dynamic> json) => CostPerMonth(
      monthNumber: json['monthNumber'] as int,
      totalCost: (json['totalCost'] as num).toDouble(),
    );

Map<String, dynamic> _$CostPerMonthToJson(CostPerMonth instance) =>
    <String, dynamic>{
      'monthNumber': instance.monthNumber,
      'totalCost': instance.totalCost,
    };
