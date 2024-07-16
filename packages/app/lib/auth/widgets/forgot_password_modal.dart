import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/auth/types/form_field_config.dart';
import 'package:hollybike/profile/bloc/edit_profile_bloc/edit_profile_bloc.dart';
import 'package:hollybike/profile/bloc/edit_profile_bloc/edit_profile_event.dart';
import 'package:hollybike/profile/bloc/edit_profile_bloc/edit_profile_state.dart';
import 'package:hollybike/profile/services/profile_repository.dart';
import 'package:hollybike/shared/widgets/app_toast.dart';
import 'package:hollybike/shared/widgets/dialog/closable_dialog.dart';

import 'text_form_builder.dart';

class ForgotPasswordModal extends StatelessWidget {
  final String Function(String) formatHostFromInput;

  const ForgotPasswordModal({super.key, required this.formatHostFromInput});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditProfileBloc(
        profileRepository:
        RepositoryProvider.of<ProfileRepository>(
          context,
        ),
      ),
      child: Builder(builder: (context) {
        return BlocConsumer<EditProfileBloc,
            EditProfileState>(
          listener: (context, state) {
            if (state is ResetPasswordSuccess) {
              Toast.showSuccessToast(
                context,
                "Un email de réinitialisation vous a été envoyé.",
              );

              Navigator.of(context).pop();
            }

            if (state is ResetPasswordFailure) {
              Toast.showErrorToast(
                context,
                state.errorMessage,
              );
            }

            if (state is ResetPasswordNotAvailable) {
              Toast.showErrorToast(
                context,
                "La réinitialisation de mot de passe n'est pas disponible, veuillez contacter votre administrateur.",
              );
            }
          },
          builder: (context, state) {
            if (state is ResetPasswordInProgress) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return ClosableDialog(
              title: "Mot de passe oublié",
              body: Column(
                children: [
                  TextFormBuilder(
                    onFormSubmit: (fields) {
                      BlocProvider.of<EditProfileBloc>(
                          context)
                          .add(
                        ResetPassword(
                          email: fields["email"] as String,
                          host: formatHostFromInput(
                            fields["host"] as String,
                          ),
                        ),
                      );
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
                        validator: _emailValidator,
                        autofillHints: [
                          AutofillHints.email
                        ],
                        textInputType:
                        TextInputType.emailAddress,
                      ),
                    },
                  )
                ],
              ),
              onClose: () {
                Navigator.of(context).pop();
              },
            );
          },
        );
      }),
    );
  }

  String? _inputValidator(String? inputText) {
    if (inputText == null || inputText.isEmpty) {
      return "Ce champ ne peut pas être vide.";
    }
    return null;
  }

  String? _emailValidator(String? inputText) {
    if (inputText == null || inputText.isEmpty) {
      return "Ce champ ne peut pas être vide.";
    }
    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
        .hasMatch(inputText)) {
      return "Adresse email invalide.";
    }
    return null;
  }
}
