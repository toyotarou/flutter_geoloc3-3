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
mixin _$GeolocState {
  List<GeolocModel> get geolocList => throw _privateConstructorUsedError;
  Map<String, List<GeolocModel>> get geolocMap =>
      throw _privateConstructorUsedError;
  String get selectedFundName => throw _privateConstructorUsedError;

  /// Create a copy of GeolocState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GeolocStateCopyWith<GeolocState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GeolocStateCopyWith<$Res> {
  factory $GeolocStateCopyWith(
          GeolocState value, $Res Function(GeolocState) then) =
      _$GeolocStateCopyWithImpl<$Res, GeolocState>;
  @useResult
  $Res call(
      {List<GeolocModel> geolocList,
      Map<String, List<GeolocModel>> geolocMap,
      String selectedFundName});
}

/// @nodoc
class _$GeolocStateCopyWithImpl<$Res, $Val extends GeolocState>
    implements $GeolocStateCopyWith<$Res> {
  _$GeolocStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GeolocState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? geolocList = null,
    Object? geolocMap = null,
    Object? selectedFundName = null,
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
      selectedFundName: null == selectedFundName
          ? _value.selectedFundName
          : selectedFundName // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GeolocStateImplCopyWith<$Res>
    implements $GeolocStateCopyWith<$Res> {
  factory _$$GeolocStateImplCopyWith(
          _$GeolocStateImpl value, $Res Function(_$GeolocStateImpl) then) =
      __$$GeolocStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<GeolocModel> geolocList,
      Map<String, List<GeolocModel>> geolocMap,
      String selectedFundName});
}

/// @nodoc
class __$$GeolocStateImplCopyWithImpl<$Res>
    extends _$GeolocStateCopyWithImpl<$Res, _$GeolocStateImpl>
    implements _$$GeolocStateImplCopyWith<$Res> {
  __$$GeolocStateImplCopyWithImpl(
      _$GeolocStateImpl _value, $Res Function(_$GeolocStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of GeolocState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? geolocList = null,
    Object? geolocMap = null,
    Object? selectedFundName = null,
  }) {
    return _then(_$GeolocStateImpl(
      geolocList: null == geolocList
          ? _value._geolocList
          : geolocList // ignore: cast_nullable_to_non_nullable
              as List<GeolocModel>,
      geolocMap: null == geolocMap
          ? _value._geolocMap
          : geolocMap // ignore: cast_nullable_to_non_nullable
              as Map<String, List<GeolocModel>>,
      selectedFundName: null == selectedFundName
          ? _value.selectedFundName
          : selectedFundName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$GeolocStateImpl implements _GeolocState {
  const _$GeolocStateImpl(
      {final List<GeolocModel> geolocList = const <GeolocModel>[],
      final Map<String, List<GeolocModel>> geolocMap =
          const <String, List<GeolocModel>>{},
      this.selectedFundName = ''})
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
  @JsonKey()
  final String selectedFundName;

  @override
  String toString() {
    return 'GeolocState(geolocList: $geolocList, geolocMap: $geolocMap, selectedFundName: $selectedFundName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GeolocStateImpl &&
            const DeepCollectionEquality()
                .equals(other._geolocList, _geolocList) &&
            const DeepCollectionEquality()
                .equals(other._geolocMap, _geolocMap) &&
            (identical(other.selectedFundName, selectedFundName) ||
                other.selectedFundName == selectedFundName));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_geolocList),
      const DeepCollectionEquality().hash(_geolocMap),
      selectedFundName);

  /// Create a copy of GeolocState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GeolocStateImplCopyWith<_$GeolocStateImpl> get copyWith =>
      __$$GeolocStateImplCopyWithImpl<_$GeolocStateImpl>(this, _$identity);
}

abstract class _GeolocState implements GeolocState {
  const factory _GeolocState(
      {final List<GeolocModel> geolocList,
      final Map<String, List<GeolocModel>> geolocMap,
      final String selectedFundName}) = _$GeolocStateImpl;

  @override
  List<GeolocModel> get geolocList;
  @override
  Map<String, List<GeolocModel>> get geolocMap;
  @override
  String get selectedFundName;

  /// Create a copy of GeolocState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GeolocStateImplCopyWith<_$GeolocStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
