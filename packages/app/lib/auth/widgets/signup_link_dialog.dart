import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hollybike/shared/utils/add_separators.dart';
import 'package:hollybike/shared/widgets/camera/camera.dart';
import 'package:hollybike/shared/widgets/dialog/closable_dialog.dart';
import 'package:hollybike/shared/widgets/text_field/common_text_field.dart';

class SignupLinkDialog extends StatefulWidget {
  const SignupLinkDialog({super.key});

  @override
  State<SignupLinkDialog> createState() => _SignupLinkDialogState();
}

class _SignupLinkDialogState extends State<SignupLinkDialog> {
  final _formKey = GlobalKey<FormState>();
  final _linkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ClosableDialog(
      title: "Saisissez votre lien d'inscription",
      onClose: () => Navigator.pop(context),
      body: Column(
        children: addSeparators(
          [
            Form(
              key: _formKey,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: addSeparators(
                  [
                    Expanded(
                      child: CommonTextField(
                        controller: _linkController,
                        title: "Entrez un lien d'invitation",
                        validator: _validateInvitationLink,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(18),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                      child: const Text("Confirmer"),
                    ),
                  ],
                  SizedBox.fromSize(
                    size: const Size.square(8),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: addSeparators(
                [
                  Text(
                    "ou scanner un qr code",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Icon(
                    Icons.qr_code_scanner,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ],
                SizedBox.fromSize(size: const Size.square(8)),
              ),
            ),
            const Camera(),
          ],
          SizedBox.fromSize(size: const Size.square(16)),
        ),
      ),
    );
  }

  String? _validateInvitationLink(String? link) {
    if (link == null || link.isEmpty) {
      return "Vous devez saisir un lien d'invitation";
    }

    final regex = RegExp(
      r'^https://hollybike.fr/invite\?host=.*&role=.*&association=.*&invitation=.*&verify=.*$',
    );
    if (!regex.hasMatch(link)) return "Ce lien d'invitation n'est pas valide";

    return null;
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {}
  }
}
