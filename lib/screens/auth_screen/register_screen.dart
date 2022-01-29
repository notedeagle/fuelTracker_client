import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tracker_client/bloc/auth_bloc/auth.dart';
import 'package:flutter_tracker_client/bloc/register_bloc/register_bloc.dart';
import 'package:flutter_tracker_client/repositories/repositories.dart';
import 'package:flutter_tracker_client/screens/auth_screen/register_form.dart';

class RegisterScreen extends StatelessWidget {
  final UserRepository userRepository;

  const RegisterScreen({Key? key, required this.userRepository})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) {
          return RegisterBloc(
              userRepository: userRepository,
              authenticationBloc: BlocProvider.of<AuthenticationBloc>(context));
        },
        child: RegisterForm(userRepository: userRepository),
      ),
    );
  }
}
