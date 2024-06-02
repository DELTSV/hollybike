import 'package:flutter/material.dart';
import 'package:hollybike/shared/widgets/dialog/closable_dialog.dart';

class SignupLinkDialog extends StatelessWidget {
  const SignupLinkDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return ClosableDialog(title: "Saisissez votre lien d'inscription", onClose: () => Navigator.pop(context),);
  }
}
