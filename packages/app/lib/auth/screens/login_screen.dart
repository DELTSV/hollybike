import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/auth/bloc/auth_bloc.dart';
import 'package:hollybike/auth/widgets/auth_container.dart';
import 'package:hollybike/auth/types/form_texts.dart';
import 'package:hollybike/auth/types/login_dto.dart';
import 'package:hollybike/auth/widgets/form_builder.dart';
import 'package:hollybike/auth/widgets/signup_link_dialog.dart';

import '../types/form_field_config.dart';

@RoutePage()
class LoginScreen extends StatelessWidget {
  final Function() onAuthSuccess;

  const LoginScreen({
    super.key,
    required this.onAuthSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.currentSession != null) onAuthSuccess.call();
        },
        child: AuthContainer(
          child: FormBuilder(
            title: "Bienvenue!",
            description: "Entrez vos identifiants pour vous connecter.",
            notificationsConsumerId: "loginForm",
            formTexts: FormTexts(
              submit: "Connexion",
              link: (
              description: "Vous n'avez pas encore de compte ?",
              buttonText: "Inscrivez-vous",
              onDestinationClick: () => _signupLinkDialogBuilder(context)
              ),
            ),
            onFormSubmit: (formValue) {
              BlocProvider.of<AuthBloc>(context).add(AuthLogin(
                host: formValue["host"] as String,
                loginDto: LoginDto.fromMap(formValue),
              ));
            },
            formFields: {
              "host": FormFieldConfig(
                label: "Adresse du serveur",
                validator: _inputValidator,
                defaultValue: "https://hollybike.fr",
                autofillHints: [AutofillHints.url],
                textInputType: TextInputType.url,
              ),
              "email": FormFieldConfig(
                label: "Adresse mail",
                validator: _inputValidator,
                autofocus: true,
                autofillHints: [AutofillHints.email],
                textInputType: TextInputType.emailAddress,
              ),
              "password": FormFieldConfig(
                label: "Mot de passe",
                validator: _inputValidator,
                isSecured: true,
                autofillHints: [AutofillHints.password],
              ),
            },
          ),
        ),
      ),
    );
  }

  String? _inputValidator(String? inputText) {
    if (inputText == null || inputText.isEmpty) {
      return "Ce champs ne peut pas être vide.";
    }
    return null;
  }

  Future<void> _signupLinkDialogBuilder(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => const SignupLinkDialog(),
    );
  }
}
