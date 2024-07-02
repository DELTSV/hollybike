import 'package:flutter/material.dart';

class EventDetailsDescription extends StatefulWidget {
  final String? description;

  const EventDetailsDescription({super.key, this.description});

  @override
  State<EventDetailsDescription> createState() => _EventDetailsDescriptionState();
}

class _EventDetailsDescriptionState extends State<EventDetailsDescription> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    if (widget.description == null) {
      return const SizedBox();
    }

    return Column(
      children: [
        const SizedBox(height: 16),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
            borderRadius: BorderRadius.circular(14),
            child: Ink(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(14),
              ),
              child: AnimatedContainer(
                width: double.infinity,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.all(16),
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: Text(
                    widget.description!,
                    style: Theme.of(context).textTheme.bodyMedium,
                    overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
                    maxLines: _expanded ? null : 3,
                    softWrap: true,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
