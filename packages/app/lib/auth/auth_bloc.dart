import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState(0)) {
    on<AuthEventIncrement>((event, emit) {
      emit(state.withIncrement(1));
    });
  }
}
