// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'restaurant_membership_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RestaurantMembershipModel {

@JsonKey(name: 'restaurant_id') String get restaurantId; RestaurantRole get role;
/// Create a copy of RestaurantMembershipModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RestaurantMembershipModelCopyWith<RestaurantMembershipModel> get copyWith => _$RestaurantMembershipModelCopyWithImpl<RestaurantMembershipModel>(this as RestaurantMembershipModel, _$identity);

  /// Serializes this RestaurantMembershipModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RestaurantMembershipModel&&(identical(other.restaurantId, restaurantId) || other.restaurantId == restaurantId)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,restaurantId,role);

@override
String toString() {
  return 'RestaurantMembershipModel(restaurantId: $restaurantId, role: $role)';
}


}

/// @nodoc
abstract mixin class $RestaurantMembershipModelCopyWith<$Res>  {
  factory $RestaurantMembershipModelCopyWith(RestaurantMembershipModel value, $Res Function(RestaurantMembershipModel) _then) = _$RestaurantMembershipModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'restaurant_id') String restaurantId, RestaurantRole role
});




}
/// @nodoc
class _$RestaurantMembershipModelCopyWithImpl<$Res>
    implements $RestaurantMembershipModelCopyWith<$Res> {
  _$RestaurantMembershipModelCopyWithImpl(this._self, this._then);

  final RestaurantMembershipModel _self;
  final $Res Function(RestaurantMembershipModel) _then;

/// Create a copy of RestaurantMembershipModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? restaurantId = null,Object? role = null,}) {
  return _then(_self.copyWith(
restaurantId: null == restaurantId ? _self.restaurantId : restaurantId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as RestaurantRole,
  ));
}

}


/// Adds pattern-matching-related methods to [RestaurantMembershipModel].
extension RestaurantMembershipModelPatterns on RestaurantMembershipModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RestaurantMembershipModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RestaurantMembershipModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RestaurantMembershipModel value)  $default,){
final _that = this;
switch (_that) {
case _RestaurantMembershipModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RestaurantMembershipModel value)?  $default,){
final _that = this;
switch (_that) {
case _RestaurantMembershipModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'restaurant_id')  String restaurantId,  RestaurantRole role)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RestaurantMembershipModel() when $default != null:
return $default(_that.restaurantId,_that.role);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'restaurant_id')  String restaurantId,  RestaurantRole role)  $default,) {final _that = this;
switch (_that) {
case _RestaurantMembershipModel():
return $default(_that.restaurantId,_that.role);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'restaurant_id')  String restaurantId,  RestaurantRole role)?  $default,) {final _that = this;
switch (_that) {
case _RestaurantMembershipModel() when $default != null:
return $default(_that.restaurantId,_that.role);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RestaurantMembershipModel extends RestaurantMembershipModel {
  const _RestaurantMembershipModel({@JsonKey(name: 'restaurant_id') required this.restaurantId, required this.role}): super._();
  factory _RestaurantMembershipModel.fromJson(Map<String, dynamic> json) => _$RestaurantMembershipModelFromJson(json);

@override@JsonKey(name: 'restaurant_id') final  String restaurantId;
@override final  RestaurantRole role;

/// Create a copy of RestaurantMembershipModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RestaurantMembershipModelCopyWith<_RestaurantMembershipModel> get copyWith => __$RestaurantMembershipModelCopyWithImpl<_RestaurantMembershipModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RestaurantMembershipModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RestaurantMembershipModel&&(identical(other.restaurantId, restaurantId) || other.restaurantId == restaurantId)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,restaurantId,role);

@override
String toString() {
  return 'RestaurantMembershipModel(restaurantId: $restaurantId, role: $role)';
}


}

/// @nodoc
abstract mixin class _$RestaurantMembershipModelCopyWith<$Res> implements $RestaurantMembershipModelCopyWith<$Res> {
  factory _$RestaurantMembershipModelCopyWith(_RestaurantMembershipModel value, $Res Function(_RestaurantMembershipModel) _then) = __$RestaurantMembershipModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'restaurant_id') String restaurantId, RestaurantRole role
});




}
/// @nodoc
class __$RestaurantMembershipModelCopyWithImpl<$Res>
    implements _$RestaurantMembershipModelCopyWith<$Res> {
  __$RestaurantMembershipModelCopyWithImpl(this._self, this._then);

  final _RestaurantMembershipModel _self;
  final $Res Function(_RestaurantMembershipModel) _then;

/// Create a copy of RestaurantMembershipModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? restaurantId = null,Object? role = null,}) {
  return _then(_RestaurantMembershipModel(
restaurantId: null == restaurantId ? _self.restaurantId : restaurantId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as RestaurantRole,
  ));
}


}

// dart format on
