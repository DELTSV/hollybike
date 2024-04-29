import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/auth/bloc/auth_bloc.dart';
import 'package:hollybike/auth/types/form_field_config.dart';
import 'package:hollybike/auth/widgets/text_form_builder.dart';

@RoutePage()
class ForgotPasswordRoute extends StatelessWidget {
  const ForgotPasswordRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      return TextFormBuilder(
        onFormSubmit: (formValue) {
          context.read<AuthBloc>().add(AuthLogin());
        },
        formFields: {
          "email": FormFieldConfig(
            label: "adresse mail",
            validator: _inputValidator,
          ),
        },
      );
    });
  }

  String? _inputValidator(String? inputValue) {
    if (inputValue == null || inputValue.isEmpty) {
      return 'Ce champ ne peut pas être vide';
    }
    return null;
  }
}
