import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/auth/bloc/auth_bloc.dart';
import 'package:hollybike/auth/types/form_field_config.dart';
import 'package:hollybike/auth/widgets/text_form_builder.dart';

@RoutePage()
class SignupRoute extends StatelessWidget {
  const SignupRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      return TextFormBuilder(
        onFormSubmit: (formValue) {
          print(jsonEncode(formValue));
          context.read<AuthBloc>().add(AuthLogin());
        },
        formFields: {
          "username": FormFieldConfig(validator: _usernameValidator),
          "email": FormFieldConfig(validator: _emailValidator),
          "password": FormFieldConfig(
            validator: _passwordValidator,
            isSecured: true,
            hasControlField: true,
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
}
