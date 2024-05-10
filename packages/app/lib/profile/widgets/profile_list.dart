import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/auth/bloc/auth_bloc.dart';
import 'package:hollybike/auth/types/auth_session.dart';
import 'package:hollybike/profile/widgets/profile_card_renderer.dart';
import 'package:hollybike/profile/widgets/profile_loading_card.dart';
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
        child: SingleChildScrollView(
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: _buildList,
          ),
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, AuthState state) {
    return Wrap(
      children: addSeparators(
        _populateList(state.storedSessions),
        Container(
          constraints: const BoxConstraints.expand(height: 2),
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
      ),
    );
  }

  List<Widget> _populateList(List<AuthSession> sessions) {
    return sessions
        .map((session) => ProfileCardRenderer(session: session))
        .toList();
  }
}
