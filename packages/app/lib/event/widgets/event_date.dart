import 'package:flutter/material.dart';
import 'package:hollybike/shared/utils/dates.dart';

class BirthDayCardClipper extends CustomClipper<Path> {
  final double cornerRadius;
  final double cornerRadius2;

  BirthDayCardClipper({required this.cornerRadius, required this.cornerRadius2});

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

class EventDate extends StatelessWidget {
  final DateTime date;

  const EventDate({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 50,
      child: Stack(
        children: [
          ClipPath(
            clipper: BirthDayCardClipper(cornerRadius: 8, cornerRadius2: 15),
            child: Container(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              child: Center(
                child: Text(
                  "12",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: ClipPath(
              clipper: BirthDayCardClipper(cornerRadius: 5, cornerRadius2: 12),
              child: Container(
                color: Theme.of(context).cardColor,
                height: 40,
                width: 40,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        getMinimalDay(date),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        date.day.toString(),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
