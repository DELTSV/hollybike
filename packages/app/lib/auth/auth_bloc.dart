import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthInitial()) {
    on<AuthLogin>((event, emit) async {
      final uri = Uri.http("hollybike.fr", "api");

      final response = await get(uri);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      emit(state.withIncrement(2));
    });
  }
}
