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
