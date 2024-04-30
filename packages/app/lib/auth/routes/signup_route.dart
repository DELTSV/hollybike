import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/app/app_router.gr.dart';
import 'package:hollybike/auth/bloc/auth_bloc.dart';
import 'package:hollybike/auth/types/form_field_config.dart';
import 'package:hollybike/auth/types/form_texts.dart';
import 'package:hollybike/auth/widgets/text_form_builder.dart';

@RoutePage()
class SignupRoute extends StatelessWidget {
  const SignupRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      return TextFormBuilder(
        onFormSubmit: (formValue) {
        },
        formFields: {
          "username": FormFieldConfig(
            label: "nom d'utilisateur",
            validator: _usernameValidator,
          ),
          "email": FormFieldConfig(
            label: "adresse mail",
            validator: _emailValidator,
          ),
          "password": FormFieldConfig(
            label: "mot de passe",
            validator: _passwordValidator,
            isSecured: true,
            hasControlField: true,
          ),
        },
        texts: const FormTexts(
            title: "Rejoignez nous!",
            description:
                "Entrez les informations qui serviront à vous connectez plus tard.",
            link: (
              description: "Vous avez déja un compte?",
              buttonText: "Connectez-vous ici",
              destination: LoginRoute(),
            ),
          submit: "S'inscrire"
        ),

      );
    });
  }

  String? _usernameValidator(String? inputValue) {
    if (inputValue == null || inputValue.isEmpty) {
      return "Le nom d'utilisateur ne peut pas être vide";
    }
    return null;
  }

  String? _emailValidator(String? inputValue) {
    if (inputValue == null || inputValue.isEmpty) {
      return "L'adresse mail ne peut pas être vide";
    }
    return null;
  }

  String? _passwordValidator(String? inputValue) {
    if (inputValue == null || inputValue.isEmpty) {
      return 'Le mot de passe ne peut pas être vide';
    }
    return null;
  }
}
