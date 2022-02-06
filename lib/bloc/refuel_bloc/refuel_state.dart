part of 'refuel_bloc.dart';

abstract class RefuelState extends Equatable {
  const RefuelState();

  @override
  List<Object> get props => [];
}

class RefuelInitial extends RefuelState {}

class RefuelLoading extends RefuelState {}

class RefuelFailure extends RefuelState {
  final String error;

  const RefuelFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'RefuelFailure: $error';
}
