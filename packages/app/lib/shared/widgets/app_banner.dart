import 'package:flutter/material.dart';
import 'package:hollybike/shared/widgets/app_title.dart';

class AppBanner extends StatelessWidget {
  const AppBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 2,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              image: const DecorationImage(
                image: AssetImage("images/wallpaper.jpg"),
                fit: BoxFit.none,
                scale: 5,
                repeat: ImageRepeat.repeatX,
              ),
            ),
            padding: const EdgeInsets.all(8.0),
            child: const AppTitle(
              fontSize: 40,
            ),
          ),
        ),
      ],
    );
  }
}
