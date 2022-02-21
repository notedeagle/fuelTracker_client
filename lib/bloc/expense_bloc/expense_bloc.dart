import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracker_client/repositories/repositories.dart';

part 'expense_event.dart';
part 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final ExpenseRepository expenseRepository;

  ExpenseBloc({required this.expenseRepository}) : super(ExpenseInitial());

  @override
  Stream<ExpenseState> mapEventToState(ExpenseEvent event) async* {
    if (event is AddButtonPressed) {
      yield ExpenseLoading();

      try {
        await expenseRepository.addExpense(event.carName, event.date,
            event.odometer, event.totalCost, event.note);

        yield ExpenseInitial();
      } catch (error) {
        yield ExpenseFailure(error: error.toString());
      }
    }
  }
}
