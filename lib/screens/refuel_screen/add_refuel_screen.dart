import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracker_client/bloc/refuel_bloc/refuel_bloc.dart';
import 'package:flutter_tracker_client/repositories/repositories.dart';

class AddRefuelScreen extends StatelessWidget {
  final RefuelRepository refuelRepository;

  const AddRefuelScreen({Key? key, required this.refuelRepository})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) {
          return RefuelBloc(refuelRepository: refuelRepository);
        },
        child: RefuelForm(refuelRepository: refuelRepository),
      ),
    );
  }
}
