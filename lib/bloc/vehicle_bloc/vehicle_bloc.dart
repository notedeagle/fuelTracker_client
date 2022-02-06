import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracker_client/repositories/repositories.dart';

part 'vehicle_state.dart';
part 'vehicle_event.dart';

class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  final VehicleRepository vehicleRepository;

  VehicleBloc({required this.vehicleRepository}) : super(VehicleInitial());

  @override
  Stream<VehicleState> mapEventToState(VehicleEvent event) async* {
    if (event is AddButtonPressed) {
      yield VehicleLoading();

      try {
        var response = await vehicleRepository.addVehicle(
            event.brand,
            event.mileage,
            event.model,
            event.name,
            event.plateNumber,
            event.vehicleType,
            event.yearOfProduction);

        switch (response.statusCode) {
          case 200:
            yield VehicleInitial();
            break;

          case 409:
            yield VehicleFailure(error: response.body);
            break;
        }
      } catch (error) {
        yield VehicleFailure(error: error.toString());
      }
    }
  }
}
