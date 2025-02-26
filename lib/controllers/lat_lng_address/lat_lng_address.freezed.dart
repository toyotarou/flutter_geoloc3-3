// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lat_lng_address.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LatLngAddressControllerState {
  List<LatLngAddressDetailModel> get latLngAddressList =>
      throw _privateConstructorUsedError;
  Map<String, List<LatLngAddressDetailModel>> get latLngAddressMap =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LatLngAddressControllerStateCopyWith<LatLngAddressControllerState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LatLngAddressControllerStateCopyWith<$Res> {
  factory $LatLngAddressControllerStateCopyWith(
          LatLngAddressControllerState value,
          $Res Function(LatLngAddressControllerState) then) =
      _$LatLngAddressControllerStateCopyWithImpl<$Res,
          LatLngAddressControllerState>;
  @useResult
  $Res call(
      {List<LatLngAddressDetailModel> latLngAddressList,
      Map<String, List<LatLngAddressDetailModel>> latLngAddressMap});
}

/// @nodoc
class _$LatLngAddressControllerStateCopyWithImpl<$Res,
        $Val extends LatLngAddressControllerState>
    implements $LatLngAddressControllerStateCopyWith<$Res> {
  _$LatLngAddressControllerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latLngAddressList = null,
    Object? latLngAddressMap = null,
  }) {
    return _then(_value.copyWith(
      latLngAddressList: null == latLngAddressList
          ? _value.latLngAddressList
          : latLngAddressList // ignore: cast_nullable_to_non_nullable
              as List<LatLngAddressDetailModel>,
      latLngAddressMap: null == latLngAddressMap
          ? _value.latLngAddressMap
          : latLngAddressMap // ignore: cast_nullable_to_non_nullable
              as Map<String, List<LatLngAddressDetailModel>>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LatLngAddressControllerStateImplCopyWith<$Res>
    implements $LatLngAddressControllerStateCopyWith<$Res> {
  factory _$$LatLngAddressControllerStateImplCopyWith(
          _$LatLngAddressControllerStateImpl value,
          $Res Function(_$LatLngAddressControllerStateImpl) then) =
      __$$LatLngAddressControllerStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<LatLngAddressDetailModel> latLngAddressList,
      Map<String, List<LatLngAddressDetailModel>> latLngAddressMap});
}

/// @nodoc
class __$$LatLngAddressControllerStateImplCopyWithImpl<$Res>
    extends _$LatLngAddressControllerStateCopyWithImpl<$Res,
        _$LatLngAddressControllerStateImpl>
    implements _$$LatLngAddressControllerStateImplCopyWith<$Res> {
  __$$LatLngAddressControllerStateImplCopyWithImpl(
      _$LatLngAddressControllerStateImpl _value,
      $Res Function(_$LatLngAddressControllerStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latLngAddressList = null,
    Object? latLngAddressMap = null,
  }) {
    return _then(_$LatLngAddressControllerStateImpl(
      latLngAddressList: null == latLngAddressList
          ? _value._latLngAddressList
          : latLngAddressList // ignore: cast_nullable_to_non_nullable
              as List<LatLngAddressDetailModel>,
      latLngAddressMap: null == latLngAddressMap
          ? _value._latLngAddressMap
          : latLngAddressMap // ignore: cast_nullable_to_non_nullable
              as Map<String, List<LatLngAddressDetailModel>>,
    ));
  }
}

/// @nodoc

class _$LatLngAddressControllerStateImpl
    implements _LatLngAddressControllerState {
  const _$LatLngAddressControllerStateImpl(
      {final List<LatLngAddressDetailModel> latLngAddressList =
          const <LatLngAddressDetailModel>[],
      final Map<String, List<LatLngAddressDetailModel>> latLngAddressMap =
          const <String, List<LatLngAddressDetailModel>>{}})
      : _latLngAddressList = latLngAddressList,
        _latLngAddressMap = latLngAddressMap;

  final List<LatLngAddressDetailModel> _latLngAddressList;
  @override
  @JsonKey()
  List<LatLngAddressDetailModel> get latLngAddressList {
    if (_latLngAddressList is EqualUnmodifiableListView)
      return _latLngAddressList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_latLngAddressList);
  }

  final Map<String, List<LatLngAddressDetailModel>> _latLngAddressMap;
  @override
  @JsonKey()
  Map<String, List<LatLngAddressDetailModel>> get latLngAddressMap {
    if (_latLngAddressMap is EqualUnmodifiableMapView) return _latLngAddressMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_latLngAddressMap);
  }

  @override
  String toString() {
    return 'LatLngAddressControllerState(latLngAddressList: $latLngAddressList, latLngAddressMap: $latLngAddressMap)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LatLngAddressControllerStateImpl &&
            const DeepCollectionEquality()
                .equals(other._latLngAddressList, _latLngAddressList) &&
            const DeepCollectionEquality()
                .equals(other._latLngAddressMap, _latLngAddressMap));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_latLngAddressList),
      const DeepCollectionEquality().hash(_latLngAddressMap));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LatLngAddressControllerStateImplCopyWith<
          _$LatLngAddressControllerStateImpl>
      get copyWith => __$$LatLngAddressControllerStateImplCopyWithImpl<
          _$LatLngAddressControllerStateImpl>(this, _$identity);
}

abstract class _LatLngAddressControllerState
    implements LatLngAddressControllerState {
  const factory _LatLngAddressControllerState(
          {final List<LatLngAddressDetailModel> latLngAddressList,
          final Map<String, List<LatLngAddressDetailModel>> latLngAddressMap}) =
      _$LatLngAddressControllerStateImpl;

  @override
  List<LatLngAddressDetailModel> get latLngAddressList;
  @override
  Map<String, List<LatLngAddressDetailModel>> get latLngAddressMap;
  @override
  @JsonKey(ignore: true)
  _$$LatLngAddressControllerStateImplCopyWith<
          _$LatLngAddressControllerStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
