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
        var response = await refuelRepository.addRefuel(
            event.date,
            event.carName,
            event.fuel,
            event.fullTank,
            event.litres,
            event.odometer,
            event.price,
            event.totalCost);

        switch (response.statusCode) {
          case 200:
            yield RefuelInitial();
            break;
        }
      } catch (error) {
        yield RefuelFailure(error: error.toString());
      }
    }
  }
}
