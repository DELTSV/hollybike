/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/auth/types/form_field_config.dart';
import 'package:hollybike/auth/types/form_texts.dart';
import 'package:hollybike/auth/widgets/text_form_builder.dart';
import 'package:hollybike/profile/bloc/edit_profile_bloc/edit_profile_bloc.dart';
import 'package:hollybike/profile/bloc/edit_profile_bloc/edit_profile_event.dart';
import 'package:hollybike/shared/widgets/dialog/closable_dialog.dart';

class UpdatePasswordModal extends StatefulWidget {
  final String email;

  const UpdatePasswordModal({
    super.key,
    required this.email,
  });

  @override
  State<UpdatePasswordModal> createState() =>
      _EventImagesVisibilityDialogState();
}

class _EventImagesVisibilityDialogState extends State<UpdatePasswordModal> {
  @override
  Widget build(BuildContext context) {
    return ClosableDialog(
      title: 'Changer votre mot de passe',
      body: TextFormBuilder(
        texts: FormTexts(
          submit: "Confirmer",
          link: (
          description: "Mot de passe oublié ?",
          buttonText: "Réinitialiser",
          onDestinationClick: () => _onResetPassword(context),
          ),
        ),
        onFormSubmit: (fields) =>
        {
          if (fields["password"] != null && fields["newPassword"] != null)
            _onSubmit(
              context,
              oldPassword: fields["password"]!,
              password: fields["newPassword"]!,
            ),
        },
        formFields: {
          "password": FormFieldConfig(
            label: "Mot de passe actuel",
            validator: _inputValidator,
            isSecured: true,
            autofillHints: [AutofillHints.password],
          ),
          "newPassword": FormFieldConfig(
            label: "Nouveau mot de passe",
            validator: _passwordInputValidator,
            isSecured: true,
            hasControlField: true,
            autofillHints: [AutofillHints.newPassword],
          ),
        },
      ),
      onClose: () {
        Navigator.of(context).pop();
      },
    );
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

  void _onResetPassword(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Réinitialisation du mot de passe'),
          content: const Text(
            'Un email de réinitialisation de mot de passe vous sera envoyé.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<EditProfileBloc>().add(
                  ResetPassword(
                    email: widget.email,
                  ),
                );
              },
              child: const Text('Envoyer'),
            ),
          ],
        );
      },
    );
  }

  String? _inputValidator(String? inputText) {
    if (inputText == null || inputText.isEmpty) {
      return "Ce champ ne peut pas être vide.";
    }
    return null;
  }

  void _onSubmit(BuildContext context, {
    required String oldPassword,
    required String password,
  }) {
    BlocProvider.of<EditProfileBloc>(context).add(
      ChangeProfilePassword(
        oldPassword: oldPassword,
        newPassword: password,
      ),
    );
  }
}
