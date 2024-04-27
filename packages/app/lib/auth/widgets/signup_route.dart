import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/auth/bloc/auth_bloc.dart';
import 'package:hollybike/auth/widgets/auth_form.dart';

@RoutePage()
class SignupRoute extends StatelessWidget {
  const SignupRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      return AuthForm(
        onFormSubmit: (formValue) {
          print(jsonEncode(formValue));
          context.read<AuthBloc>().add(AuthLogin());
        },
        formFields: {
          "username": (
          validator: _usernameValidator,
          isHideable: false,
          ),
          "email": (
            validator: _emailValidator,
            isHideable: false,
          ),
          "password": (
            validator: _passwordValidator,
            isHideable: true,
          ),
          "confirm password": (
          validator: _confirmPasswordValidator,
          isHideable: true,
          ),
        },
      );
    });
  }

  String? _usernameValidator(String? inputValue) {
    if (inputValue == null || inputValue.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  }
  
  String? _emailValidator(String? inputValue) {
    if (inputValue == null || inputValue.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  }

  String? _passwordValidator(String? inputValue) {
    if (inputValue == null || inputValue.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  }

  String? _confirmPasswordValidator(String? inputValue) {
    if (inputValue == null || inputValue.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  }
}
