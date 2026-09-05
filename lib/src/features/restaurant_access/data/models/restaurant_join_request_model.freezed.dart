// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'restaurant_join_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RestaurantJoinRequestModel {

 String get id;@JsonKey(name: 'restaurant_id') String get restaurantId;@JsonKey(name: 'requester_profile_id') String? get requesterProfileId; String get status;@JsonKey(name: 'created_at') DateTime? get createdAt;
/// Create a copy of RestaurantJoinRequestModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RestaurantJoinRequestModelCopyWith<RestaurantJoinRequestModel> get copyWith => _$RestaurantJoinRequestModelCopyWithImpl<RestaurantJoinRequestModel>(this as RestaurantJoinRequestModel, _$identity);

  /// Serializes this RestaurantJoinRequestModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RestaurantJoinRequestModel&&(identical(other.id, id) || other.id == id)&&(identical(other.restaurantId, restaurantId) || other.restaurantId == restaurantId)&&(identical(other.requesterProfileId, requesterProfileId) || other.requesterProfileId == requesterProfileId)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,restaurantId,requesterProfileId,status,createdAt);

@override
String toString() {
  return 'RestaurantJoinRequestModel(id: $id, restaurantId: $restaurantId, requesterProfileId: $requesterProfileId, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $RestaurantJoinRequestModelCopyWith<$Res>  {
  factory $RestaurantJoinRequestModelCopyWith(RestaurantJoinRequestModel value, $Res Function(RestaurantJoinRequestModel) _then) = _$RestaurantJoinRequestModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'restaurant_id') String restaurantId,@JsonKey(name: 'requester_profile_id') String? requesterProfileId, String status,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class _$RestaurantJoinRequestModelCopyWithImpl<$Res>
    implements $RestaurantJoinRequestModelCopyWith<$Res> {
  _$RestaurantJoinRequestModelCopyWithImpl(this._self, this._then);

  final RestaurantJoinRequestModel _self;
  final $Res Function(RestaurantJoinRequestModel) _then;

/// Create a copy of RestaurantJoinRequestModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? restaurantId = null,Object? requesterProfileId = freezed,Object? status = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,restaurantId: null == restaurantId ? _self.restaurantId : restaurantId // ignore: cast_nullable_to_non_nullable
as String,requesterProfileId: freezed == requesterProfileId ? _self.requesterProfileId : requesterProfileId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [RestaurantJoinRequestModel].
extension RestaurantJoinRequestModelPatterns on RestaurantJoinRequestModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RestaurantJoinRequestModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RestaurantJoinRequestModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RestaurantJoinRequestModel value)  $default,){
final _that = this;
switch (_that) {
case _RestaurantJoinRequestModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RestaurantJoinRequestModel value)?  $default,){
final _that = this;
switch (_that) {
case _RestaurantJoinRequestModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'restaurant_id')  String restaurantId, @JsonKey(name: 'requester_profile_id')  String? requesterProfileId,  String status, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RestaurantJoinRequestModel() when $default != null:
return $default(_that.id,_that.restaurantId,_that.requesterProfileId,_that.status,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'restaurant_id')  String restaurantId, @JsonKey(name: 'requester_profile_id')  String? requesterProfileId,  String status, @JsonKey(name: 'created_at')  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _RestaurantJoinRequestModel():
return $default(_that.id,_that.restaurantId,_that.requesterProfileId,_that.status,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'restaurant_id')  String restaurantId, @JsonKey(name: 'requester_profile_id')  String? requesterProfileId,  String status, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _RestaurantJoinRequestModel() when $default != null:
return $default(_that.id,_that.restaurantId,_that.requesterProfileId,_that.status,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RestaurantJoinRequestModel extends RestaurantJoinRequestModel {
  const _RestaurantJoinRequestModel({required this.id, @JsonKey(name: 'restaurant_id') required this.restaurantId, @JsonKey(name: 'requester_profile_id') this.requesterProfileId, required this.status, @JsonKey(name: 'created_at') this.createdAt}): super._();
  factory _RestaurantJoinRequestModel.fromJson(Map<String, dynamic> json) => _$RestaurantJoinRequestModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'restaurant_id') final  String restaurantId;
@override@JsonKey(name: 'requester_profile_id') final  String? requesterProfileId;
@override final  String status;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;

/// Create a copy of RestaurantJoinRequestModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RestaurantJoinRequestModelCopyWith<_RestaurantJoinRequestModel> get copyWith => __$RestaurantJoinRequestModelCopyWithImpl<_RestaurantJoinRequestModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RestaurantJoinRequestModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RestaurantJoinRequestModel&&(identical(other.id, id) || other.id == id)&&(identical(other.restaurantId, restaurantId) || other.restaurantId == restaurantId)&&(identical(other.requesterProfileId, requesterProfileId) || other.requesterProfileId == requesterProfileId)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,restaurantId,requesterProfileId,status,createdAt);

@override
String toString() {
  return 'RestaurantJoinRequestModel(id: $id, restaurantId: $restaurantId, requesterProfileId: $requesterProfileId, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$RestaurantJoinRequestModelCopyWith<$Res> implements $RestaurantJoinRequestModelCopyWith<$Res> {
  factory _$RestaurantJoinRequestModelCopyWith(_RestaurantJoinRequestModel value, $Res Function(_RestaurantJoinRequestModel) _then) = __$RestaurantJoinRequestModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'restaurant_id') String restaurantId,@JsonKey(name: 'requester_profile_id') String? requesterProfileId, String status,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class __$RestaurantJoinRequestModelCopyWithImpl<$Res>
    implements _$RestaurantJoinRequestModelCopyWith<$Res> {
  __$RestaurantJoinRequestModelCopyWithImpl(this._self, this._then);

  final _RestaurantJoinRequestModel _self;
  final $Res Function(_RestaurantJoinRequestModel) _then;

/// Create a copy of RestaurantJoinRequestModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? restaurantId = null,Object? requesterProfileId = freezed,Object? status = null,Object? createdAt = freezed,}) {
  return _then(_RestaurantJoinRequestModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,restaurantId: null == restaurantId ? _self.restaurantId : restaurantId // ignore: cast_nullable_to_non_nullable
as String,requesterProfileId: freezed == requesterProfileId ? _self.requesterProfileId : requesterProfileId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
