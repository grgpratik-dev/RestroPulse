// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'restaurant_access_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RestaurantAccessState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RestaurantAccessState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RestaurantAccessState()';
}


}

/// @nodoc
class $RestaurantAccessStateCopyWith<$Res>  {
$RestaurantAccessStateCopyWith(RestaurantAccessState _, $Res Function(RestaurantAccessState) __);
}


/// Adds pattern-matching-related methods to [RestaurantAccessState].
extension RestaurantAccessStatePatterns on RestaurantAccessState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( RestaurantAccessInitial value)?  initial,TResult Function( RestaurantAccessLoading value)?  loading,TResult Function( RestaurantAccessNoRestaurant value)?  noRestaurant,TResult Function( RestaurantAccessPendingJoinRequest value)?  pendingJoinRequest,TResult Function( RestaurantAccessHasRestaurant value)?  hasRestaurant,TResult Function( RestaurantAccessFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case RestaurantAccessInitial() when initial != null:
return initial(_that);case RestaurantAccessLoading() when loading != null:
return loading(_that);case RestaurantAccessNoRestaurant() when noRestaurant != null:
return noRestaurant(_that);case RestaurantAccessPendingJoinRequest() when pendingJoinRequest != null:
return pendingJoinRequest(_that);case RestaurantAccessHasRestaurant() when hasRestaurant != null:
return hasRestaurant(_that);case RestaurantAccessFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( RestaurantAccessInitial value)  initial,required TResult Function( RestaurantAccessLoading value)  loading,required TResult Function( RestaurantAccessNoRestaurant value)  noRestaurant,required TResult Function( RestaurantAccessPendingJoinRequest value)  pendingJoinRequest,required TResult Function( RestaurantAccessHasRestaurant value)  hasRestaurant,required TResult Function( RestaurantAccessFailure value)  failure,}){
final _that = this;
switch (_that) {
case RestaurantAccessInitial():
return initial(_that);case RestaurantAccessLoading():
return loading(_that);case RestaurantAccessNoRestaurant():
return noRestaurant(_that);case RestaurantAccessPendingJoinRequest():
return pendingJoinRequest(_that);case RestaurantAccessHasRestaurant():
return hasRestaurant(_that);case RestaurantAccessFailure():
return failure(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( RestaurantAccessInitial value)?  initial,TResult? Function( RestaurantAccessLoading value)?  loading,TResult? Function( RestaurantAccessNoRestaurant value)?  noRestaurant,TResult? Function( RestaurantAccessPendingJoinRequest value)?  pendingJoinRequest,TResult? Function( RestaurantAccessHasRestaurant value)?  hasRestaurant,TResult? Function( RestaurantAccessFailure value)?  failure,}){
final _that = this;
switch (_that) {
case RestaurantAccessInitial() when initial != null:
return initial(_that);case RestaurantAccessLoading() when loading != null:
return loading(_that);case RestaurantAccessNoRestaurant() when noRestaurant != null:
return noRestaurant(_that);case RestaurantAccessPendingJoinRequest() when pendingJoinRequest != null:
return pendingJoinRequest(_that);case RestaurantAccessHasRestaurant() when hasRestaurant != null:
return hasRestaurant(_that);case RestaurantAccessFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function()?  noRestaurant,TResult Function( RestaurantJoinRequest request)?  pendingJoinRequest,TResult Function( String restaurantId,  RestaurantRole role)?  hasRestaurant,TResult Function( Failure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case RestaurantAccessInitial() when initial != null:
return initial();case RestaurantAccessLoading() when loading != null:
return loading();case RestaurantAccessNoRestaurant() when noRestaurant != null:
return noRestaurant();case RestaurantAccessPendingJoinRequest() when pendingJoinRequest != null:
return pendingJoinRequest(_that.request);case RestaurantAccessHasRestaurant() when hasRestaurant != null:
return hasRestaurant(_that.restaurantId,_that.role);case RestaurantAccessFailure() when failure != null:
return failure(_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function()  noRestaurant,required TResult Function( RestaurantJoinRequest request)  pendingJoinRequest,required TResult Function( String restaurantId,  RestaurantRole role)  hasRestaurant,required TResult Function( Failure failure)  failure,}) {final _that = this;
switch (_that) {
case RestaurantAccessInitial():
return initial();case RestaurantAccessLoading():
return loading();case RestaurantAccessNoRestaurant():
return noRestaurant();case RestaurantAccessPendingJoinRequest():
return pendingJoinRequest(_that.request);case RestaurantAccessHasRestaurant():
return hasRestaurant(_that.restaurantId,_that.role);case RestaurantAccessFailure():
return failure(_that.failure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function()?  noRestaurant,TResult? Function( RestaurantJoinRequest request)?  pendingJoinRequest,TResult? Function( String restaurantId,  RestaurantRole role)?  hasRestaurant,TResult? Function( Failure failure)?  failure,}) {final _that = this;
switch (_that) {
case RestaurantAccessInitial() when initial != null:
return initial();case RestaurantAccessLoading() when loading != null:
return loading();case RestaurantAccessNoRestaurant() when noRestaurant != null:
return noRestaurant();case RestaurantAccessPendingJoinRequest() when pendingJoinRequest != null:
return pendingJoinRequest(_that.request);case RestaurantAccessHasRestaurant() when hasRestaurant != null:
return hasRestaurant(_that.restaurantId,_that.role);case RestaurantAccessFailure() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class RestaurantAccessInitial extends RestaurantAccessState {
  const RestaurantAccessInitial(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RestaurantAccessInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RestaurantAccessState.initial()';
}


}




/// @nodoc


class RestaurantAccessLoading extends RestaurantAccessState {
  const RestaurantAccessLoading(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RestaurantAccessLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RestaurantAccessState.loading()';
}


}




/// @nodoc


class RestaurantAccessNoRestaurant extends RestaurantAccessState {
  const RestaurantAccessNoRestaurant(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RestaurantAccessNoRestaurant);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RestaurantAccessState.noRestaurant()';
}


}




/// @nodoc


class RestaurantAccessPendingJoinRequest extends RestaurantAccessState {
  const RestaurantAccessPendingJoinRequest({required this.request}): super._();
  

 final  RestaurantJoinRequest request;

/// Create a copy of RestaurantAccessState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RestaurantAccessPendingJoinRequestCopyWith<RestaurantAccessPendingJoinRequest> get copyWith => _$RestaurantAccessPendingJoinRequestCopyWithImpl<RestaurantAccessPendingJoinRequest>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RestaurantAccessPendingJoinRequest&&(identical(other.request, request) || other.request == request));
}


@override
int get hashCode => Object.hash(runtimeType,request);

@override
String toString() {
  return 'RestaurantAccessState.pendingJoinRequest(request: $request)';
}


}

/// @nodoc
abstract mixin class $RestaurantAccessPendingJoinRequestCopyWith<$Res> implements $RestaurantAccessStateCopyWith<$Res> {
  factory $RestaurantAccessPendingJoinRequestCopyWith(RestaurantAccessPendingJoinRequest value, $Res Function(RestaurantAccessPendingJoinRequest) _then) = _$RestaurantAccessPendingJoinRequestCopyWithImpl;
@useResult
$Res call({
 RestaurantJoinRequest request
});




}
/// @nodoc
class _$RestaurantAccessPendingJoinRequestCopyWithImpl<$Res>
    implements $RestaurantAccessPendingJoinRequestCopyWith<$Res> {
  _$RestaurantAccessPendingJoinRequestCopyWithImpl(this._self, this._then);

  final RestaurantAccessPendingJoinRequest _self;
  final $Res Function(RestaurantAccessPendingJoinRequest) _then;

/// Create a copy of RestaurantAccessState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? request = null,}) {
  return _then(RestaurantAccessPendingJoinRequest(
request: null == request ? _self.request : request // ignore: cast_nullable_to_non_nullable
as RestaurantJoinRequest,
  ));
}


}

/// @nodoc


class RestaurantAccessHasRestaurant extends RestaurantAccessState {
  const RestaurantAccessHasRestaurant({required this.restaurantId, required this.role}): super._();
  

 final  String restaurantId;
 final  RestaurantRole role;

/// Create a copy of RestaurantAccessState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RestaurantAccessHasRestaurantCopyWith<RestaurantAccessHasRestaurant> get copyWith => _$RestaurantAccessHasRestaurantCopyWithImpl<RestaurantAccessHasRestaurant>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RestaurantAccessHasRestaurant&&(identical(other.restaurantId, restaurantId) || other.restaurantId == restaurantId)&&(identical(other.role, role) || other.role == role));
}


@override
int get hashCode => Object.hash(runtimeType,restaurantId,role);

@override
String toString() {
  return 'RestaurantAccessState.hasRestaurant(restaurantId: $restaurantId, role: $role)';
}


}

/// @nodoc
abstract mixin class $RestaurantAccessHasRestaurantCopyWith<$Res> implements $RestaurantAccessStateCopyWith<$Res> {
  factory $RestaurantAccessHasRestaurantCopyWith(RestaurantAccessHasRestaurant value, $Res Function(RestaurantAccessHasRestaurant) _then) = _$RestaurantAccessHasRestaurantCopyWithImpl;
@useResult
$Res call({
 String restaurantId, RestaurantRole role
});




}
/// @nodoc
class _$RestaurantAccessHasRestaurantCopyWithImpl<$Res>
    implements $RestaurantAccessHasRestaurantCopyWith<$Res> {
  _$RestaurantAccessHasRestaurantCopyWithImpl(this._self, this._then);

  final RestaurantAccessHasRestaurant _self;
  final $Res Function(RestaurantAccessHasRestaurant) _then;

/// Create a copy of RestaurantAccessState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? restaurantId = null,Object? role = null,}) {
  return _then(RestaurantAccessHasRestaurant(
restaurantId: null == restaurantId ? _self.restaurantId : restaurantId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as RestaurantRole,
  ));
}


}

/// @nodoc


class RestaurantAccessFailure extends RestaurantAccessState {
  const RestaurantAccessFailure({required this.failure}): super._();
  

 final  Failure failure;

/// Create a copy of RestaurantAccessState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RestaurantAccessFailureCopyWith<RestaurantAccessFailure> get copyWith => _$RestaurantAccessFailureCopyWithImpl<RestaurantAccessFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RestaurantAccessFailure&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'RestaurantAccessState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $RestaurantAccessFailureCopyWith<$Res> implements $RestaurantAccessStateCopyWith<$Res> {
  factory $RestaurantAccessFailureCopyWith(RestaurantAccessFailure value, $Res Function(RestaurantAccessFailure) _then) = _$RestaurantAccessFailureCopyWithImpl;
@useResult
$Res call({
 Failure failure
});




}
/// @nodoc
class _$RestaurantAccessFailureCopyWithImpl<$Res>
    implements $RestaurantAccessFailureCopyWith<$Res> {
  _$RestaurantAccessFailureCopyWithImpl(this._self, this._then);

  final RestaurantAccessFailure _self;
  final $Res Function(RestaurantAccessFailure) _then;

/// Create a copy of RestaurantAccessState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(RestaurantAccessFailure(
failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}


}

// dart format on
