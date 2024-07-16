/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../app/app_router.gr.dart';

class JourneyTool {
  final String name;
  final ImageProvider icon;
  final String url;
  final String description;

  const JourneyTool({
    required this.name,
    required this.icon,
    required this.url,
    required this.description,
  });
}

class JourneyToolsModal extends StatelessWidget {
  final void Function(File file) onGpxDownloaded;

  const JourneyToolsModal({super.key, required this.onGpxDownloaded});

  static const journeyTools = [
    JourneyTool(
      name: 'Kurviger',
      icon: AssetImage('assets/images/journey_tools/kurviger.jpg'),
      url: 'https://kurviger.de/fr',
      description: 'Planificateur de parcours pour les motards',
    ),
    JourneyTool(
      name: 'GPX studio',
      icon: AssetImage('assets/images/journey_tools/gpxstudio.png'),
      url: 'https://gpx.studio/l/fr/',
      description: 'Créer, éditer et visualiser des fichiers GPX',
    ),
    JourneyTool(
      name: 'Visugpx',
      icon: AssetImage('assets/images/journey_tools/visugpx.jpg'),
      url: 'https://www.visugpx.com/bibliotheque/',
      description: 'Bibliothèque de parcours GPX',
    ),
    JourneyTool(
      name: 'Openrunner (vélo)',
      icon: AssetImage('assets/images/journey_tools/openrunner.jpg'),
      url: 'https://www.openrunner.com/route-search',
      description: 'Bibliothèque de parcours pour les cyclistes',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(31),
          topRight: Radius.circular(31),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Selectionnez un outil',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                for (final tool in journeyTools)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          context.router.push(
                            ImportGpxToolRoute(
                              url: tool.url,
                              onGpxDownloaded: onGpxDownloaded,
                              onClose: () => Navigator.of(context).pop(),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(14),
                        child: Ink(
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image(
                                    image: tool.icon,
                                    width: 40,
                                    height: 40,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        tool.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        tool.description,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                        softWrap: true,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
