part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();
}

class RegisterButtonPressed extends RegisterEvent {
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String password;

  const RegisterButtonPressed(
      {required this.username,
      required this.email,
      required this.firstName,
      required this.lastName,
      required this.password});

  @override
  List<Object> get props => [username, email, firstName, lastName, password];

  @override
  String toString() =>
      'RegisterButtonPressed { username: $username, email: $email, firstName: $firstName, '
      'lastName: $lastName, password: $password}';
}
