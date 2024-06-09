import 'package:hollybike/event/bloc/events_bloc/events_bloc.dart';

class ArchivedEventsBloc extends EventsBloc {
  ArchivedEventsBloc({required super.eventRepository})
      : super(requestType: "archived");
}
