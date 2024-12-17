// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'geoloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$GeolocControllerState {
  List<GeolocModel> get geolocList => throw _privateConstructorUsedError;
  Map<String, List<GeolocModel>> get geolocMap =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $GeolocControllerStateCopyWith<GeolocControllerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GeolocControllerStateCopyWith<$Res> {
  factory $GeolocControllerStateCopyWith(GeolocControllerState value,
          $Res Function(GeolocControllerState) then) =
      _$GeolocControllerStateCopyWithImpl<$Res, GeolocControllerState>;
  @useResult
  $Res call(
      {List<GeolocModel> geolocList, Map<String, List<GeolocModel>> geolocMap});
}

/// @nodoc
class _$GeolocControllerStateCopyWithImpl<$Res,
        $Val extends GeolocControllerState>
    implements $GeolocControllerStateCopyWith<$Res> {
  _$GeolocControllerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? geolocList = null,
    Object? geolocMap = null,
  }) {
    return _then(_value.copyWith(
      geolocList: null == geolocList
          ? _value.geolocList
          : geolocList // ignore: cast_nullable_to_non_nullable
              as List<GeolocModel>,
      geolocMap: null == geolocMap
          ? _value.geolocMap
          : geolocMap // ignore: cast_nullable_to_non_nullable
              as Map<String, List<GeolocModel>>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GeolocControllerStateImplCopyWith<$Res>
    implements $GeolocControllerStateCopyWith<$Res> {
  factory _$$GeolocControllerStateImplCopyWith(
          _$GeolocControllerStateImpl value,
          $Res Function(_$GeolocControllerStateImpl) then) =
      __$$GeolocControllerStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<GeolocModel> geolocList, Map<String, List<GeolocModel>> geolocMap});
}

/// @nodoc
class __$$GeolocControllerStateImplCopyWithImpl<$Res>
    extends _$GeolocControllerStateCopyWithImpl<$Res,
        _$GeolocControllerStateImpl>
    implements _$$GeolocControllerStateImplCopyWith<$Res> {
  __$$GeolocControllerStateImplCopyWithImpl(_$GeolocControllerStateImpl _value,
      $Res Function(_$GeolocControllerStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? geolocList = null,
    Object? geolocMap = null,
  }) {
    return _then(_$GeolocControllerStateImpl(
      geolocList: null == geolocList
          ? _value._geolocList
          : geolocList // ignore: cast_nullable_to_non_nullable
              as List<GeolocModel>,
      geolocMap: null == geolocMap
          ? _value._geolocMap
          : geolocMap // ignore: cast_nullable_to_non_nullable
              as Map<String, List<GeolocModel>>,
    ));
  }
}

/// @nodoc

class _$GeolocControllerStateImpl implements _GeolocControllerState {
  const _$GeolocControllerStateImpl(
      {final List<GeolocModel> geolocList = const <GeolocModel>[],
      final Map<String, List<GeolocModel>> geolocMap =
          const <String, List<GeolocModel>>{}})
      : _geolocList = geolocList,
        _geolocMap = geolocMap;

  final List<GeolocModel> _geolocList;
  @override
  @JsonKey()
  List<GeolocModel> get geolocList {
    if (_geolocList is EqualUnmodifiableListView) return _geolocList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_geolocList);
  }

  final Map<String, List<GeolocModel>> _geolocMap;
  @override
  @JsonKey()
  Map<String, List<GeolocModel>> get geolocMap {
    if (_geolocMap is EqualUnmodifiableMapView) return _geolocMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_geolocMap);
  }

  @override
  String toString() {
    return 'GeolocControllerState(geolocList: $geolocList, geolocMap: $geolocMap)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GeolocControllerStateImpl &&
            const DeepCollectionEquality()
                .equals(other._geolocList, _geolocList) &&
            const DeepCollectionEquality()
                .equals(other._geolocMap, _geolocMap));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_geolocList),
      const DeepCollectionEquality().hash(_geolocMap));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GeolocControllerStateImplCopyWith<_$GeolocControllerStateImpl>
      get copyWith => __$$GeolocControllerStateImplCopyWithImpl<
          _$GeolocControllerStateImpl>(this, _$identity);
}

abstract class _GeolocControllerState implements GeolocControllerState {
  const factory _GeolocControllerState(
          {final List<GeolocModel> geolocList,
          final Map<String, List<GeolocModel>> geolocMap}) =
      _$GeolocControllerStateImpl;

  @override
  List<GeolocModel> get geolocList;
  @override
  Map<String, List<GeolocModel>> get geolocMap;
  @override
  @JsonKey(ignore: true)
  _$$GeolocControllerStateImplCopyWith<_$GeolocControllerStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
