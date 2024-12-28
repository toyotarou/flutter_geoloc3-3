// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'temple.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TempleControllerState {
  List<TempleInfoModel> get templeInfoList =>
      throw _privateConstructorUsedError;
  Map<String, List<TempleInfoModel>> get templeInfoMap =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TempleControllerStateCopyWith<TempleControllerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TempleControllerStateCopyWith<$Res> {
  factory $TempleControllerStateCopyWith(TempleControllerState value,
          $Res Function(TempleControllerState) then) =
      _$TempleControllerStateCopyWithImpl<$Res, TempleControllerState>;
  @useResult
  $Res call(
      {List<TempleInfoModel> templeInfoList,
      Map<String, List<TempleInfoModel>> templeInfoMap});
}

/// @nodoc
class _$TempleControllerStateCopyWithImpl<$Res,
        $Val extends TempleControllerState>
    implements $TempleControllerStateCopyWith<$Res> {
  _$TempleControllerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? templeInfoList = null,
    Object? templeInfoMap = null,
  }) {
    return _then(_value.copyWith(
      templeInfoList: null == templeInfoList
          ? _value.templeInfoList
          : templeInfoList // ignore: cast_nullable_to_non_nullable
              as List<TempleInfoModel>,
      templeInfoMap: null == templeInfoMap
          ? _value.templeInfoMap
          : templeInfoMap // ignore: cast_nullable_to_non_nullable
              as Map<String, List<TempleInfoModel>>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TempleControllerStateImplCopyWith<$Res>
    implements $TempleControllerStateCopyWith<$Res> {
  factory _$$TempleControllerStateImplCopyWith(
          _$TempleControllerStateImpl value,
          $Res Function(_$TempleControllerStateImpl) then) =
      __$$TempleControllerStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<TempleInfoModel> templeInfoList,
      Map<String, List<TempleInfoModel>> templeInfoMap});
}

/// @nodoc
class __$$TempleControllerStateImplCopyWithImpl<$Res>
    extends _$TempleControllerStateCopyWithImpl<$Res,
        _$TempleControllerStateImpl>
    implements _$$TempleControllerStateImplCopyWith<$Res> {
  __$$TempleControllerStateImplCopyWithImpl(_$TempleControllerStateImpl _value,
      $Res Function(_$TempleControllerStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? templeInfoList = null,
    Object? templeInfoMap = null,
  }) {
    return _then(_$TempleControllerStateImpl(
      templeInfoList: null == templeInfoList
          ? _value._templeInfoList
          : templeInfoList // ignore: cast_nullable_to_non_nullable
              as List<TempleInfoModel>,
      templeInfoMap: null == templeInfoMap
          ? _value._templeInfoMap
          : templeInfoMap // ignore: cast_nullable_to_non_nullable
              as Map<String, List<TempleInfoModel>>,
    ));
  }
}

/// @nodoc

class _$TempleControllerStateImpl implements _TempleControllerState {
  const _$TempleControllerStateImpl(
      {final List<TempleInfoModel> templeInfoList = const <TempleInfoModel>[],
      final Map<String, List<TempleInfoModel>> templeInfoMap =
          const <String, List<TempleInfoModel>>{}})
      : _templeInfoList = templeInfoList,
        _templeInfoMap = templeInfoMap;

  final List<TempleInfoModel> _templeInfoList;
  @override
  @JsonKey()
  List<TempleInfoModel> get templeInfoList {
    if (_templeInfoList is EqualUnmodifiableListView) return _templeInfoList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_templeInfoList);
  }

  final Map<String, List<TempleInfoModel>> _templeInfoMap;
  @override
  @JsonKey()
  Map<String, List<TempleInfoModel>> get templeInfoMap {
    if (_templeInfoMap is EqualUnmodifiableMapView) return _templeInfoMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_templeInfoMap);
  }

  @override
  String toString() {
    return 'TempleControllerState(templeInfoList: $templeInfoList, templeInfoMap: $templeInfoMap)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TempleControllerStateImpl &&
            const DeepCollectionEquality()
                .equals(other._templeInfoList, _templeInfoList) &&
            const DeepCollectionEquality()
                .equals(other._templeInfoMap, _templeInfoMap));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_templeInfoList),
      const DeepCollectionEquality().hash(_templeInfoMap));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TempleControllerStateImplCopyWith<_$TempleControllerStateImpl>
      get copyWith => __$$TempleControllerStateImplCopyWithImpl<
          _$TempleControllerStateImpl>(this, _$identity);
}

abstract class _TempleControllerState implements TempleControllerState {
  const factory _TempleControllerState(
          {final List<TempleInfoModel> templeInfoList,
          final Map<String, List<TempleInfoModel>> templeInfoMap}) =
      _$TempleControllerStateImpl;

  @override
  List<TempleInfoModel> get templeInfoList;
  @override
  Map<String, List<TempleInfoModel>> get templeInfoMap;
  @override
  @JsonKey(ignore: true)
  _$$TempleControllerStateImplCopyWith<_$TempleControllerStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
