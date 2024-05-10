import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/auth/bloc/auth_bloc.dart';
import 'package:hollybike/auth/types/auth_session.dart';
import 'package:hollybike/profile/widgets/profile_card_renderer.dart';
import 'package:hollybike/shared/utils/add_separators.dart';

class ProfileList extends StatelessWidget {
  const ProfileList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(15),
        ),
        clipBehavior: Clip.hardEdge,
        constraints: const BoxConstraints.tightFor(width: double.infinity),
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: _buildList,
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, AuthState state) {
    return SingleChildScrollView(
      child: Wrap(
        children: addSeparators(
          _populateList(context, state.storedSessions),
          Container(
            constraints: const BoxConstraints.expand(height: 2),
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
        ),
      ),
    );
  }

  List<Widget> _populateList(BuildContext context, List<AuthSession> sessions) {
    if (sessions.isEmpty) {
      return [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(16),
          child: Text(
            "Vous n'êtes connecté à aucun autre compte.",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        )
      ];
    }

    return sessions
        .map((session) => ProfileCardRenderer(session: session))
        .toList();
  }
}
