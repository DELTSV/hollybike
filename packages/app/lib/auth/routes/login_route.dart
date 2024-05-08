import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/auth/bloc/auth_bloc.dart';
import 'package:hollybike/auth/types/form_texts.dart';
import 'package:hollybike/auth/types/login_dto.dart';
import 'package:hollybike/auth/widgets/form_builder.dart';

import '../types/form_field_config.dart';

@RoutePage()
class LoginRoute extends StatelessWidget {
  const LoginRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) => FormBuilder(
        title: "Bienvenue!",
        description: "Entrez vos identifiants pour vous connecter.",
        notificationsConsumerId: "loginForm",
        formTexts: const FormTexts(submit: "Connexion"),
        onFormSubmit: (formValue) {
          final loginDto = LoginDto.fromMap(formValue);
          BlocProvider.of<AuthBloc>(context).add(AuthLogin(
            host: formValue["host"] as String,
            loginDto: loginDto,
          ));
        },
        formFields: {
          "host": FormFieldConfig(
              label: "adresse du serveur",
              validator: _inputValidator,
              defaultValue: "https://hollybike.fr"),
          "email": FormFieldConfig(
            label: "adresse mail",
            validator: _inputValidator,
          ),
          "password": FormFieldConfig(
            label: "mot de passe",
            validator: _inputValidator,
            isSecured: true,
          ),
        },
      ),
    );
  }

  String? _inputValidator(String? inputText) {
    if (inputText == null || inputText.isEmpty) {
      return "Ce champs ne peut pas être vide.";
    }
    return null;
  }
}