/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:hollybike/shared/widgets/app_banner.dart';
import 'package:hollybike/shared/widgets/dialog/dialog_container.dart';

class BannerDialog extends StatelessWidget {
  final Widget body;

  const BannerDialog({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return DialogContainer(
      head: const AppBanner(),
      body: body,
    );
  }
}
