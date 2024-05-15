import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/auth/bloc/auth_bloc.dart';
import 'package:hollybike/auth/bloc/auth_session_repository.dart';
import 'package:hollybike/auth/types/auth_session.dart';
import 'package:hollybike/profile/bloc/profile_repository.dart';
import 'package:hollybike/profile/types/profile.dart';
import 'package:hollybike/shared/widgets/profile_card/loading_profile_card.dart';
import 'package:hollybike/shared/widgets/profile_card/profile_card.dart';
import 'package:hollybike/shared/utils/add_separators.dart';
import 'package:hollybike/shared/widgets/async_renderer.dart';

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
        .map(
          (session) => AsyncRenderer(
            future: RepositoryProvider.of<ProfileRepository>(context)
                .getSessionProfile(session),
            builder: (profile) => ProfileCard(
              session: session,
              profile: profile,
              onTap: _handleCardTap,
              endChild: _buildDeleteButton(context, session),
            ),
            placeholder: const LoadingProfileCard(clickable: true),
          ),
        )
        .toList();
  }

  void _handleCardTap(BuildContext context, AuthSession session, Profile _) {
    BlocProvider.of<AuthBloc>(context)
        .add(AuthSessionSwitch(newSession: session));
  }

  Widget? _buildDeleteButton(BuildContext context, AuthSession session) {
    if (!inEditMode) return null;

    return IconButton(
      onPressed: () {
        RepositoryProvider.of<AuthSessionRepository>(context)
            .sessionExpired(session);
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
