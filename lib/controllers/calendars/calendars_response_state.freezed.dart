// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'calendars_response_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CalendarsResponseState {
  String get baseYearMonth => throw _privateConstructorUsedError;
  String get prevYearMonth => throw _privateConstructorUsedError;
  String get nextYearMonth => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CalendarsResponseStateCopyWith<CalendarsResponseState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CalendarsResponseStateCopyWith<$Res> {
  factory $CalendarsResponseStateCopyWith(CalendarsResponseState value,
          $Res Function(CalendarsResponseState) then) =
      _$CalendarsResponseStateCopyWithImpl<$Res, CalendarsResponseState>;
  @useResult
  $Res call({String baseYearMonth, String prevYearMonth, String nextYearMonth});
}

/// @nodoc
class _$CalendarsResponseStateCopyWithImpl<$Res,
        $Val extends CalendarsResponseState>
    implements $CalendarsResponseStateCopyWith<$Res> {
  _$CalendarsResponseStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? baseYearMonth = null,
    Object? prevYearMonth = null,
    Object? nextYearMonth = null,
  }) {
    return _then(_value.copyWith(
      baseYearMonth: null == baseYearMonth
          ? _value.baseYearMonth
          : baseYearMonth // ignore: cast_nullable_to_non_nullable
              as String,
      prevYearMonth: null == prevYearMonth
          ? _value.prevYearMonth
          : prevYearMonth // ignore: cast_nullable_to_non_nullable
              as String,
      nextYearMonth: null == nextYearMonth
          ? _value.nextYearMonth
          : nextYearMonth // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CalendarsResponseStateImplCopyWith<$Res>
    implements $CalendarsResponseStateCopyWith<$Res> {
  factory _$$CalendarsResponseStateImplCopyWith(
          _$CalendarsResponseStateImpl value,
          $Res Function(_$CalendarsResponseStateImpl) then) =
      __$$CalendarsResponseStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String baseYearMonth, String prevYearMonth, String nextYearMonth});
}

/// @nodoc
class __$$CalendarsResponseStateImplCopyWithImpl<$Res>
    extends _$CalendarsResponseStateCopyWithImpl<$Res,
        _$CalendarsResponseStateImpl>
    implements _$$CalendarsResponseStateImplCopyWith<$Res> {
  __$$CalendarsResponseStateImplCopyWithImpl(
      _$CalendarsResponseStateImpl _value,
      $Res Function(_$CalendarsResponseStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? baseYearMonth = null,
    Object? prevYearMonth = null,
    Object? nextYearMonth = null,
  }) {
    return _then(_$CalendarsResponseStateImpl(
      baseYearMonth: null == baseYearMonth
          ? _value.baseYearMonth
          : baseYearMonth // ignore: cast_nullable_to_non_nullable
              as String,
      prevYearMonth: null == prevYearMonth
          ? _value.prevYearMonth
          : prevYearMonth // ignore: cast_nullable_to_non_nullable
              as String,
      nextYearMonth: null == nextYearMonth
          ? _value.nextYearMonth
          : nextYearMonth // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$CalendarsResponseStateImpl implements _CalendarsResponseState {
  const _$CalendarsResponseStateImpl(
      {this.baseYearMonth = '',
      this.prevYearMonth = '',
      this.nextYearMonth = ''});

  @override
  @JsonKey()
  final String baseYearMonth;
  @override
  @JsonKey()
  final String prevYearMonth;
  @override
  @JsonKey()
  final String nextYearMonth;

  @override
  String toString() {
    return 'CalendarsResponseState(baseYearMonth: $baseYearMonth, prevYearMonth: $prevYearMonth, nextYearMonth: $nextYearMonth)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CalendarsResponseStateImpl &&
            (identical(other.baseYearMonth, baseYearMonth) ||
                other.baseYearMonth == baseYearMonth) &&
            (identical(other.prevYearMonth, prevYearMonth) ||
                other.prevYearMonth == prevYearMonth) &&
            (identical(other.nextYearMonth, nextYearMonth) ||
                other.nextYearMonth == nextYearMonth));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, baseYearMonth, prevYearMonth, nextYearMonth);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CalendarsResponseStateImplCopyWith<_$CalendarsResponseStateImpl>
      get copyWith => __$$CalendarsResponseStateImplCopyWithImpl<
          _$CalendarsResponseStateImpl>(this, _$identity);
}

abstract class _CalendarsResponseState implements CalendarsResponseState {
  const factory _CalendarsResponseState(
      {final String baseYearMonth,
      final String prevYearMonth,
      final String nextYearMonth}) = _$CalendarsResponseStateImpl;

  @override
  String get baseYearMonth;
  @override
  String get prevYearMonth;
  @override
  String get nextYearMonth;
  @override
  @JsonKey(ignore: true)
  _$$CalendarsResponseStateImplCopyWith<_$CalendarsResponseStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
