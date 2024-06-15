import 'package:flutter/material.dart';
import 'package:hollybike/shared/widgets/shadow_gradient_stripe.dart';

class ProfileBannerBackground extends StatelessWidget {
  const ProfileBannerBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(height: 130),
      child: const Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Image(
            image: AssetImage("assets/images/wallpaper.jpg"),
            repeat: ImageRepeat.repeatX,
            width: double.infinity,
          ),
          ShadowGradientStripe(),
        ],
      ),
    );
  }
}
