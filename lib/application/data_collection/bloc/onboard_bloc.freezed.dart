// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboard_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$OnboardEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OnboardEventCopyWith<$Res> {
  factory $OnboardEventCopyWith(
          OnboardEvent value, $Res Function(OnboardEvent) then) =
      _$OnboardEventCopyWithImpl<$Res, OnboardEvent>;
}

/// @nodoc
class _$OnboardEventCopyWithImpl<$Res, $Val extends OnboardEvent>
    implements $OnboardEventCopyWith<$Res> {
  _$OnboardEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$_StartedCopyWith<$Res> {
  factory _$$_StartedCopyWith(
          _$_Started value, $Res Function(_$_Started) then) =
      __$$_StartedCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_StartedCopyWithImpl<$Res>
    extends _$OnboardEventCopyWithImpl<$Res, _$_Started>
    implements _$$_StartedCopyWith<$Res> {
  __$$_StartedCopyWithImpl(_$_Started _value, $Res Function(_$_Started) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_Started implements _Started {
  const _$_Started();

  @override
  String toString() {
    return 'OnboardEvent.started()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_Started);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
  }) {
    return started();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
  }) {
    return started?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    required TResult orElse(),
  }) {
    if (started != null) {
      return started();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
  }) {
    return started(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
  }) {
    return started?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    required TResult orElse(),
  }) {
    if (started != null) {
      return started(this);
    }
    return orElse();
  }
}

abstract class _Started implements OnboardEvent {
  const factory _Started() = _$_Started;
}

/// @nodoc
mixin _$OnboardState {
  bool get onboarded => throw _privateConstructorUsedError;
  Option<Either<DataFailure, User>> get result =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $OnboardStateCopyWith<OnboardState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OnboardStateCopyWith<$Res> {
  factory $OnboardStateCopyWith(
          OnboardState value, $Res Function(OnboardState) then) =
      _$OnboardStateCopyWithImpl<$Res, OnboardState>;
  @useResult
  $Res call({bool onboarded, Option<Either<DataFailure, User>> result});
}

/// @nodoc
class _$OnboardStateCopyWithImpl<$Res, $Val extends OnboardState>
    implements $OnboardStateCopyWith<$Res> {
  _$OnboardStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? onboarded = null,
    Object? result = null,
  }) {
    return _then(_value.copyWith(
      onboarded: null == onboarded
          ? _value.onboarded
          : onboarded // ignore: cast_nullable_to_non_nullable
              as bool,
      result: null == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as Option<Either<DataFailure, User>>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_OnboardStateCopyWith<$Res>
    implements $OnboardStateCopyWith<$Res> {
  factory _$$_OnboardStateCopyWith(
          _$_OnboardState value, $Res Function(_$_OnboardState) then) =
      __$$_OnboardStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool onboarded, Option<Either<DataFailure, User>> result});
}

/// @nodoc
class __$$_OnboardStateCopyWithImpl<$Res>
    extends _$OnboardStateCopyWithImpl<$Res, _$_OnboardState>
    implements _$$_OnboardStateCopyWith<$Res> {
  __$$_OnboardStateCopyWithImpl(
      _$_OnboardState _value, $Res Function(_$_OnboardState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? onboarded = null,
    Object? result = null,
  }) {
    return _then(_$_OnboardState(
      onboarded: null == onboarded
          ? _value.onboarded
          : onboarded // ignore: cast_nullable_to_non_nullable
              as bool,
      result: null == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as Option<Either<DataFailure, User>>,
    ));
  }
}

/// @nodoc

class _$_OnboardState implements _OnboardState {
  const _$_OnboardState({required this.onboarded, required this.result});

  @override
  final bool onboarded;
  @override
  final Option<Either<DataFailure, User>> result;

  @override
  String toString() {
    return 'OnboardState(onboarded: $onboarded, result: $result)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_OnboardState &&
            (identical(other.onboarded, onboarded) ||
                other.onboarded == onboarded) &&
            (identical(other.result, result) || other.result == result));
  }

  @override
  int get hashCode => Object.hash(runtimeType, onboarded, result);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_OnboardStateCopyWith<_$_OnboardState> get copyWith =>
      __$$_OnboardStateCopyWithImpl<_$_OnboardState>(this, _$identity);
}

abstract class _OnboardState implements OnboardState {
  const factory _OnboardState(
          {required final bool onboarded,
          required final Option<Either<DataFailure, User>> result}) =
      _$_OnboardState;

  @override
  bool get onboarded;
  @override
  Option<Either<DataFailure, User>> get result;
  @override
  @JsonKey(ignore: true)
  _$$_OnboardStateCopyWith<_$_OnboardState> get copyWith =>
      throw _privateConstructorUsedError;
}
