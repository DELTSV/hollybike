import 'package:hollybike/event/types/minimal_event.dart';
import 'package:hollybike/event/types/minimal_event_factory.dart';
import 'package:hollybike/search/bloc/search_bloc.dart';

class EventsSearchBloc extends SearchBloc<MinimalEvent, MinimalEventFactory> {
  EventsSearchBloc({required super.searchRepository}) : super();
}
