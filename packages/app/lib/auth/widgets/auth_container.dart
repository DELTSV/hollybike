import 'package:flutter/material.dart';
import 'package:hollybike/shared/widgets/app_banner.dart';

class AuthContainer extends StatelessWidget {
  final Widget child;

  const AuthContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    const radius = Radius.circular(15);
    final borderSide = BorderSide(
      width: 2,
      color: Theme.of(context).colorScheme.onPrimary,
    );

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        alignment: Alignment.center,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 450),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: radius,
                    topLeft: radius,
                  ),
                ),
                foregroundDecoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topRight: radius,
                    topLeft: radius,
                  ),
                  border: Border(
                    top: borderSide,
                    left: borderSide,
                    right: borderSide,
                  ),
                ),
                clipBehavior: Clip.hardEdge,
                child: const AppBanner(),
              ),
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: radius,
                      bottomRight: radius,
                    ),
                  ),
                  foregroundDecoration: BoxDecoration(
                    border: Border.fromBorderSide(borderSide),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: radius,
                      bottomRight: radius,
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: child,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
