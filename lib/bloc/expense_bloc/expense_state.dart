part of 'expense_bloc.dart';

abstract class ExpenseState extends Equatable {
  const ExpenseState();

  @override
  List<Object> get props => [];
}

class ExpenseInitial extends ExpenseState {}

class ExpenseLoading extends ExpenseState {}

class ExpenseFailure extends ExpenseState {
  final String error;

  const ExpenseFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'ExpenseFailure: $error';
}
