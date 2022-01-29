import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracker_client/bloc/auth_bloc/auth.dart';
import 'package:flutter_tracker_client/repositories/repositories.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;

  RegisterBloc({required this.userRepository, required this.authenticationBloc})
      : super(RegisterInitial());

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if (event is RegisterButtonPressed) {
      yield RegisterLoading();
      try {
        Response response = await userRepository.register(event.email,
            event.firstName, event.lastName, event.username, event.password);

        switch (response.statusCode) {
          case 200:
            yield RegisterInitial();
            break;

          case 409:
            yield RegisterFailure(error: response.data);
            break;
        }
      } catch (error) {
        yield RegisterFailure(error: error.toString());
      }
    }
  }
}
