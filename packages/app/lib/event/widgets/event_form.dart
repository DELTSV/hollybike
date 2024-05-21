import 'package:flutter/material.dart';

class EventForm extends StatelessWidget {
  const EventForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: 'Nom de l\'événement',
            ),
          ),
          TextField(
            decoration: InputDecoration(
              labelText: 'Description',
            ),
          ),
          TextField(
            decoration: InputDecoration(
              labelText: 'Date',
            ),
          ),
          TextField(
            decoration: InputDecoration(
              labelText: 'Heure',
            ),
          ),
          TextField(
            decoration: InputDecoration(
              labelText: 'Lieu',
            ),
          ),
          TextField(
            decoration: InputDecoration(
              labelText: 'Prix',
            ),
          ),
          TextField(
            decoration: InputDecoration(
              labelText: 'Nombre de places',
            ),
          ),
          TextField(
            decoration: InputDecoration(
              labelText: 'Image',
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text('Créer'),
          ),
        ],
      ),
    );
  }
}
