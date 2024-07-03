import 'package:bloc/bloc.dart';

import 'image_list_state.dart';

abstract class ImageListBloc<T> extends Bloc<T, ImageListState> {
  ImageListBloc(super.initialState);
}
