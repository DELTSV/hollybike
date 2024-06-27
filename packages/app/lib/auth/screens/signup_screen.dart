import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/auth/bloc/auth_bloc.dart';
import 'package:hollybike/auth/types/form_texts.dart';
import 'package:hollybike/auth/types/signup_dto.dart';
import 'package:hollybike/auth/widgets/form_builder.dart';
import 'package:hollybike/shared/widgets/dialog/banner_dialog.dart';

import '../types/form_field_config.dart';

@RoutePage()
class SignupScreen extends StatelessWidget {
  final Function()? onAuthSuccess;
  final bool canPop;

  const SignupScreen({
    super.key,
    this.onAuthSuccess,
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
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {},
        child: BannerDialog(
          body: FormBuilder(
            title: "Inscrivez-vous!",
            description: "Saisissez les informations de votre nouveau compte.",
            notificationsConsumerId: "signupForm",
            formTexts: const FormTexts(
              submit: "Inscription",
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
                validator: _inputValidator,
                isSecured: true,
                hasControlField: true,
                autofillHints: [AutofillHints.newPassword],
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
}
