import 'package:flutter/material.dart';
import '../../../utils/dates.dart';

class ImageGalleryDetailsTime extends StatelessWidget {
  final DateTime uploadedAt;
  final DateTime? takenAt;

  const ImageGalleryDetailsTime({
    super.key,
    required this.uploadedAt,
    this.takenAt,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.access_time_rounded,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 36,
            ),
            const SizedBox(width: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _buildDates(context),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDates(BuildContext context) {
    final widgets = <Widget>[
      Text(
        "Ajoutée ${formatReadableDate(uploadedAt.toLocal())}",
        style: Theme.of(context).textTheme.bodySmall,
      ),
    ];

    if (takenAt != null) {
      widgets.addAll([
        const SizedBox(height: 4),
        Text(
          "Prise ${formatReadableDate(takenAt!.toLocal())}",
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ]);
    }

    return widgets;
  }
}
