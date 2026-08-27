// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'restaurant_access_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RestaurantAccessModel {

@JsonKey(name: 'restaurant_id') String get restaurantId; RestaurantRole? get role;@JsonKey(name: 'status') String? get requestStatus;
/// Create a copy of RestaurantAccessModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RestaurantAccessModelCopyWith<RestaurantAccessModel> get copyWith => _$RestaurantAccessModelCopyWithImpl<RestaurantAccessModel>(this as RestaurantAccessModel, _$identity);

  /// Serializes this RestaurantAccessModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RestaurantAccessModel&&(identical(other.restaurantId, restaurantId) || other.restaurantId == restaurantId)&&(identical(other.role, role) || other.role == role)&&(identical(other.requestStatus, requestStatus) || other.requestStatus == requestStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,restaurantId,role,requestStatus);

@override
String toString() {
  return 'RestaurantAccessModel(restaurantId: $restaurantId, role: $role, requestStatus: $requestStatus)';
}


}

/// @nodoc
abstract mixin class $RestaurantAccessModelCopyWith<$Res>  {
  factory $RestaurantAccessModelCopyWith(RestaurantAccessModel value, $Res Function(RestaurantAccessModel) _then) = _$RestaurantAccessModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'restaurant_id') String restaurantId, RestaurantRole? role,@JsonKey(name: 'status') String? requestStatus
});




}
/// @nodoc
class _$RestaurantAccessModelCopyWithImpl<$Res>
    implements $RestaurantAccessModelCopyWith<$Res> {
  _$RestaurantAccessModelCopyWithImpl(this._self, this._then);

  final RestaurantAccessModel _self;
  final $Res Function(RestaurantAccessModel) _then;

/// Create a copy of RestaurantAccessModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? restaurantId = null,Object? role = freezed,Object? requestStatus = freezed,}) {
  return _then(_self.copyWith(
restaurantId: null == restaurantId ? _self.restaurantId : restaurantId // ignore: cast_nullable_to_non_nullable
as String,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as RestaurantRole?,requestStatus: freezed == requestStatus ? _self.requestStatus : requestStatus // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RestaurantAccessModel].
extension RestaurantAccessModelPatterns on RestaurantAccessModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RestaurantAccessModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RestaurantAccessModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RestaurantAccessModel value)  $default,){
final _that = this;
switch (_that) {
case _RestaurantAccessModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RestaurantAccessModel value)?  $default,){
final _that = this;
switch (_that) {
case _RestaurantAccessModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'restaurant_id')  String restaurantId,  RestaurantRole? role, @JsonKey(name: 'status')  String? requestStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RestaurantAccessModel() when $default != null:
return $default(_that.restaurantId,_that.role,_that.requestStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'restaurant_id')  String restaurantId,  RestaurantRole? role, @JsonKey(name: 'status')  String? requestStatus)  $default,) {final _that = this;
switch (_that) {
case _RestaurantAccessModel():
return $default(_that.restaurantId,_that.role,_that.requestStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'restaurant_id')  String restaurantId,  RestaurantRole? role, @JsonKey(name: 'status')  String? requestStatus)?  $default,) {final _that = this;
switch (_that) {
case _RestaurantAccessModel() when $default != null:
return $default(_that.restaurantId,_that.role,_that.requestStatus);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RestaurantAccessModel extends RestaurantAccessModel {
  const _RestaurantAccessModel({@JsonKey(name: 'restaurant_id') required this.restaurantId, this.role, @JsonKey(name: 'status') this.requestStatus}): super._();
  factory _RestaurantAccessModel.fromJson(Map<String, dynamic> json) => _$RestaurantAccessModelFromJson(json);

@override@JsonKey(name: 'restaurant_id') final  String restaurantId;
@override final  RestaurantRole? role;
@override@JsonKey(name: 'status') final  String? requestStatus;

/// Create a copy of RestaurantAccessModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RestaurantAccessModelCopyWith<_RestaurantAccessModel> get copyWith => __$RestaurantAccessModelCopyWithImpl<_RestaurantAccessModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RestaurantAccessModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RestaurantAccessModel&&(identical(other.restaurantId, restaurantId) || other.restaurantId == restaurantId)&&(identical(other.role, role) || other.role == role)&&(identical(other.requestStatus, requestStatus) || other.requestStatus == requestStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,restaurantId,role,requestStatus);

@override
String toString() {
  return 'RestaurantAccessModel(restaurantId: $restaurantId, role: $role, requestStatus: $requestStatus)';
}


}

/// @nodoc
abstract mixin class _$RestaurantAccessModelCopyWith<$Res> implements $RestaurantAccessModelCopyWith<$Res> {
  factory _$RestaurantAccessModelCopyWith(_RestaurantAccessModel value, $Res Function(_RestaurantAccessModel) _then) = __$RestaurantAccessModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'restaurant_id') String restaurantId, RestaurantRole? role,@JsonKey(name: 'status') String? requestStatus
});




}
/// @nodoc
class __$RestaurantAccessModelCopyWithImpl<$Res>
    implements _$RestaurantAccessModelCopyWith<$Res> {
  __$RestaurantAccessModelCopyWithImpl(this._self, this._then);

  final _RestaurantAccessModel _self;
  final $Res Function(_RestaurantAccessModel) _then;

/// Create a copy of RestaurantAccessModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? restaurantId = null,Object? role = freezed,Object? requestStatus = freezed,}) {
  return _then(_RestaurantAccessModel(
restaurantId: null == restaurantId ? _self.restaurantId : restaurantId // ignore: cast_nullable_to_non_nullable
as String,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as RestaurantRole?,requestStatus: freezed == requestStatus ? _self.requestStatus : requestStatus // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
