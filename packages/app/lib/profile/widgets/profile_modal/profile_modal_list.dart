import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/auth/bloc/auth_bloc.dart';
import 'package:hollybike/auth/types/auth_session.dart';
import 'package:hollybike/profile/types/profile.dart';
import 'package:hollybike/shared/widgets/profile_card/loading_profile_card.dart';
import 'package:hollybike/shared/widgets/profile_card/profile_card.dart';
import 'package:hollybike/shared/widgets/async_renderer.dart';
import 'package:provider/provider.dart';

import '../../../auth/bloc/auth_persistence.dart';
import '../../bloc/profile_repository.dart';

class ProfileModalList extends StatelessWidget {
  final bool inEditMode;

  const ProfileModalList({
    super.key,
    required this.inEditMode,
  });

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
          builder: (context, state) {
            return AsyncRenderer(
              future:
                  Provider.of<AuthPersistence>(context, listen: false).sessions,
              placeholder: const Text("placeholder"),
              builder: (sessions) => ListWheelScrollView(
                itemExtent: 80,
                diameterRatio: 3,
                children: _populateList(context, sessions),
              ),
            );
          },
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

    return sessions.map((session) {
      bool isCurrentSession = session.getIndexInList(sessions) == 0;
      return AsyncRenderer(
        future: RepositoryProvider.of<ProfileRepository>(context)
            .getSessionProfile(session),
        builder: (profile) => ProfileCard(
          session: session,
          profile: profile,
          onTap: isCurrentSession ? null : _handleCardTap,
          endChild: _buildDeleteButton(isCurrentSession, context, session),
        ),
        placeholder: const LoadingProfileCard(clickable: true),
      );
    }).toList();
  }

  void _handleCardTap(BuildContext context, AuthSession session, Profile _) {
    BlocProvider.of<AuthBloc>(context).add(
      AuthChangeCurrentSession(newCurrentSession: session),
    );
  }

  Widget? _buildDeleteButton(
    bool isCurrentSession,
    BuildContext context,
    AuthSession session,
  ) {
    if (!inEditMode) {
      if (isCurrentSession) return const Icon(Icons.person);
      return null;
    }

    return IconButton(
      onPressed: () {
        BlocProvider.of<AuthBloc>(context)
            .add(AuthSessionExpired(expiredSession: session));
      },
      style: IconButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      icon: Icon(
        Icons.delete,
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
    );
  }
}
