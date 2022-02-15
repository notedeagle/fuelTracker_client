part of 'refuel_bloc.dart';

abstract class RefuelEvent extends Equatable {
  const RefuelEvent();
}

class AddButtonPressed extends RefuelEvent {
  final DateTime date;
  final String carName;
  final String fuel;
  final bool fullTank;
  final bool freeTank;
  final double litres;
  final int odometer;
  final double price;
  final double totalCost;

  const AddButtonPressed(
      {required this.date,
      required this.carName,
      required this.fuel,
      required this.fullTank,
      required this.freeTank,
      required this.litres,
      required this.odometer,
      required this.price,
      required this.totalCost});

  @override
  List<Object> get props =>
      [fuel, fullTank, litres, odometer, price, totalCost];
}

class AddElectricButtonPressed extends RefuelEvent {
  final DateTime date;
  final String carName;
  final bool fullTank;
  final double startLevel;
  final double endLevel;
  final int odometer;
  final double price;

  const AddElectricButtonPressed(
      {required this.date,
      required this.carName,
      required this.fullTank,
      required this.startLevel,
      required this.endLevel,
      required this.odometer,
      required this.price});

  @override
  List<Object> get props =>
      [date, carName, fullTank, startLevel, endLevel, odometer, price];
}
