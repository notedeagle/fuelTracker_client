import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_tracker_client/bloc/refuel_bloc/refuel_bloc.dart';
import 'package:flutter_tracker_client/repositories/repositories.dart';
import 'package:flutter_tracker_client/screens/main_screen/main_screen.dart';
import 'package:flutter_tracker_client/style/theme.dart' as style;
import 'package:intl/intl.dart';

class ElectricRefuelForm2 extends StatefulWidget {
  final RefuelRepository refuelRepository;
  final String carName;
  final int lastOdometer;

  const ElectricRefuelForm2(
      {Key? key,
      required this.refuelRepository,
      required this.carName,
      required this.lastOdometer})
      : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _RefuelElectric2FormState(refuelRepository, carName, lastOdometer);
}

class _RefuelElectric2FormState extends State<ElectricRefuelForm2> {
  final RefuelRepository refuelRepository;
  final String carName;
  final int lastOdometer;

  _RefuelElectric2FormState(
      this.refuelRepository, this.carName, this.lastOdometer);

  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();

  final _dateController = TextEditingController();
  final _odometerController = TextEditingController();
  final _priceController = TextEditingController();
  RangeValues _currentRangeValues = const RangeValues(20, 100);
  bool fullTank = false;

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
        BlocProvider.of<RefuelBloc>(context).add(AddElectricButtonPressed(
            date: selectedDate,
            carName: carName,
            fullTank: fullTank,
            startLevel: _currentRangeValues.start,
            endLevel: _currentRangeValues.end,
            odometer: int.parse(_odometerController.text),
            price: double.parse(_priceController.text)));

        // Navigator.pop(
        //     context, MaterialPageRoute(builder: (context) => MainScreen()));
      }
    }

    return BlocListener<RefuelBloc, RefuelState>(
      listener: (context, state) {
        if (state is RefuelFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.toString()), backgroundColor: Colors.red));
        }
        if (state is RefuelInitial) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Refuel added."), backgroundColor: Colors.green));

          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const MainScreen()));
        }
      },
      child: BlocBuilder<RefuelBloc, RefuelState>(
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
                          "ADD NEW REFUEL",
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
                      controller: _priceController,
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
                        labelText: "Price",
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
                          return "Price cannot be blank.";
                        }
                      },
                      autocorrect: false),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: style.Colors.grey),
                          borderRadius: BorderRadius.circular(30.0)),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 10.0,
                            ),
                            const Text(
                              "Start and end battery level",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500),
                            ),
                            RangeSlider(
                              values: _currentRangeValues,
                              max: 100,
                              divisions: 100,
                              activeColor: style.Colors.mainColor,
                              labels: RangeLabels(
                                  _currentRangeValues.start.round().toString(),
                                  _currentRangeValues.end.round().toString()),
                              onChanged: (RangeValues value) {
                                setState(() {
                                  _currentRangeValues = value;
                                });
                              },
                            )
                          ])),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: style.Colors.grey),
                        borderRadius: BorderRadius.circular(30.0)),
                    child: CheckboxListTile(
                        title: const Text(
                          "Full tank",
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500),
                        ),
                        value: fullTank,
                        activeColor: style.Colors.mainColor,
                        onChanged: (newValue) => setState(() {
                              fullTank = newValue!;
                            })),
                  ),
                  const SizedBox(
                    height: 30.0,
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
                            child: state is RefuelLoading
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
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
