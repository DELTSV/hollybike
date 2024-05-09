import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/auth/bloc/auth_bloc.dart';
import 'package:hollybike/auth/types/auth_session.dart';
import 'package:hollybike/profile/widgets/profile_card.dart';

class ProfileList extends StatelessWidget {
  const ProfileList({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: _buildList,
      ),
    );
  }

  Widget _buildList(BuildContext context, AuthState state) {
    return Column(
      children: _populateList(state.storedSessions),
    );
  }

  List<Widget> _populateList(List<AuthSession> sessions) {
    return sessions
        .map(
          (session) => ProfileCard(session: session),
        )
        .toList();
  }
}
