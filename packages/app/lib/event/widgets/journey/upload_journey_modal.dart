import 'package:flutter/material.dart';

class UploadJourneyModal extends StatefulWidget {
  const UploadJourneyModal({super.key});

  @override
  State<UploadJourneyModal> createState() => _UploadJourneyModalState();
}

class _UploadJourneyModalState extends State<UploadJourneyModal> {
  double _progress = 0;
  String _creationStatus = 'Création du parcours...';
  bool _canClose = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _progress = 0.5;
        _creationStatus = 'Conversion du fichier GPX...';
      });

      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          _progress = 0.9;
          _creationStatus = 'Enregistrement du parcours...';
        });

        Future.delayed(Duration(seconds: 1), () {
          setState(() {
            _progress = 1;
            _creationStatus = 'Finalisation...';
          });

          Future.delayed(Duration(seconds: 1), ()
          {
            setState(() {
              _canClose = true;
            });

            Navigator.of(context).pop();
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
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
                        color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
