import 'package:flutter/cupertino.dart';

class EventDateClipper extends CustomClipper<Path> {
  final double cornerRadius;
  final double cornerRadius2;

  EventDateClipper({
    required this.cornerRadius,
    required this.cornerRadius2,
  });

  @override
  Path getClip(Size size) {
    var path = Path();

    path.moveTo(0, cornerRadius);
    path.lineTo(0, (size.height - cornerRadius));
    path.quadraticBezierTo(0, size.height, cornerRadius, size.height);
    path.lineTo(size.width - cornerRadius2, size.height);
    path.lineTo(size.width, size.height - cornerRadius2);
    path.lineTo(size.width, 0 + cornerRadius2);
    path.quadraticBezierTo(size.width, 0, size.width - cornerRadius, 0);
    path.lineTo(cornerRadius, 0);
    path.quadraticBezierTo(0, 0, 0, cornerRadius);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
