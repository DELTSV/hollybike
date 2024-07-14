import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/app/app_router.gr.dart';
import 'package:hollybike/auth/bloc/auth_bloc.dart';
import 'package:hollybike/auth/types/form_texts.dart';
import 'package:hollybike/auth/types/signup_dto.dart';
import 'package:hollybike/auth/widgets/form_builder.dart';
import 'package:hollybike/shared/widgets/dialog/banner_dialog.dart';

import '../types/form_field_config.dart';

@RoutePage()
class SignupScreen extends StatelessWidget {
  const SignupScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final popContext = context.routeData.queryParams.getString(
        "popContext", "");

    return Scaffold(
      floatingActionButton: popContext == "connected"
          ? FloatingActionButton.small(
        onPressed: () => context.router.maybePop(),
        child: const Icon(Icons.arrow_back),
      )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is! AuthFailure) {
            if (popContext == "connected") {
              context.router.maybePop();
            } else if (popContext.isEmpty) {
              context.router.replaceAll([const EventsRoute()]);
            }
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final error = state is AuthFailure ? state.message : null;

            return BannerDialog(
              body: FormBuilder(
                title: "Inscrivez-vous!",
                description: "Saisissez les informations de votre nouveau compte.",
                errorText: error,
                formTexts: const FormTexts(
                  submit: "S'inscrire",
                ),
                onFormSubmit: (formValue) {
                  final values = Map.from(context.routeData.queryParams.rawMap);
                  values.addAll(formValue);

                  BlocProvider.of<AuthBloc>(context).add(AuthSignup(
                    host: context.routeData.queryParams.getString("host"),
                    signupDto: SignupDto.fromMap(values),
                  ));
                },
                formFields: {
                  "username": FormFieldConfig(
                    label: "Nom utilisateur",
                    validator: _inputValidator,
                    autofocus: true,
                    autofillHints: [AutofillHints.newUsername],
                    textInputType: TextInputType.name,
                  ),
                  "email": FormFieldConfig(
                    label: "Adresse mail",
                    validator: _inputValidator,
                    autofillHints: [AutofillHints.email],
                    textInputType: TextInputType.emailAddress,
                  ),
                  "password": FormFieldConfig(
                    label: "Mot de passe",
                    validator: _passwordInputValidator,
                    isSecured: true,
                    hasControlField: true,
                    autofillHints: [AutofillHints.newPassword],
                  ),
                },
              ),
            );
          },
        ),
      ),
    );
  }

  String? _inputValidator(String? inputText) {
    if (inputText == null || inputText.isEmpty) {
      return "Ce champ ne peut pas être vide.";
    }
    return null;
  }

  String? _passwordInputValidator(String? inputText) {
    if (inputText == null || inputText.isEmpty) {
      return "Ce champ ne peut pas être vide.";
    }
    if (inputText.length < 8) {
      return "Le mot de passe doit contenir au moins 8 caractères.";
    }

    if (inputText == inputText.toLowerCase()) {
      return "Le mot de passe doit contenir au moins une lettre majuscule.";
    }

    if (inputText == inputText.toUpperCase()) {
      return "Le mot de passe doit contenir au moins une lettre minuscule.";
    }

    if (!inputText.contains(RegExp(r'\d'))) {
      return "Le mot de passe doit contenir au moins un chiffre.";
    }

    return null;
  }
}
