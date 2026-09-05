// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'members_access_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MembersAccessState {

 bool get loading; bool get saving; MembersAccess? get data; String? get message;
/// Create a copy of MembersAccessState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MembersAccessStateCopyWith<MembersAccessState> get copyWith => _$MembersAccessStateCopyWithImpl<MembersAccessState>(this as MembersAccessState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MembersAccessState&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.saving, saving) || other.saving == saving)&&(identical(other.data, data) || other.data == data)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,loading,saving,data,message);

@override
String toString() {
  return 'MembersAccessState(loading: $loading, saving: $saving, data: $data, message: $message)';
}


}

/// @nodoc
abstract mixin class $MembersAccessStateCopyWith<$Res>  {
  factory $MembersAccessStateCopyWith(MembersAccessState value, $Res Function(MembersAccessState) _then) = _$MembersAccessStateCopyWithImpl;
@useResult
$Res call({
 bool loading, bool saving, MembersAccess? data, String? message
});




}
/// @nodoc
class _$MembersAccessStateCopyWithImpl<$Res>
    implements $MembersAccessStateCopyWith<$Res> {
  _$MembersAccessStateCopyWithImpl(this._self, this._then);

  final MembersAccessState _self;
  final $Res Function(MembersAccessState) _then;

/// Create a copy of MembersAccessState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? loading = null,Object? saving = null,Object? data = freezed,Object? message = freezed,}) {
  return _then(_self.copyWith(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as MembersAccess?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MembersAccessState].
extension MembersAccessStatePatterns on MembersAccessState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MembersAccessState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MembersAccessState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MembersAccessState value)  $default,){
final _that = this;
switch (_that) {
case _MembersAccessState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MembersAccessState value)?  $default,){
final _that = this;
switch (_that) {
case _MembersAccessState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool loading,  bool saving,  MembersAccess? data,  String? message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MembersAccessState() when $default != null:
return $default(_that.loading,_that.saving,_that.data,_that.message);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool loading,  bool saving,  MembersAccess? data,  String? message)  $default,) {final _that = this;
switch (_that) {
case _MembersAccessState():
return $default(_that.loading,_that.saving,_that.data,_that.message);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool loading,  bool saving,  MembersAccess? data,  String? message)?  $default,) {final _that = this;
switch (_that) {
case _MembersAccessState() when $default != null:
return $default(_that.loading,_that.saving,_that.data,_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _MembersAccessState implements MembersAccessState {
  const _MembersAccessState({this.loading = false, this.saving = false, this.data, this.message});
  

@override@JsonKey() final  bool loading;
@override@JsonKey() final  bool saving;
@override final  MembersAccess? data;
@override final  String? message;

/// Create a copy of MembersAccessState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MembersAccessStateCopyWith<_MembersAccessState> get copyWith => __$MembersAccessStateCopyWithImpl<_MembersAccessState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MembersAccessState&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.saving, saving) || other.saving == saving)&&(identical(other.data, data) || other.data == data)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,loading,saving,data,message);

@override
String toString() {
  return 'MembersAccessState(loading: $loading, saving: $saving, data: $data, message: $message)';
}


}

/// @nodoc
abstract mixin class _$MembersAccessStateCopyWith<$Res> implements $MembersAccessStateCopyWith<$Res> {
  factory _$MembersAccessStateCopyWith(_MembersAccessState value, $Res Function(_MembersAccessState) _then) = __$MembersAccessStateCopyWithImpl;
@override @useResult
$Res call({
 bool loading, bool saving, MembersAccess? data, String? message
});




}
/// @nodoc
class __$MembersAccessStateCopyWithImpl<$Res>
    implements _$MembersAccessStateCopyWith<$Res> {
  __$MembersAccessStateCopyWithImpl(this._self, this._then);

  final _MembersAccessState _self;
  final $Res Function(_MembersAccessState) _then;

/// Create a copy of MembersAccessState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loading = null,Object? saving = null,Object? data = freezed,Object? message = freezed,}) {
  return _then(_MembersAccessState(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,saving: null == saving ? _self.saving : saving // ignore: cast_nullable_to_non_nullable
as bool,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as MembersAccess?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
