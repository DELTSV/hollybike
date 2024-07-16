/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:hollybike/event/types/minimal_event.dart';
import 'package:hollybike/shared/types/dto_compatible.dart';

import '../../shared/types/json_map.dart';

class MinimalEventFactory with DtoCompatibleFactory<MinimalEvent> {
  @override
  MinimalEvent fromJson(JsonMap json) => MinimalEvent.fromJson(json);
}
