import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracker_client/bloc/refuel_bloc/refuel_bloc.dart';
import 'package:flutter_tracker_client/repositories/repositories.dart';
import 'package:flutter_tracker_client/screens/refuel_screen/add_refual_electric_form_2.dart';
import 'package:flutter_tracker_client/screens/refuel_screen/add_refuel_electric_form.dart';
import 'package:flutter_tracker_client/screens/refuel_screen/add_refuel_form.dart';

class AddRefuelScreen extends StatelessWidget {
  final RefuelRepository refuelRepository;
  final String carName;
  final String vehicleType;
  final int lastOdometer;
  final bool atHome;
  final double latidiude;
  final double longtitiude;

  const AddRefuelScreen(
      {Key? key,
      required this.refuelRepository,
      required this.carName,
      required this.vehicleType,
      required this.lastOdometer,
      required this.atHome,
      required this.latidiude,
      required this.longtitiude})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (vehicleType == "PETROL" && atHome == false) {
      return Scaffold(
        body: BlocProvider(
            create: (context) {
              return RefuelBloc(refuelRepository: refuelRepository);
            },
            child: RefuelForm(
                refuelRepository: refuelRepository,
                carName: carName,
                lastOdometer: lastOdometer)),
      );
    } else if (vehicleType == "ELECTRIC" && atHome == true) {
      return Scaffold(
          body: BlocProvider(
        create: (conext) {
          return RefuelBloc(refuelRepository: refuelRepository);
        },
        child: ElectricRefuelForm2(
            refuelRepository: refuelRepository,
            carName: carName,
            lastOdometer: lastOdometer),
      ));
    } else {
      return Scaffold(
        body: BlocProvider(
          create: (context) {
            return RefuelBloc(refuelRepository: refuelRepository);
          },
          child: RefuelElectricForm(
              refuelRepository: refuelRepository,
              carName: carName,
              lastOdometer: lastOdometer),
        ),
      );
    }
  }
}
