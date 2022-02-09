part of 'vehicle_bloc.dart';

abstract class VehicleEvent extends Equatable {
  const VehicleEvent();
}

class AddButtonPressed extends VehicleEvent {
  final String brand;
  final String model;
  final String name;
  final String plateNumber;
  final String vehicleType;
  final String yearOfProduction;

  const AddButtonPressed(
      {required this.brand,
      required this.model,
      required this.name,
      required this.plateNumber,
      required this.vehicleType,
      required this.yearOfProduction});

  @override
  List<Object> get props =>
      [brand, model, name, plateNumber, vehicleType, yearOfProduction];

  @override
  String toString() => 'RegisterButtonPressed { brand: $brand, model: $model, '
      'name: $name, plateNumber: $plateNumber, vehicleType: $vehicleType, '
      'yearOfProduction: $yearOfProduction}';
}
