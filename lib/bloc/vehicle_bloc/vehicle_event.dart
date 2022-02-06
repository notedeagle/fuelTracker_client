part of 'vehicle_bloc.dart';

abstract class VehicleEvent extends Equatable {
  const VehicleEvent();
}

class AddButtonPressed extends VehicleEvent {
  final String brand;
  final int mileage;
  final String model;
  final String name;
  final String plateNumber;
  final String registrationYear;
  final String vehicleType;
  final String yearOfProduction;

  const AddButtonPressed(
      {required this.brand,
      required this.mileage,
      required this.model,
      required this.name,
      required this.plateNumber,
      required this.registrationYear,
      required this.vehicleType,
      required this.yearOfProduction});

  @override
  List<Object> get props => [
        brand,
        mileage,
        model,
        name,
        plateNumber,
        registrationYear,
        vehicleType,
        yearOfProduction
      ];

  @override
  String toString() =>
      'RegisterButtonPressed { brand: $brand, mileage: $mileage, model: $model, '
      'name: $name, plateNumber: $plateNumber, registrationYearL $registrationYear, '
      'vehicleType: $vehicleType, yearOfProduction: $yearOfProduction}';
}
