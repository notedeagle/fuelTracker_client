part of 'vehicle_bloc.dart';

abstract class VehicleState extends Equatable {
  const VehicleState();

  @override
  List<Object> get props => [];
}

class VehicleInitial extends VehicleState {}

class VehicleLoading extends VehicleState {}

class VehicleFailure extends VehicleState {
  final String error;

  const VehicleFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'VehicleFailure: $error';
}
