
import 'json_map.dart';

mixin DtoCompatibleFactory<D> {
  D fromJson(JsonMap json);
}
