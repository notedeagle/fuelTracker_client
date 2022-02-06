import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracker_client/bloc/vehicle_bloc/vehicle_bloc.dart';
import 'package:flutter_tracker_client/repositories/repositories.dart';
import 'package:flutter_tracker_client/screens/vahicle_screen/add_vehicle_form.dart';

class AddVehicleScreen extends StatelessWidget {
  final VehicleRepository vehicleRepository;

  const AddVehicleScreen({Key? key, required this.vehicleRepository})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) {
          return VehicleBloc(vehicleRepository: vehicleRepository);
        },
        child: VehicleForm(vehicleRepository: vehicleRepository),
      ),
    );
  }
}
