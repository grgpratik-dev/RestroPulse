// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'join_restaurant_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$JoinRestaurantState {

 bool get loading; bool get requestSent; String get code; JoinInvitation? get invitation; String? get message;
/// Create a copy of JoinRestaurantState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JoinRestaurantStateCopyWith<JoinRestaurantState> get copyWith => _$JoinRestaurantStateCopyWithImpl<JoinRestaurantState>(this as JoinRestaurantState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JoinRestaurantState&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.requestSent, requestSent) || other.requestSent == requestSent)&&(identical(other.code, code) || other.code == code)&&(identical(other.invitation, invitation) || other.invitation == invitation)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,loading,requestSent,code,invitation,message);

@override
String toString() {
  return 'JoinRestaurantState(loading: $loading, requestSent: $requestSent, code: $code, invitation: $invitation, message: $message)';
}


}

/// @nodoc
abstract mixin class $JoinRestaurantStateCopyWith<$Res>  {
  factory $JoinRestaurantStateCopyWith(JoinRestaurantState value, $Res Function(JoinRestaurantState) _then) = _$JoinRestaurantStateCopyWithImpl;
@useResult
$Res call({
 bool loading, bool requestSent, String code, JoinInvitation? invitation, String? message
});




}
/// @nodoc
class _$JoinRestaurantStateCopyWithImpl<$Res>
    implements $JoinRestaurantStateCopyWith<$Res> {
  _$JoinRestaurantStateCopyWithImpl(this._self, this._then);

  final JoinRestaurantState _self;
  final $Res Function(JoinRestaurantState) _then;

/// Create a copy of JoinRestaurantState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? loading = null,Object? requestSent = null,Object? code = null,Object? invitation = freezed,Object? message = freezed,}) {
  return _then(_self.copyWith(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,requestSent: null == requestSent ? _self.requestSent : requestSent // ignore: cast_nullable_to_non_nullable
as bool,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,invitation: freezed == invitation ? _self.invitation : invitation // ignore: cast_nullable_to_non_nullable
as JoinInvitation?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [JoinRestaurantState].
extension JoinRestaurantStatePatterns on JoinRestaurantState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JoinRestaurantState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JoinRestaurantState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JoinRestaurantState value)  $default,){
final _that = this;
switch (_that) {
case _JoinRestaurantState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JoinRestaurantState value)?  $default,){
final _that = this;
switch (_that) {
case _JoinRestaurantState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool loading,  bool requestSent,  String code,  JoinInvitation? invitation,  String? message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JoinRestaurantState() when $default != null:
return $default(_that.loading,_that.requestSent,_that.code,_that.invitation,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool loading,  bool requestSent,  String code,  JoinInvitation? invitation,  String? message)  $default,) {final _that = this;
switch (_that) {
case _JoinRestaurantState():
return $default(_that.loading,_that.requestSent,_that.code,_that.invitation,_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool loading,  bool requestSent,  String code,  JoinInvitation? invitation,  String? message)?  $default,) {final _that = this;
switch (_that) {
case _JoinRestaurantState() when $default != null:
return $default(_that.loading,_that.requestSent,_that.code,_that.invitation,_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _JoinRestaurantState implements JoinRestaurantState {
  const _JoinRestaurantState({this.loading = false, this.requestSent = false, this.code = '', this.invitation, this.message});
  

@override@JsonKey() final  bool loading;
@override@JsonKey() final  bool requestSent;
@override@JsonKey() final  String code;
@override final  JoinInvitation? invitation;
@override final  String? message;

/// Create a copy of JoinRestaurantState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JoinRestaurantStateCopyWith<_JoinRestaurantState> get copyWith => __$JoinRestaurantStateCopyWithImpl<_JoinRestaurantState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JoinRestaurantState&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.requestSent, requestSent) || other.requestSent == requestSent)&&(identical(other.code, code) || other.code == code)&&(identical(other.invitation, invitation) || other.invitation == invitation)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,loading,requestSent,code,invitation,message);

@override
String toString() {
  return 'JoinRestaurantState(loading: $loading, requestSent: $requestSent, code: $code, invitation: $invitation, message: $message)';
}


}

/// @nodoc
abstract mixin class _$JoinRestaurantStateCopyWith<$Res> implements $JoinRestaurantStateCopyWith<$Res> {
  factory _$JoinRestaurantStateCopyWith(_JoinRestaurantState value, $Res Function(_JoinRestaurantState) _then) = __$JoinRestaurantStateCopyWithImpl;
@override @useResult
$Res call({
 bool loading, bool requestSent, String code, JoinInvitation? invitation, String? message
});




}
/// @nodoc
class __$JoinRestaurantStateCopyWithImpl<$Res>
    implements _$JoinRestaurantStateCopyWith<$Res> {
  __$JoinRestaurantStateCopyWithImpl(this._self, this._then);

  final _JoinRestaurantState _self;
  final $Res Function(_JoinRestaurantState) _then;

/// Create a copy of JoinRestaurantState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loading = null,Object? requestSent = null,Object? code = null,Object? invitation = freezed,Object? message = freezed,}) {
  return _then(_JoinRestaurantState(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,requestSent: null == requestSent ? _self.requestSent : requestSent // ignore: cast_nullable_to_non_nullable
as bool,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,invitation: freezed == invitation ? _self.invitation : invitation // ignore: cast_nullable_to_non_nullable
as JoinInvitation?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
