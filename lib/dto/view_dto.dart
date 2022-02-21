import 'package:flutter_tracker_client/dto/expense_dto.dart';
import 'package:flutter_tracker_client/dto/refuel_dto.dart';

class ViewDto {
  int id;
  DateTime date;
  int odometer;
  String fuel;
  double litres;
  String price;
  String totalCost;
  String note;
  String type;

  ViewDto(
      {required this.id,
      required this.date,
      required this.odometer,
      required this.fuel,
      required this.litres,
      required this.price,
      required this.totalCost,
      required this.note,
      required this.type});

  factory ViewDto.fromRefuel(RefuelDto refuelDto) {
    return ViewDto(
        id: refuelDto.id,
        date: refuelDto.date,
        odometer: refuelDto.odometer,
        fuel: refuelDto.fuel + "(" + refuelDto.litres.toStringAsFixed(2),
        litres: refuelDto.litres,
        price: refuelDto.price.toStringAsFixed(2),
        totalCost: refuelDto.totalCost.toStringAsFixed(2) + "zl",
        note: "",
        type: "REFUEL");
  }

  factory ViewDto.fromExpense(ExpenseDto expenseDto) {
    return ViewDto(
        id: expenseDto.id,
        date: expenseDto.date,
        odometer: expenseDto.odometer,
        fuel: "",
        litres: 0,
        price: "",
        totalCost: expenseDto.totalCost.toStringAsFixed(2) + "zl",
        note: expenseDto.note,
        type: "EXPENSE");
  }
}
