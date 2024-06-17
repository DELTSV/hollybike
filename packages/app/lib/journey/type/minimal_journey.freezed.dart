// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'minimal_journey.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MinimalJourney _$MinimalJourneyFromJson(Map<String, dynamic> json) {
  return _MinimalJourney.fromJson(json);
}

/// @nodoc
mixin _$MinimalJourney {
  int get id => throw _privateConstructorUsedError;
  String? get file => throw _privateConstructorUsedError;
  Position? get start => throw _privateConstructorUsedError;
  Position? get end => throw _privateConstructorUsedError;
  @JsonKey(name: 'preview_image')
  String? get previewImage => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MinimalJourneyCopyWith<MinimalJourney> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MinimalJourneyCopyWith<$Res> {
  factory $MinimalJourneyCopyWith(
          MinimalJourney value, $Res Function(MinimalJourney) then) =
      _$MinimalJourneyCopyWithImpl<$Res, MinimalJourney>;
  @useResult
  $Res call(
      {int id,
      String? file,
      Position? start,
      Position? end,
      @JsonKey(name: 'preview_image') String? previewImage});

  $PositionCopyWith<$Res>? get start;
  $PositionCopyWith<$Res>? get end;
}

/// @nodoc
class _$MinimalJourneyCopyWithImpl<$Res, $Val extends MinimalJourney>
    implements $MinimalJourneyCopyWith<$Res> {
  _$MinimalJourneyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? file = freezed,
    Object? start = freezed,
    Object? end = freezed,
    Object? previewImage = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      file: freezed == file
          ? _value.file
          : file // ignore: cast_nullable_to_non_nullable
              as String?,
      start: freezed == start
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as Position?,
      end: freezed == end
          ? _value.end
          : end // ignore: cast_nullable_to_non_nullable
              as Position?,
      previewImage: freezed == previewImage
          ? _value.previewImage
          : previewImage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PositionCopyWith<$Res>? get start {
    if (_value.start == null) {
      return null;
    }

    return $PositionCopyWith<$Res>(_value.start!, (value) {
      return _then(_value.copyWith(start: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $PositionCopyWith<$Res>? get end {
    if (_value.end == null) {
      return null;
    }

    return $PositionCopyWith<$Res>(_value.end!, (value) {
      return _then(_value.copyWith(end: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MinimalJourneyImplCopyWith<$Res>
    implements $MinimalJourneyCopyWith<$Res> {
  factory _$$MinimalJourneyImplCopyWith(_$MinimalJourneyImpl value,
          $Res Function(_$MinimalJourneyImpl) then) =
      __$$MinimalJourneyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String? file,
      Position? start,
      Position? end,
      @JsonKey(name: 'preview_image') String? previewImage});

  @override
  $PositionCopyWith<$Res>? get start;
  @override
  $PositionCopyWith<$Res>? get end;
}

/// @nodoc
class __$$MinimalJourneyImplCopyWithImpl<$Res>
    extends _$MinimalJourneyCopyWithImpl<$Res, _$MinimalJourneyImpl>
    implements _$$MinimalJourneyImplCopyWith<$Res> {
  __$$MinimalJourneyImplCopyWithImpl(
      _$MinimalJourneyImpl _value, $Res Function(_$MinimalJourneyImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? file = freezed,
    Object? start = freezed,
    Object? end = freezed,
    Object? previewImage = freezed,
  }) {
    return _then(_$MinimalJourneyImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      file: freezed == file
          ? _value.file
          : file // ignore: cast_nullable_to_non_nullable
              as String?,
      start: freezed == start
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as Position?,
      end: freezed == end
          ? _value.end
          : end // ignore: cast_nullable_to_non_nullable
              as Position?,
      previewImage: freezed == previewImage
          ? _value.previewImage
          : previewImage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MinimalJourneyImpl implements _MinimalJourney {
  const _$MinimalJourneyImpl(
      {required this.id,
      required this.file,
      required this.start,
      required this.end,
      @JsonKey(name: 'preview_image') this.previewImage});

  factory _$MinimalJourneyImpl.fromJson(Map<String, dynamic> json) =>
      _$$MinimalJourneyImplFromJson(json);

  @override
  final int id;
  @override
  final String? file;
  @override
  final Position? start;
  @override
  final Position? end;
  @override
  @JsonKey(name: 'preview_image')
  final String? previewImage;

  @override
  String toString() {
    return 'MinimalJourney(id: $id, file: $file, start: $start, end: $end, previewImage: $previewImage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MinimalJourneyImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.file, file) || other.file == file) &&
            (identical(other.start, start) || other.start == start) &&
            (identical(other.end, end) || other.end == end) &&
            (identical(other.previewImage, previewImage) ||
                other.previewImage == previewImage));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, file, start, end, previewImage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MinimalJourneyImplCopyWith<_$MinimalJourneyImpl> get copyWith =>
      __$$MinimalJourneyImplCopyWithImpl<_$MinimalJourneyImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MinimalJourneyImplToJson(
      this,
    );
  }
}

abstract class _MinimalJourney implements MinimalJourney {
  const factory _MinimalJourney(
          {required final int id,
          required final String? file,
          required final Position? start,
          required final Position? end,
          @JsonKey(name: 'preview_image') final String? previewImage}) =
      _$MinimalJourneyImpl;

  factory _MinimalJourney.fromJson(Map<String, dynamic> json) =
      _$MinimalJourneyImpl.fromJson;

  @override
  int get id;
  @override
  String? get file;
  @override
  Position? get start;
  @override
  Position? get end;
  @override
  @JsonKey(name: 'preview_image')
  String? get previewImage;
  @override
  @JsonKey(ignore: true)
  _$$MinimalJourneyImplCopyWith<_$MinimalJourneyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
