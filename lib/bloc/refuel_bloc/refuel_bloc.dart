import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracker_client/repositories/repositories.dart';

part 'refuel_state.dart';
part 'refuel_event.dart';

class RefuelBloc extends Bloc<RefuelEvent, RefuelState> {
  final RefuelRepository refuelRepository;

  RefuelBloc({required this.refuelRepository}) : super(RefuelInitial());

  @override
  Stream<RefuelState> mapEventToState(RefuelEvent event) async* {
    if (event is AddButtonPressed) {
      yield RefuelLoading();

      try {
        await refuelRepository.addRefuel(
            event.date,
            event.carName,
            event.fuel,
            event.fullTank,
            event.litres,
            event.odometer,
            event.price,
            event.totalCost);

        yield RefuelInitial();
      } catch (error) {
        yield RefuelFailure(error: error.toString());
      }
    } else if (event is AddElectricButtonPressed) {
      yield RefuelLoading();

      try {
        await refuelRepository.addElectricRefuel(
            event.date,
            event.carName,
            event.fullTank,
            event.startLevel,
            event.endLevel,
            event.odometer,
            event.price);

        yield RefuelInitial();
      } catch (error) {
        yield RefuelFailure(error: error.toString());
      }
    }
  }
}
