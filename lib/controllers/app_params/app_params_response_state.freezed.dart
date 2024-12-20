// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_params_response_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AppParamsResponseState {
  DateTime? get calendarSelectedDate => throw _privateConstructorUsedError;
  GeolocModel? get selectedTimeGeoloc => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AppParamsResponseStateCopyWith<AppParamsResponseState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppParamsResponseStateCopyWith<$Res> {
  factory $AppParamsResponseStateCopyWith(AppParamsResponseState value,
          $Res Function(AppParamsResponseState) then) =
      _$AppParamsResponseStateCopyWithImpl<$Res, AppParamsResponseState>;
  @useResult
  $Res call({DateTime? calendarSelectedDate, GeolocModel? selectedTimeGeoloc});
}

/// @nodoc
class _$AppParamsResponseStateCopyWithImpl<$Res,
        $Val extends AppParamsResponseState>
    implements $AppParamsResponseStateCopyWith<$Res> {
  _$AppParamsResponseStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? calendarSelectedDate = freezed,
    Object? selectedTimeGeoloc = freezed,
  }) {
    return _then(_value.copyWith(
      calendarSelectedDate: freezed == calendarSelectedDate
          ? _value.calendarSelectedDate
          : calendarSelectedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      selectedTimeGeoloc: freezed == selectedTimeGeoloc
          ? _value.selectedTimeGeoloc
          : selectedTimeGeoloc // ignore: cast_nullable_to_non_nullable
              as GeolocModel?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppParamsResponseStateImplCopyWith<$Res>
    implements $AppParamsResponseStateCopyWith<$Res> {
  factory _$$AppParamsResponseStateImplCopyWith(
          _$AppParamsResponseStateImpl value,
          $Res Function(_$AppParamsResponseStateImpl) then) =
      __$$AppParamsResponseStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime? calendarSelectedDate, GeolocModel? selectedTimeGeoloc});
}

/// @nodoc
class __$$AppParamsResponseStateImplCopyWithImpl<$Res>
    extends _$AppParamsResponseStateCopyWithImpl<$Res,
        _$AppParamsResponseStateImpl>
    implements _$$AppParamsResponseStateImplCopyWith<$Res> {
  __$$AppParamsResponseStateImplCopyWithImpl(
      _$AppParamsResponseStateImpl _value,
      $Res Function(_$AppParamsResponseStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? calendarSelectedDate = freezed,
    Object? selectedTimeGeoloc = freezed,
  }) {
    return _then(_$AppParamsResponseStateImpl(
      calendarSelectedDate: freezed == calendarSelectedDate
          ? _value.calendarSelectedDate
          : calendarSelectedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      selectedTimeGeoloc: freezed == selectedTimeGeoloc
          ? _value.selectedTimeGeoloc
          : selectedTimeGeoloc // ignore: cast_nullable_to_non_nullable
              as GeolocModel?,
    ));
  }
}

/// @nodoc

class _$AppParamsResponseStateImpl implements _AppParamsResponseState {
  const _$AppParamsResponseStateImpl(
      {this.calendarSelectedDate, this.selectedTimeGeoloc});

  @override
  final DateTime? calendarSelectedDate;
  @override
  final GeolocModel? selectedTimeGeoloc;

  @override
  String toString() {
    return 'AppParamsResponseState(calendarSelectedDate: $calendarSelectedDate, selectedTimeGeoloc: $selectedTimeGeoloc)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppParamsResponseStateImpl &&
            (identical(other.calendarSelectedDate, calendarSelectedDate) ||
                other.calendarSelectedDate == calendarSelectedDate) &&
            (identical(other.selectedTimeGeoloc, selectedTimeGeoloc) ||
                other.selectedTimeGeoloc == selectedTimeGeoloc));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, calendarSelectedDate, selectedTimeGeoloc);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AppParamsResponseStateImplCopyWith<_$AppParamsResponseStateImpl>
      get copyWith => __$$AppParamsResponseStateImplCopyWithImpl<
          _$AppParamsResponseStateImpl>(this, _$identity);
}

abstract class _AppParamsResponseState implements AppParamsResponseState {
  const factory _AppParamsResponseState(
      {final DateTime? calendarSelectedDate,
      final GeolocModel? selectedTimeGeoloc}) = _$AppParamsResponseStateImpl;

  @override
  DateTime? get calendarSelectedDate;
  @override
  GeolocModel? get selectedTimeGeoloc;
  @override
  @JsonKey(ignore: true)
  _$$AppParamsResponseStateImplCopyWith<_$AppParamsResponseStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
