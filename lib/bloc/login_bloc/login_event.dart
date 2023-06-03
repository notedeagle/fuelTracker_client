part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginButtonPressed extends LoginEvent {
  final String login;
  final String password;

  const LoginButtonPressed({
    required this.login,
    required this.password,
  });

  @override
  List<Object> get props => [login, password];

  @override
  String toString() =>
      'LoginButtonPressed { username: $login, password: $password }';
}
