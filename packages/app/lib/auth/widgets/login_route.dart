import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/auth/bloc/auth_bloc.dart';
import 'package:hollybike/auth/widgets/auth_form.dart';

@RoutePage()
class LoginRoute extends StatelessWidget {
  const LoginRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      return AuthForm(
        onFormSubmit: (formValue) {
          print(jsonEncode(formValue));
          context.read<AuthBloc>().add(AuthLogin());
        },
        formFields: {
          "email": (
            validator: _inputValidator,
            isHideable: false,
          ),
          "password": (
            validator: _inputValidator,
            isHideable: true,
          ),
        },
      );
    });
  }

  String? _inputValidator(String? inputValue) {
    if (inputValue == null || inputValue.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  }
}
