import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_tracker_client/bloc/expense_bloc/expense_bloc.dart';
import 'package:flutter_tracker_client/repositories/repositories.dart';
import 'package:flutter_tracker_client/screens/main_screen/main_screen.dart';
import 'package:intl/intl.dart';
import 'package:flutter_tracker_client/style/theme.dart' as style;

class ExpenseForm extends StatefulWidget {
  final ExpenseRepository expenseRepository;
  final String carName;
  final int lastOdometer;

  const ExpenseForm(
      {Key? key,
      required this.expenseRepository,
      required this.carName,
      required this.lastOdometer})
      : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _ExpenseFormState(expenseRepository, carName, lastOdometer);
}

class _ExpenseFormState extends State<ExpenseForm> {
  final ExpenseRepository expenseRepository;
  final String carName;
  final int lastOdometer;

  _ExpenseFormState(this.expenseRepository, this.carName, this.lastOdometer);

  final _dateController = TextEditingController();
  final _noteController = TextEditingController();
  final _odometerController = TextEditingController();
  final _totalCostController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();

  Future _selectDate() async {
    DatePicker.showDateTimePicker(context,
        showTitleActions: true,
        minTime: DateTime(2020, 1, 1, 0, 0, 0),
        maxTime: DateTime.now(), onChanged: (date) {
      setState(() {
        selectedDate = date;
      });
      _dateController.text =
          DateFormat.yMMMEd('en_US').add_Hm().format(selectedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    _onAddButtonPressed() {
      if (_formKey.currentState!.validate()) {
        BlocProvider.of<ExpenseBloc>(context).add(AddButtonPressed(
            date: selectedDate,
            carName: carName,
            odometer: int.parse(_odometerController.text),
            totalCost: double.parse(_totalCostController.text),
            note: _noteController.text));
      }
    }

    return BlocListener<ExpenseBloc, ExpenseState>(
      listener: (context, state) {
        if (state is ExpenseFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.toString()), backgroundColor: Colors.red));
        }
        if (state is ExpenseInitial) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Expense added."), backgroundColor: Colors.green));

          Navigator.pop(context,
              MaterialPageRoute(builder: (context) => const MainScreen()));
        }
      },
      child: BlocBuilder<ExpenseBloc, ExpenseState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.only(right: 20.0, left: 20.0, top: 20.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    height: 100.0,
                    padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "ADD NEW EXPENSE",
                          style: TextStyle(
                              color: style.Colors.mainColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 24.0),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    style: const TextStyle(
                        fontSize: 14.0,
                        color: style.Colors.titleColor,
                        fontWeight: FontWeight.bold),
                    controller: _dateController,
                    keyboardType: TextInputType.datetime,
                    onTap: () {
                      _selectDate();
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(EvaIcons.carOutline,
                          color: Colors.black26),
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black12),
                          borderRadius: BorderRadius.circular(30.0)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: style.Colors.mainColor),
                          borderRadius: BorderRadius.circular(30.0)),
                      contentPadding:
                          const EdgeInsets.only(left: 10.0, right: 10.0),
                      labelText: "Date",
                      hintStyle: const TextStyle(
                          fontSize: 12.0,
                          color: style.Colors.grey,
                          fontWeight: FontWeight.w500),
                      labelStyle: const TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Date cannot be blank.";
                      }
                    },
                    autocorrect: false,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                      style: const TextStyle(
                          fontSize: 14.0,
                          color: style.Colors.titleColor,
                          fontWeight: FontWeight.bold),
                      controller: _odometerController,
                      keyboardType: const TextInputType.numberWithOptions(),
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        prefixIcon: const Icon(
                          EvaIcons.carOutline,
                          color: Colors.black26,
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.circular(30.0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: style.Colors.mainColor),
                            borderRadius: BorderRadius.circular(30.0)),
                        contentPadding:
                            const EdgeInsets.only(left: 10.0, right: 10.0),
                        labelText: "Odometer",
                        hintStyle: const TextStyle(
                            fontSize: 12.0,
                            color: style.Colors.grey,
                            fontWeight: FontWeight.w500),
                        labelStyle: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Odometer cannot be blank.";
                        }
                      },
                      autocorrect: false),
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    style: const TextStyle(
                        fontSize: 14.0,
                        color: style.Colors.titleColor,
                        fontWeight: FontWeight.bold),
                    controller: _noteController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      prefixIcon: const Icon(
                        EvaIcons.carOutline,
                        color: Colors.black26,
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black12),
                          borderRadius: BorderRadius.circular(30.0)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: style.Colors.mainColor),
                          borderRadius: BorderRadius.circular(30.0)),
                      contentPadding:
                          const EdgeInsets.only(left: 10.0, right: 10.0),
                      labelText: "Note",
                      hintStyle: const TextStyle(
                          fontSize: 12.0,
                          color: style.Colors.grey,
                          fontWeight: FontWeight.w500),
                      labelStyle: const TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? "Note cannot be blank." : null,
                    autocorrect: false,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                      style: const TextStyle(
                          fontSize: 14.0,
                          color: style.Colors.titleColor,
                          fontWeight: FontWeight.bold),
                      controller: _totalCostController,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        prefixIcon: const Icon(
                          EvaIcons.carOutline,
                          color: Colors.black26,
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.circular(30.0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: style.Colors.mainColor),
                            borderRadius: BorderRadius.circular(30.0)),
                        contentPadding:
                            const EdgeInsets.only(left: 10.0, right: 10.0),
                        labelText: "Total cost",
                        hintStyle: const TextStyle(
                            fontSize: 12.0,
                            color: style.Colors.grey,
                            fontWeight: FontWeight.w500),
                        labelStyle: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Total cost cannot be blank.";
                        }
                      },
                      autocorrect: false),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0, bottom: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(
                            height: 45,
                            child: state is ExpenseLoading
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Center(
                                          child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          SizedBox(
                                            height: 25.0,
                                            width: 25.0,
                                            child: CupertinoActivityIndicator(),
                                          )
                                        ],
                                      ))
                                    ],
                                  )
                                : ElevatedButton(
                                    // color: style.Colors.mainColor,
                                    // disabledColor: style.Colors.mainColor,
                                    // disabledTextColor: Colors.white,
                                    // shape: RoundedRectangleBorder(
                                    //   borderRadius: BorderRadius.circular(30.0),
                                    // ),
                                    onPressed: _onAddButtonPressed,
                                    child: const Text("ADD",
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
