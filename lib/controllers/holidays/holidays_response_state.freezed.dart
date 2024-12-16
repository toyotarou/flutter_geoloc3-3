// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'holidays_response_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HolidaysResponseState {
  AsyncValue<Map<String, String>> get holidayMap =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $HolidaysResponseStateCopyWith<HolidaysResponseState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HolidaysResponseStateCopyWith<$Res> {
  factory $HolidaysResponseStateCopyWith(HolidaysResponseState value,
          $Res Function(HolidaysResponseState) then) =
      _$HolidaysResponseStateCopyWithImpl<$Res, HolidaysResponseState>;
  @useResult
  $Res call({AsyncValue<Map<String, String>> holidayMap});
}

/// @nodoc
class _$HolidaysResponseStateCopyWithImpl<$Res,
        $Val extends HolidaysResponseState>
    implements $HolidaysResponseStateCopyWith<$Res> {
  _$HolidaysResponseStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? holidayMap = null,
  }) {
    return _then(_value.copyWith(
      holidayMap: null == holidayMap
          ? _value.holidayMap
          : holidayMap // ignore: cast_nullable_to_non_nullable
              as AsyncValue<Map<String, String>>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HolidaysResponseStateImplCopyWith<$Res>
    implements $HolidaysResponseStateCopyWith<$Res> {
  factory _$$HolidaysResponseStateImplCopyWith(
          _$HolidaysResponseStateImpl value,
          $Res Function(_$HolidaysResponseStateImpl) then) =
      __$$HolidaysResponseStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({AsyncValue<Map<String, String>> holidayMap});
}

/// @nodoc
class __$$HolidaysResponseStateImplCopyWithImpl<$Res>
    extends _$HolidaysResponseStateCopyWithImpl<$Res,
        _$HolidaysResponseStateImpl>
    implements _$$HolidaysResponseStateImplCopyWith<$Res> {
  __$$HolidaysResponseStateImplCopyWithImpl(_$HolidaysResponseStateImpl _value,
      $Res Function(_$HolidaysResponseStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? holidayMap = null,
  }) {
    return _then(_$HolidaysResponseStateImpl(
      holidayMap: null == holidayMap
          ? _value.holidayMap
          : holidayMap // ignore: cast_nullable_to_non_nullable
              as AsyncValue<Map<String, String>>,
    ));
  }
}

/// @nodoc

class _$HolidaysResponseStateImpl implements _HolidaysResponseState {
  const _$HolidaysResponseStateImpl(
      {this.holidayMap = const AsyncValue<Map<String, String>>.loading()});

  @override
  @JsonKey()
  final AsyncValue<Map<String, String>> holidayMap;

  @override
  String toString() {
    return 'HolidaysResponseState(holidayMap: $holidayMap)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HolidaysResponseStateImpl &&
            (identical(other.holidayMap, holidayMap) ||
                other.holidayMap == holidayMap));
  }

  @override
  int get hashCode => Object.hash(runtimeType, holidayMap);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HolidaysResponseStateImplCopyWith<_$HolidaysResponseStateImpl>
      get copyWith => __$$HolidaysResponseStateImplCopyWithImpl<
          _$HolidaysResponseStateImpl>(this, _$identity);
}

abstract class _HolidaysResponseState implements HolidaysResponseState {
  const factory _HolidaysResponseState(
          {final AsyncValue<Map<String, String>> holidayMap}) =
      _$HolidaysResponseStateImpl;

  @override
  AsyncValue<Map<String, String>> get holidayMap;
  @override
  @JsonKey(ignore: true)
  _$$HolidaysResponseStateImplCopyWith<_$HolidaysResponseStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
