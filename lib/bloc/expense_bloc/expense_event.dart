part of 'expense_bloc.dart';

abstract class ExpenseEvent extends Equatable {
  const ExpenseEvent();
}

class AddButtonPressed extends ExpenseEvent {
  final String carName;
  final DateTime date;
  final int odometer;
  final double totalCost;
  final String note;

  const AddButtonPressed(
      {required this.carName,
      required this.date,
      required this.odometer,
      required this.totalCost,
      required this.note});

  @override
  List<Object> get props => [carName, date, odometer, totalCost, note];
}
