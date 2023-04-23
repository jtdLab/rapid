// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$HomeEvent {
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
abstract class $HomeEventCopyWith<$Res> {
  factory $HomeEventCopyWith(HomeEvent value, $Res Function(HomeEvent) then) =
      _$HomeEventCopyWithImpl<$Res, HomeEvent>;
}

/// @nodoc
class _$HomeEventCopyWithImpl<$Res, $Val extends HomeEvent>
    implements $HomeEventCopyWith<$Res> {
  _$HomeEventCopyWithImpl(this._value, this._then);

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
    extends _$HomeEventCopyWithImpl<$Res, _$_Started>
    implements _$$_StartedCopyWith<$Res> {
  __$$_StartedCopyWithImpl(_$_Started _value, $Res Function(_$_Started) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_Started implements _Started {
  const _$_Started();

  @override
  String toString() {
    return 'HomeEvent.started()';
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

abstract class _Started implements HomeEvent {
  const factory _Started() = _$_Started;
}

/// @nodoc
mixin _$HomeState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadInProgress,
    required TResult Function(String readMe) loadSuccess,
    required TResult Function(MarkdownServiceFetchMarkdownFileFailure failure)
        loadFailure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadInProgress,
    TResult? Function(String readMe)? loadSuccess,
    TResult? Function(MarkdownServiceFetchMarkdownFileFailure failure)?
        loadFailure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadInProgress,
    TResult Function(String readMe)? loadSuccess,
    TResult Function(MarkdownServiceFetchMarkdownFileFailure failure)?
        loadFailure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HomeLoadInProgress value) loadInProgress,
    required TResult Function(HomeLoadSuccess value) loadSuccess,
    required TResult Function(HomeLoadFailure value) loadFailure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HomeLoadInProgress value)? loadInProgress,
    TResult? Function(HomeLoadSuccess value)? loadSuccess,
    TResult? Function(HomeLoadFailure value)? loadFailure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HomeLoadInProgress value)? loadInProgress,
    TResult Function(HomeLoadSuccess value)? loadSuccess,
    TResult Function(HomeLoadFailure value)? loadFailure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeStateCopyWith<$Res> {
  factory $HomeStateCopyWith(HomeState value, $Res Function(HomeState) then) =
      _$HomeStateCopyWithImpl<$Res, HomeState>;
}

/// @nodoc
class _$HomeStateCopyWithImpl<$Res, $Val extends HomeState>
    implements $HomeStateCopyWith<$Res> {
  _$HomeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$HomeLoadInProgressCopyWith<$Res> {
  factory _$$HomeLoadInProgressCopyWith(_$HomeLoadInProgress value,
          $Res Function(_$HomeLoadInProgress) then) =
      __$$HomeLoadInProgressCopyWithImpl<$Res>;
}

/// @nodoc
class __$$HomeLoadInProgressCopyWithImpl<$Res>
    extends _$HomeStateCopyWithImpl<$Res, _$HomeLoadInProgress>
    implements _$$HomeLoadInProgressCopyWith<$Res> {
  __$$HomeLoadInProgressCopyWithImpl(
      _$HomeLoadInProgress _value, $Res Function(_$HomeLoadInProgress) _then)
      : super(_value, _then);
}

/// @nodoc

class _$HomeLoadInProgress implements HomeLoadInProgress {
  const _$HomeLoadInProgress();

  @override
  String toString() {
    return 'HomeState.loadInProgress()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$HomeLoadInProgress);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadInProgress,
    required TResult Function(String readMe) loadSuccess,
    required TResult Function(MarkdownServiceFetchMarkdownFileFailure failure)
        loadFailure,
  }) {
    return loadInProgress();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadInProgress,
    TResult? Function(String readMe)? loadSuccess,
    TResult? Function(MarkdownServiceFetchMarkdownFileFailure failure)?
        loadFailure,
  }) {
    return loadInProgress?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadInProgress,
    TResult Function(String readMe)? loadSuccess,
    TResult Function(MarkdownServiceFetchMarkdownFileFailure failure)?
        loadFailure,
    required TResult orElse(),
  }) {
    if (loadInProgress != null) {
      return loadInProgress();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HomeLoadInProgress value) loadInProgress,
    required TResult Function(HomeLoadSuccess value) loadSuccess,
    required TResult Function(HomeLoadFailure value) loadFailure,
  }) {
    return loadInProgress(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HomeLoadInProgress value)? loadInProgress,
    TResult? Function(HomeLoadSuccess value)? loadSuccess,
    TResult? Function(HomeLoadFailure value)? loadFailure,
  }) {
    return loadInProgress?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HomeLoadInProgress value)? loadInProgress,
    TResult Function(HomeLoadSuccess value)? loadSuccess,
    TResult Function(HomeLoadFailure value)? loadFailure,
    required TResult orElse(),
  }) {
    if (loadInProgress != null) {
      return loadInProgress(this);
    }
    return orElse();
  }
}

abstract class HomeLoadInProgress implements HomeState {
  const factory HomeLoadInProgress() = _$HomeLoadInProgress;
}

/// @nodoc
abstract class _$$HomeLoadSuccessCopyWith<$Res> {
  factory _$$HomeLoadSuccessCopyWith(
          _$HomeLoadSuccess value, $Res Function(_$HomeLoadSuccess) then) =
      __$$HomeLoadSuccessCopyWithImpl<$Res>;
  @useResult
  $Res call({String readMe});
}

/// @nodoc
class __$$HomeLoadSuccessCopyWithImpl<$Res>
    extends _$HomeStateCopyWithImpl<$Res, _$HomeLoadSuccess>
    implements _$$HomeLoadSuccessCopyWith<$Res> {
  __$$HomeLoadSuccessCopyWithImpl(
      _$HomeLoadSuccess _value, $Res Function(_$HomeLoadSuccess) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? readMe = null,
  }) {
    return _then(_$HomeLoadSuccess(
      readMe: null == readMe
          ? _value.readMe
          : readMe // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$HomeLoadSuccess implements HomeLoadSuccess {
  const _$HomeLoadSuccess({required this.readMe});

  @override
  final String readMe;

  @override
  String toString() {
    return 'HomeState.loadSuccess(readMe: $readMe)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeLoadSuccess &&
            (identical(other.readMe, readMe) || other.readMe == readMe));
  }

  @override
  int get hashCode => Object.hash(runtimeType, readMe);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeLoadSuccessCopyWith<_$HomeLoadSuccess> get copyWith =>
      __$$HomeLoadSuccessCopyWithImpl<_$HomeLoadSuccess>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadInProgress,
    required TResult Function(String readMe) loadSuccess,
    required TResult Function(MarkdownServiceFetchMarkdownFileFailure failure)
        loadFailure,
  }) {
    return loadSuccess(readMe);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadInProgress,
    TResult? Function(String readMe)? loadSuccess,
    TResult? Function(MarkdownServiceFetchMarkdownFileFailure failure)?
        loadFailure,
  }) {
    return loadSuccess?.call(readMe);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadInProgress,
    TResult Function(String readMe)? loadSuccess,
    TResult Function(MarkdownServiceFetchMarkdownFileFailure failure)?
        loadFailure,
    required TResult orElse(),
  }) {
    if (loadSuccess != null) {
      return loadSuccess(readMe);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HomeLoadInProgress value) loadInProgress,
    required TResult Function(HomeLoadSuccess value) loadSuccess,
    required TResult Function(HomeLoadFailure value) loadFailure,
  }) {
    return loadSuccess(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HomeLoadInProgress value)? loadInProgress,
    TResult? Function(HomeLoadSuccess value)? loadSuccess,
    TResult? Function(HomeLoadFailure value)? loadFailure,
  }) {
    return loadSuccess?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HomeLoadInProgress value)? loadInProgress,
    TResult Function(HomeLoadSuccess value)? loadSuccess,
    TResult Function(HomeLoadFailure value)? loadFailure,
    required TResult orElse(),
  }) {
    if (loadSuccess != null) {
      return loadSuccess(this);
    }
    return orElse();
  }
}

abstract class HomeLoadSuccess implements HomeState {
  const factory HomeLoadSuccess({required final String readMe}) =
      _$HomeLoadSuccess;

  String get readMe;
  @JsonKey(ignore: true)
  _$$HomeLoadSuccessCopyWith<_$HomeLoadSuccess> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$HomeLoadFailureCopyWith<$Res> {
  factory _$$HomeLoadFailureCopyWith(
          _$HomeLoadFailure value, $Res Function(_$HomeLoadFailure) then) =
      __$$HomeLoadFailureCopyWithImpl<$Res>;
  @useResult
  $Res call({MarkdownServiceFetchMarkdownFileFailure failure});

  $MarkdownServiceFetchMarkdownFileFailureCopyWith<$Res> get failure;
}

/// @nodoc
class __$$HomeLoadFailureCopyWithImpl<$Res>
    extends _$HomeStateCopyWithImpl<$Res, _$HomeLoadFailure>
    implements _$$HomeLoadFailureCopyWith<$Res> {
  __$$HomeLoadFailureCopyWithImpl(
      _$HomeLoadFailure _value, $Res Function(_$HomeLoadFailure) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? failure = null,
  }) {
    return _then(_$HomeLoadFailure(
      failure: null == failure
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as MarkdownServiceFetchMarkdownFileFailure,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $MarkdownServiceFetchMarkdownFileFailureCopyWith<$Res> get failure {
    return $MarkdownServiceFetchMarkdownFileFailureCopyWith<$Res>(
        _value.failure, (value) {
      return _then(_value.copyWith(failure: value));
    });
  }
}

/// @nodoc

class _$HomeLoadFailure implements HomeLoadFailure {
  const _$HomeLoadFailure({required this.failure});

  @override
  final MarkdownServiceFetchMarkdownFileFailure failure;

  @override
  String toString() {
    return 'HomeState.loadFailure(failure: $failure)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeLoadFailure &&
            (identical(other.failure, failure) || other.failure == failure));
  }

  @override
  int get hashCode => Object.hash(runtimeType, failure);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeLoadFailureCopyWith<_$HomeLoadFailure> get copyWith =>
      __$$HomeLoadFailureCopyWithImpl<_$HomeLoadFailure>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadInProgress,
    required TResult Function(String readMe) loadSuccess,
    required TResult Function(MarkdownServiceFetchMarkdownFileFailure failure)
        loadFailure,
  }) {
    return loadFailure(failure);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadInProgress,
    TResult? Function(String readMe)? loadSuccess,
    TResult? Function(MarkdownServiceFetchMarkdownFileFailure failure)?
        loadFailure,
  }) {
    return loadFailure?.call(failure);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadInProgress,
    TResult Function(String readMe)? loadSuccess,
    TResult Function(MarkdownServiceFetchMarkdownFileFailure failure)?
        loadFailure,
    required TResult orElse(),
  }) {
    if (loadFailure != null) {
      return loadFailure(failure);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HomeLoadInProgress value) loadInProgress,
    required TResult Function(HomeLoadSuccess value) loadSuccess,
    required TResult Function(HomeLoadFailure value) loadFailure,
  }) {
    return loadFailure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HomeLoadInProgress value)? loadInProgress,
    TResult? Function(HomeLoadSuccess value)? loadSuccess,
    TResult? Function(HomeLoadFailure value)? loadFailure,
  }) {
    return loadFailure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HomeLoadInProgress value)? loadInProgress,
    TResult Function(HomeLoadSuccess value)? loadSuccess,
    TResult Function(HomeLoadFailure value)? loadFailure,
    required TResult orElse(),
  }) {
    if (loadFailure != null) {
      return loadFailure(this);
    }
    return orElse();
  }
}

abstract class HomeLoadFailure implements HomeState {
  const factory HomeLoadFailure(
          {required final MarkdownServiceFetchMarkdownFileFailure failure}) =
      _$HomeLoadFailure;

  MarkdownServiceFetchMarkdownFileFailure get failure;
  @JsonKey(ignore: true)
  _$$HomeLoadFailureCopyWith<_$HomeLoadFailure> get copyWith =>
      throw _privateConstructorUsedError;
}
