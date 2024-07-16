/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/shared/utils/safe_set_state.dart';

import '../../bloc/event_journey_bloc/event_journey_bloc.dart';
import '../../bloc/event_journey_bloc/event_journey_state.dart';

class UploadJourneyModal extends StatefulWidget {
  final bool isGpx;

  const UploadJourneyModal({
    super.key,
    required this.isGpx,
  });

  @override
  State<UploadJourneyModal> createState() => _UploadJourneyModalState();
}

class _UploadJourneyModalState extends State<UploadJourneyModal> {
  double _progress = 0;
  String _creationStatus = 'Création du parcours...';
  bool _canClose = false;
  bool _isUploaded = false;
  bool _isCreated = false;

  @override
  void initState() {
    super.initState();

    _startLoading();
  }

  Future<void> _startLoading() async {
    await _initialLoading(1);
    await _generateMap(1);

    if (widget.isGpx) {
      await _convertGpx(1);
    }
  }

  Future<void> _initialLoading(int duration) async {
    safeSetState(() {
      _progress = 0.2;
      _creationStatus = 'Récupération du fichier...';
    });

    await Future.delayed(Duration(seconds: duration));
  }

  Future<void> _generateMap(int duration) async {
    if (_isUploaded || _isCreated) {
      return;
    }

    safeSetState(() {
      _progress = 0.3;
      _creationStatus = 'Génération de la carte...';
    });

    await Future.delayed(Duration(seconds: duration));
  }

  Future<void> _convertGpx(int duration) async {
    if (_isUploaded || _isCreated) {
      return;
    }

    safeSetState(() {
      _progress = 0.5;
      _creationStatus = 'Conversion du fichier GPX...';
    });

    return Future.delayed(Duration(seconds: duration));
  }

  Future<void> _saveJourney(int duration) async {
    safeSetState(() {
      _progress = 0.8;
      _creationStatus = 'Enregistrement du parcours...';
    });

    return Future.delayed(Duration(seconds: duration));
  }

  Future<void> _finalizeJourney(int duration) async {
    safeSetState(() {
      _progress = 0.9;
      _creationStatus = 'Finalisation...';
    });

    return Future.delayed(Duration(milliseconds: duration));
  }

  Future<void> _beforeClose(int duration) async {
    safeSetState(() {
      _progress = 1;
    });

    return Future.delayed(Duration(milliseconds: duration));
  }

  void _onClose() {
    safeSetState(() {
      _canClose = true;

      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EventJourneyBloc, EventJourneyState>(
      listener: (context, state) async {
        if (state is EventJourneyUploadSuccess) {
          safeSetState(() {
            _isUploaded = true;
          });

          if (_isCreated) {
            return;
          }

          await _saveJourney(500);
        }

        if (state is EventJourneyCreationSuccess) {
          safeSetState(() {
            _isCreated = true;
          });

          await _finalizeJourney(250);
          await _beforeClose(150);
          _onClose();
        }

        if (state is EventJourneyOperationFailure) {
          _onClose();
        }
      },
      child: PopScope(
        canPop: _canClose,
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Theme.of(context).dialogBackgroundColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Import du fichier',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      tween: Tween<double>(
                        begin: 0,
                        end: _progress,
                      ),
                      builder: (context, value, child) {
                        return LinearProgressIndicator(
                          value: value,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.secondary,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _creationStatus,
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Veuillez patienter... Ceci peut prendre quelques instants',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimary
                              .withOpacity(0.5),
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
