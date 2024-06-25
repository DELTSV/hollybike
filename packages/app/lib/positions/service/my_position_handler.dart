import 'package:background_locator_2/location_dto.dart';

import 'my_position_repository.dart';

@pragma('vm:entry-point')
class MyPositionCallbackHandler {
  @pragma('vm:entry-point')
  static Future<void> initCallback(Map<dynamic, dynamic> params) async {
    MyPositionServiceRepository myLocationCallbackRepository =
    MyPositionServiceRepository();
    await myLocationCallbackRepository.init(params);
  }

  @pragma('vm:entry-point')
  static Future<void> disposeCallback() async {
    MyPositionServiceRepository myLocationCallbackRepository =
    MyPositionServiceRepository();
    await myLocationCallbackRepository.dispose();
  }

  @pragma('vm:entry-point')
  static Future<void> callback(LocationDto locationDto) async {
    MyPositionServiceRepository myLocationCallbackRepository =
    MyPositionServiceRepository();
    await myLocationCallbackRepository.callback(locationDto);
  }

  @pragma('vm:entry-point')
  static Future<void> notificationCallback() async {
  }
}