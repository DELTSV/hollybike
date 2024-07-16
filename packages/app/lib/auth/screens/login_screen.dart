import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/auth/bloc/auth_bloc.dart';
import 'package:hollybike/auth/types/form_texts.dart';
import 'package:hollybike/auth/types/login_dto.dart';
import 'package:hollybike/auth/widgets/forgot_password_modal.dart';
import 'package:hollybike/auth/widgets/form_builder.dart';
import 'package:hollybike/auth/widgets/signup_link_dialog.dart';
import 'package:hollybike/shared/widgets/dialog/banner_dialog.dart';

import '../types/form_field_config.dart';

@RoutePage()
class LoginScreen extends StatelessWidget {
  final Function() onAuthSuccess;
  final bool canPop;

  const LoginScreen({
    super.key,
    required this.onAuthSuccess,
    this.canPop = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: canPop
          ? FloatingActionButton.small(
              onPressed: () => context.router.maybePop(),
              child: const Icon(Icons.arrow_back),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthConnected) {
            onAuthSuccess();
            if (canPop) {
              context.router.maybePop();
            }
          }
        },
        builder: (context, state) {
          final error = state is AuthFailure ? state.message : null;

          return BannerDialog(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FormBuilder(
                  title: "Bienvenue!",
                  description: "Entrez vos identifiants pour vous connecter.",
                  errorText: error,
                  formTexts: FormTexts(
                    submit: "Se connecter",
                    link: (
                      description: "Vous n'avez pas encore de compte ?",
                      buttonText: "Inscrivez-vous",
                      onDestinationClick: () =>
                          _signupLinkDialogBuilder(context)
                    ),
                  ),
                  onFormSubmit: (formValue) {
                    BlocProvider.of<AuthBloc>(context).add(AuthLogin(
                      host: _formatHostFromInput(formValue["host"] as String),
                      loginDto: LoginDto.fromMap(formValue),
                    ));
                  },
                  formFields: {
                    "host": FormFieldConfig(
                      label: "Adresse du serveur",
                      validator: _inputValidator,
                      defaultValue: "hollybike.fr",
                      autofillHints: [AutofillHints.url],
                      textInputType: TextInputType.url,
                    ),
                    "email": FormFieldConfig(
                      label: "Adresse email",
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
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => ForgotPasswordModal(
                        formatHostFromInput: _formatHostFromInput,
                      ),
                    );
                  },
                  child: Text(
                    "Mot de passe oublié ? Réinitialiser",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatHostFromInput(String input) {
    if (!input.startsWith("http")) {
      if (RegExp(r"^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}").hasMatch(input)) {
        return "http://$input";
      }

      return "https://$input";
    }
    return input;
  }

  String? _inputValidator(String? inputText) {
    if (inputText == null || inputText.isEmpty) {
      return "Ce champ ne peut pas être vide.";
    }
    return null;
  }

  Future<void> _signupLinkDialogBuilder(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => SignupLinkDialog(canPop: canPop),
    );
  }
}
