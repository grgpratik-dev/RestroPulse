// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_restaurant_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CreateRestaurantState {

 bool get loading; bool get success; String? get restaurantId; String? get message;
/// Create a copy of CreateRestaurantState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateRestaurantStateCopyWith<CreateRestaurantState> get copyWith => _$CreateRestaurantStateCopyWithImpl<CreateRestaurantState>(this as CreateRestaurantState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateRestaurantState&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.success, success) || other.success == success)&&(identical(other.restaurantId, restaurantId) || other.restaurantId == restaurantId)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,loading,success,restaurantId,message);

@override
String toString() {
  return 'CreateRestaurantState(loading: $loading, success: $success, restaurantId: $restaurantId, message: $message)';
}


}

/// @nodoc
abstract mixin class $CreateRestaurantStateCopyWith<$Res>  {
  factory $CreateRestaurantStateCopyWith(CreateRestaurantState value, $Res Function(CreateRestaurantState) _then) = _$CreateRestaurantStateCopyWithImpl;
@useResult
$Res call({
 bool loading, bool success, String? restaurantId, String? message
});




}
/// @nodoc
class _$CreateRestaurantStateCopyWithImpl<$Res>
    implements $CreateRestaurantStateCopyWith<$Res> {
  _$CreateRestaurantStateCopyWithImpl(this._self, this._then);

  final CreateRestaurantState _self;
  final $Res Function(CreateRestaurantState) _then;

/// Create a copy of CreateRestaurantState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? loading = null,Object? success = null,Object? restaurantId = freezed,Object? message = freezed,}) {
  return _then(_self.copyWith(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,restaurantId: freezed == restaurantId ? _self.restaurantId : restaurantId // ignore: cast_nullable_to_non_nullable
as String?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateRestaurantState].
extension CreateRestaurantStatePatterns on CreateRestaurantState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateRestaurantState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateRestaurantState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateRestaurantState value)  $default,){
final _that = this;
switch (_that) {
case _CreateRestaurantState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateRestaurantState value)?  $default,){
final _that = this;
switch (_that) {
case _CreateRestaurantState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool loading,  bool success,  String? restaurantId,  String? message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateRestaurantState() when $default != null:
return $default(_that.loading,_that.success,_that.restaurantId,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool loading,  bool success,  String? restaurantId,  String? message)  $default,) {final _that = this;
switch (_that) {
case _CreateRestaurantState():
return $default(_that.loading,_that.success,_that.restaurantId,_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool loading,  bool success,  String? restaurantId,  String? message)?  $default,) {final _that = this;
switch (_that) {
case _CreateRestaurantState() when $default != null:
return $default(_that.loading,_that.success,_that.restaurantId,_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _CreateRestaurantState implements CreateRestaurantState {
  const _CreateRestaurantState({this.loading = false, this.success = false, this.restaurantId, this.message});
  

@override@JsonKey() final  bool loading;
@override@JsonKey() final  bool success;
@override final  String? restaurantId;
@override final  String? message;

/// Create a copy of CreateRestaurantState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateRestaurantStateCopyWith<_CreateRestaurantState> get copyWith => __$CreateRestaurantStateCopyWithImpl<_CreateRestaurantState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateRestaurantState&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.success, success) || other.success == success)&&(identical(other.restaurantId, restaurantId) || other.restaurantId == restaurantId)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,loading,success,restaurantId,message);

@override
String toString() {
  return 'CreateRestaurantState(loading: $loading, success: $success, restaurantId: $restaurantId, message: $message)';
}


}

/// @nodoc
abstract mixin class _$CreateRestaurantStateCopyWith<$Res> implements $CreateRestaurantStateCopyWith<$Res> {
  factory _$CreateRestaurantStateCopyWith(_CreateRestaurantState value, $Res Function(_CreateRestaurantState) _then) = __$CreateRestaurantStateCopyWithImpl;
@override @useResult
$Res call({
 bool loading, bool success, String? restaurantId, String? message
});




}
/// @nodoc
class __$CreateRestaurantStateCopyWithImpl<$Res>
    implements _$CreateRestaurantStateCopyWith<$Res> {
  __$CreateRestaurantStateCopyWithImpl(this._self, this._then);

  final _CreateRestaurantState _self;
  final $Res Function(_CreateRestaurantState) _then;

/// Create a copy of CreateRestaurantState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loading = null,Object? success = null,Object? restaurantId = freezed,Object? message = freezed,}) {
  return _then(_CreateRestaurantState(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,restaurantId: freezed == restaurantId ? _self.restaurantId : restaurantId // ignore: cast_nullable_to_non_nullable
as String?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
