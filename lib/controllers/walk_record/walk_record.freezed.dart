// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'walk_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$WalkRecordControllerState {
  List<WalkRecordModel> get walkRecordList =>
      throw _privateConstructorUsedError;
  Map<String, WalkRecordModel> get walkRecordMap =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $WalkRecordControllerStateCopyWith<WalkRecordControllerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WalkRecordControllerStateCopyWith<$Res> {
  factory $WalkRecordControllerStateCopyWith(WalkRecordControllerState value,
          $Res Function(WalkRecordControllerState) then) =
      _$WalkRecordControllerStateCopyWithImpl<$Res, WalkRecordControllerState>;
  @useResult
  $Res call(
      {List<WalkRecordModel> walkRecordList,
      Map<String, WalkRecordModel> walkRecordMap});
}

/// @nodoc
class _$WalkRecordControllerStateCopyWithImpl<$Res,
        $Val extends WalkRecordControllerState>
    implements $WalkRecordControllerStateCopyWith<$Res> {
  _$WalkRecordControllerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? walkRecordList = null,
    Object? walkRecordMap = null,
  }) {
    return _then(_value.copyWith(
      walkRecordList: null == walkRecordList
          ? _value.walkRecordList
          : walkRecordList // ignore: cast_nullable_to_non_nullable
              as List<WalkRecordModel>,
      walkRecordMap: null == walkRecordMap
          ? _value.walkRecordMap
          : walkRecordMap // ignore: cast_nullable_to_non_nullable
              as Map<String, WalkRecordModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WalkRecordControllerStateImplCopyWith<$Res>
    implements $WalkRecordControllerStateCopyWith<$Res> {
  factory _$$WalkRecordControllerStateImplCopyWith(
          _$WalkRecordControllerStateImpl value,
          $Res Function(_$WalkRecordControllerStateImpl) then) =
      __$$WalkRecordControllerStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<WalkRecordModel> walkRecordList,
      Map<String, WalkRecordModel> walkRecordMap});
}

/// @nodoc
class __$$WalkRecordControllerStateImplCopyWithImpl<$Res>
    extends _$WalkRecordControllerStateCopyWithImpl<$Res,
        _$WalkRecordControllerStateImpl>
    implements _$$WalkRecordControllerStateImplCopyWith<$Res> {
  __$$WalkRecordControllerStateImplCopyWithImpl(
      _$WalkRecordControllerStateImpl _value,
      $Res Function(_$WalkRecordControllerStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? walkRecordList = null,
    Object? walkRecordMap = null,
  }) {
    return _then(_$WalkRecordControllerStateImpl(
      walkRecordList: null == walkRecordList
          ? _value._walkRecordList
          : walkRecordList // ignore: cast_nullable_to_non_nullable
              as List<WalkRecordModel>,
      walkRecordMap: null == walkRecordMap
          ? _value._walkRecordMap
          : walkRecordMap // ignore: cast_nullable_to_non_nullable
              as Map<String, WalkRecordModel>,
    ));
  }
}

/// @nodoc

class _$WalkRecordControllerStateImpl implements _WalkRecordControllerState {
  const _$WalkRecordControllerStateImpl(
      {final List<WalkRecordModel> walkRecordList = const <WalkRecordModel>[],
      final Map<String, WalkRecordModel> walkRecordMap =
          const <String, WalkRecordModel>{}})
      : _walkRecordList = walkRecordList,
        _walkRecordMap = walkRecordMap;

  final List<WalkRecordModel> _walkRecordList;
  @override
  @JsonKey()
  List<WalkRecordModel> get walkRecordList {
    if (_walkRecordList is EqualUnmodifiableListView) return _walkRecordList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_walkRecordList);
  }

  final Map<String, WalkRecordModel> _walkRecordMap;
  @override
  @JsonKey()
  Map<String, WalkRecordModel> get walkRecordMap {
    if (_walkRecordMap is EqualUnmodifiableMapView) return _walkRecordMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_walkRecordMap);
  }

  @override
  String toString() {
    return 'WalkRecordControllerState(walkRecordList: $walkRecordList, walkRecordMap: $walkRecordMap)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WalkRecordControllerStateImpl &&
            const DeepCollectionEquality()
                .equals(other._walkRecordList, _walkRecordList) &&
            const DeepCollectionEquality()
                .equals(other._walkRecordMap, _walkRecordMap));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_walkRecordList),
      const DeepCollectionEquality().hash(_walkRecordMap));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WalkRecordControllerStateImplCopyWith<_$WalkRecordControllerStateImpl>
      get copyWith => __$$WalkRecordControllerStateImplCopyWithImpl<
          _$WalkRecordControllerStateImpl>(this, _$identity);
}

abstract class _WalkRecordControllerState implements WalkRecordControllerState {
  const factory _WalkRecordControllerState(
          {final List<WalkRecordModel> walkRecordList,
          final Map<String, WalkRecordModel> walkRecordMap}) =
      _$WalkRecordControllerStateImpl;

  @override
  List<WalkRecordModel> get walkRecordList;
  @override
  Map<String, WalkRecordModel> get walkRecordMap;
  @override
  @JsonKey(ignore: true)
  _$$WalkRecordControllerStateImplCopyWith<_$WalkRecordControllerStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
