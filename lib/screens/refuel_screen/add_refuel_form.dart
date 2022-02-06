import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracker_client/bloc/refuel_bloc/refuel_bloc.dart';
import 'package:flutter_tracker_client/repositories/repositories.dart';
import 'package:flutter_tracker_client/screens/main_screen/main_screen.dart';
import 'package:flutter_tracker_client/style/theme.dart' as style;

class RefuelForm extends StatefulWidget {
  final RefuelRepository refuelRepository;

  const RefuelForm({Key? key, required this.refuelRepository})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _RefuelFormState(refuelRepository);
}

class _RefuelFormState extends State<RefuelForm> {
  final RefuelRepository refuelRepository;

  _RefuelFormState(this.refuelRepository);

  final _dateController = TextEditingController();
  final _fuelController = TextEditingController();
  final bool fullTank = false; //?
  final _litresController = TextEditingController();
  final _odometerController = TextEditingController();
  final _priceController = TextEditingController();
  final _totalCostController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _onAddButtonPressed(String carName) {
      if (_formKey.currentState!.validate()) {
        BlocProvider.of<RefuelBloc>(context).add(AddButtonPressed(
            date: DateTime.parse(_dateController.text),
            carName: carName,
            fuel: _fuelController.text,
            fullTank: fullTank,
            litres: int.parse(_litresController.text),
            odometer: int.parse(_odometerController.text),
            price: double.parse(_priceController.text),
            totalCost: double.parse(_totalCostController.text)));
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
              content: Text("Vehicle added."), backgroundColor: Colors.green));

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
                          "ADD NEW VEHICLE",
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
                    controller: _mileageController,
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
                      labelText: "Mileage",
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
                        value!.isEmpty ? "Mileage cannot be blank." : null,
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
                    controller: _modelController,
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
                      labelText: "Model",
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
                        value!.isEmpty ? "Model cannot be blank." : null,
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
                    controller: _nameController,
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
                      labelText: "Vehicle name",
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
                        value!.isEmpty ? "Vehicle name cannot be blank." : null,
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
                      controller: _productionYear,
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
                        labelText: "Production year",
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
                          return "Production year cannot be blank.";
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
                      controller: _plateNumberController,
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
                        labelText: "Plate number",
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
                          return "Plate number cannot be blank.";
                        }
                      },
                      autocorrect: false),
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
                            child: state is VehicleLoading
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
                                : RaisedButton(
                                    color: style.Colors.mainColor,
                                    disabledColor: style.Colors.mainColor,
                                    disabledTextColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
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
