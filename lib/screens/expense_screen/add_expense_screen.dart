import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracker_client/bloc/expense_bloc/expense_bloc.dart';
import 'package:flutter_tracker_client/repositories/repositories.dart';
import 'package:flutter_tracker_client/screens/expense_screen/add_expense_form.dart';

class AddExpenseScreen extends StatelessWidget {
  final ExpenseRepository expenseRepository;
  final String carName;
  final int lastOdometer;

  const AddExpenseScreen(
      {Key? key,
      required this.expenseRepository,
      required this.carName,
      required this.lastOdometer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
          create: (context) {
            return ExpenseBloc(expenseRepository: expenseRepository);
          },
          child: ExpenseForm(
              expenseRepository: expenseRepository,
              carName: carName,
              lastOdometer: lastOdometer)),
    );
  }
}
