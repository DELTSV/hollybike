/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hollybike/shared/utils/add_separators.dart';
import 'package:hollybike/shared/widgets/dialog/closable_dialog.dart';
import 'package:hollybike/shared/widgets/text_field/common_text_field.dart';
import 'package:native_qr/native_qr.dart';

import '../../shared/utils/is_valid_signup_link.dart';

class SignupLinkDialog extends StatefulWidget {
  final bool canPop;

  const SignupLinkDialog({super.key, required this.canPop});

  @override
  State<SignupLinkDialog> createState() => _SignupLinkDialogState();
}

class _SignupLinkDialogState extends State<SignupLinkDialog> {
  final _formKey = GlobalKey<FormState>();
  final _linkController = TextEditingController();

  get isValid => _formKey.currentState?.validate() == true;

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
            Text(
              "Vous pouvez aussi",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            ElevatedButton(
              onPressed: _onScanQrCode,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Scanner un QR code"),
                  SizedBox(width: 8),
                  Icon(Icons.qr_code_scanner),
                ],
              ),
            ),
          ],
          SizedBox.fromSize(size: const Size.square(16)),
        ),
      ),
    );
  }

  void _onScanQrCode() async {
    NativeQr nativeQr = NativeQr();
    String? result = await nativeQr.get();

    if (result != null) {
      _handleUrlFound(result);
    }
  }

  static String? _validateInvitationLink(String? link) {
    if (link == null || link.isEmpty) {
      return "Vous devez saisir un lien d'invitation";
    }

    if (!isValidSignupLink(link)) {
      return "Ce lien d'invitation n'est pas valide";
    }
    return null;
  }

  void _handleUrlFound(String url) {
    _linkController.text = url;
    HapticFeedback.lightImpact();

    _handleSubmit();
  }

  void _handleSubmit() {
    if (isValid) {
      widget.canPop
          ? context.router.replaceNamed("${_linkController.text}&popContext=connected")
          : context.router.pushNamed("${_linkController.text}&popContext=guard");
    }
  }
}
