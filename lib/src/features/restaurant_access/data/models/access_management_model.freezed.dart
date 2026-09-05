// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'access_management_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$JoinInvitationModel {

@JsonKey(name: 'restaurant_id') String get restaurantId;@JsonKey(name: 'restaurant_name') String get name; String? get address;
/// Create a copy of JoinInvitationModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JoinInvitationModelCopyWith<JoinInvitationModel> get copyWith => _$JoinInvitationModelCopyWithImpl<JoinInvitationModel>(this as JoinInvitationModel, _$identity);

  /// Serializes this JoinInvitationModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JoinInvitationModel&&(identical(other.restaurantId, restaurantId) || other.restaurantId == restaurantId)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,restaurantId,name,address);

@override
String toString() {
  return 'JoinInvitationModel(restaurantId: $restaurantId, name: $name, address: $address)';
}


}

/// @nodoc
abstract mixin class $JoinInvitationModelCopyWith<$Res>  {
  factory $JoinInvitationModelCopyWith(JoinInvitationModel value, $Res Function(JoinInvitationModel) _then) = _$JoinInvitationModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'restaurant_id') String restaurantId,@JsonKey(name: 'restaurant_name') String name, String? address
});




}
/// @nodoc
class _$JoinInvitationModelCopyWithImpl<$Res>
    implements $JoinInvitationModelCopyWith<$Res> {
  _$JoinInvitationModelCopyWithImpl(this._self, this._then);

  final JoinInvitationModel _self;
  final $Res Function(JoinInvitationModel) _then;

/// Create a copy of JoinInvitationModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? restaurantId = null,Object? name = null,Object? address = freezed,}) {
  return _then(_self.copyWith(
restaurantId: null == restaurantId ? _self.restaurantId : restaurantId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [JoinInvitationModel].
extension JoinInvitationModelPatterns on JoinInvitationModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JoinInvitationModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JoinInvitationModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JoinInvitationModel value)  $default,){
final _that = this;
switch (_that) {
case _JoinInvitationModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JoinInvitationModel value)?  $default,){
final _that = this;
switch (_that) {
case _JoinInvitationModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'restaurant_id')  String restaurantId, @JsonKey(name: 'restaurant_name')  String name,  String? address)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JoinInvitationModel() when $default != null:
return $default(_that.restaurantId,_that.name,_that.address);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'restaurant_id')  String restaurantId, @JsonKey(name: 'restaurant_name')  String name,  String? address)  $default,) {final _that = this;
switch (_that) {
case _JoinInvitationModel():
return $default(_that.restaurantId,_that.name,_that.address);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'restaurant_id')  String restaurantId, @JsonKey(name: 'restaurant_name')  String name,  String? address)?  $default,) {final _that = this;
switch (_that) {
case _JoinInvitationModel() when $default != null:
return $default(_that.restaurantId,_that.name,_that.address);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JoinInvitationModel extends JoinInvitationModel {
  const _JoinInvitationModel({@JsonKey(name: 'restaurant_id') required this.restaurantId, @JsonKey(name: 'restaurant_name') required this.name, this.address}): super._();
  factory _JoinInvitationModel.fromJson(Map<String, dynamic> json) => _$JoinInvitationModelFromJson(json);

@override@JsonKey(name: 'restaurant_id') final  String restaurantId;
@override@JsonKey(name: 'restaurant_name') final  String name;
@override final  String? address;

/// Create a copy of JoinInvitationModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JoinInvitationModelCopyWith<_JoinInvitationModel> get copyWith => __$JoinInvitationModelCopyWithImpl<_JoinInvitationModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JoinInvitationModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JoinInvitationModel&&(identical(other.restaurantId, restaurantId) || other.restaurantId == restaurantId)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,restaurantId,name,address);

@override
String toString() {
  return 'JoinInvitationModel(restaurantId: $restaurantId, name: $name, address: $address)';
}


}

/// @nodoc
abstract mixin class _$JoinInvitationModelCopyWith<$Res> implements $JoinInvitationModelCopyWith<$Res> {
  factory _$JoinInvitationModelCopyWith(_JoinInvitationModel value, $Res Function(_JoinInvitationModel) _then) = __$JoinInvitationModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'restaurant_id') String restaurantId,@JsonKey(name: 'restaurant_name') String name, String? address
});




}
/// @nodoc
class __$JoinInvitationModelCopyWithImpl<$Res>
    implements _$JoinInvitationModelCopyWith<$Res> {
  __$JoinInvitationModelCopyWithImpl(this._self, this._then);

  final _JoinInvitationModel _self;
  final $Res Function(_JoinInvitationModel) _then;

/// Create a copy of JoinInvitationModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? restaurantId = null,Object? name = null,Object? address = freezed,}) {
  return _then(_JoinInvitationModel(
restaurantId: null == restaurantId ? _self.restaurantId : restaurantId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$AccessPersonModel {

 String get id; String get name; String get role; String? get email;
/// Create a copy of AccessPersonModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccessPersonModelCopyWith<AccessPersonModel> get copyWith => _$AccessPersonModelCopyWithImpl<AccessPersonModel>(this as AccessPersonModel, _$identity);

  /// Serializes this AccessPersonModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccessPersonModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.role, role) || other.role == role)&&(identical(other.email, email) || other.email == email));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,role,email);

@override
String toString() {
  return 'AccessPersonModel(id: $id, name: $name, role: $role, email: $email)';
}


}

/// @nodoc
abstract mixin class $AccessPersonModelCopyWith<$Res>  {
  factory $AccessPersonModelCopyWith(AccessPersonModel value, $Res Function(AccessPersonModel) _then) = _$AccessPersonModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String role, String? email
});




}
/// @nodoc
class _$AccessPersonModelCopyWithImpl<$Res>
    implements $AccessPersonModelCopyWith<$Res> {
  _$AccessPersonModelCopyWithImpl(this._self, this._then);

  final AccessPersonModel _self;
  final $Res Function(AccessPersonModel) _then;

/// Create a copy of AccessPersonModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? role = null,Object? email = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AccessPersonModel].
extension AccessPersonModelPatterns on AccessPersonModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccessPersonModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccessPersonModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccessPersonModel value)  $default,){
final _that = this;
switch (_that) {
case _AccessPersonModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccessPersonModel value)?  $default,){
final _that = this;
switch (_that) {
case _AccessPersonModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String role,  String? email)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccessPersonModel() when $default != null:
return $default(_that.id,_that.name,_that.role,_that.email);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String role,  String? email)  $default,) {final _that = this;
switch (_that) {
case _AccessPersonModel():
return $default(_that.id,_that.name,_that.role,_that.email);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String role,  String? email)?  $default,) {final _that = this;
switch (_that) {
case _AccessPersonModel() when $default != null:
return $default(_that.id,_that.name,_that.role,_that.email);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AccessPersonModel extends AccessPersonModel {
  const _AccessPersonModel({required this.id, required this.name, required this.role, this.email}): super._();
  factory _AccessPersonModel.fromJson(Map<String, dynamic> json) => _$AccessPersonModelFromJson(json);

@override final  String id;
@override final  String name;
@override final  String role;
@override final  String? email;

/// Create a copy of AccessPersonModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccessPersonModelCopyWith<_AccessPersonModel> get copyWith => __$AccessPersonModelCopyWithImpl<_AccessPersonModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AccessPersonModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccessPersonModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.role, role) || other.role == role)&&(identical(other.email, email) || other.email == email));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,role,email);

@override
String toString() {
  return 'AccessPersonModel(id: $id, name: $name, role: $role, email: $email)';
}


}

/// @nodoc
abstract mixin class _$AccessPersonModelCopyWith<$Res> implements $AccessPersonModelCopyWith<$Res> {
  factory _$AccessPersonModelCopyWith(_AccessPersonModel value, $Res Function(_AccessPersonModel) _then) = __$AccessPersonModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String role, String? email
});




}
/// @nodoc
class __$AccessPersonModelCopyWithImpl<$Res>
    implements _$AccessPersonModelCopyWith<$Res> {
  __$AccessPersonModelCopyWithImpl(this._self, this._then);

  final _AccessPersonModel _self;
  final $Res Function(_AccessPersonModel) _then;

/// Create a copy of AccessPersonModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? role = null,Object? email = freezed,}) {
  return _then(_AccessPersonModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$MembersAccessModel {

@JsonKey(name: 'restaurant_name') String get restaurantName;@JsonKey(name: 'is_owner') bool get isOwner;@JsonKey(name: 'join_code') String? get joinCode;@JsonKey(name: 'currency_code') String? get currencyCode; List<AccessPersonModel> get members; List<AccessPersonModel> get requests;
/// Create a copy of MembersAccessModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MembersAccessModelCopyWith<MembersAccessModel> get copyWith => _$MembersAccessModelCopyWithImpl<MembersAccessModel>(this as MembersAccessModel, _$identity);

  /// Serializes this MembersAccessModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MembersAccessModel&&(identical(other.restaurantName, restaurantName) || other.restaurantName == restaurantName)&&(identical(other.isOwner, isOwner) || other.isOwner == isOwner)&&(identical(other.joinCode, joinCode) || other.joinCode == joinCode)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode)&&const DeepCollectionEquality().equals(other.members, members)&&const DeepCollectionEquality().equals(other.requests, requests));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,restaurantName,isOwner,joinCode,currencyCode,const DeepCollectionEquality().hash(members),const DeepCollectionEquality().hash(requests));

@override
String toString() {
  return 'MembersAccessModel(restaurantName: $restaurantName, isOwner: $isOwner, joinCode: $joinCode, currencyCode: $currencyCode, members: $members, requests: $requests)';
}


}

/// @nodoc
abstract mixin class $MembersAccessModelCopyWith<$Res>  {
  factory $MembersAccessModelCopyWith(MembersAccessModel value, $Res Function(MembersAccessModel) _then) = _$MembersAccessModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'restaurant_name') String restaurantName,@JsonKey(name: 'is_owner') bool isOwner,@JsonKey(name: 'join_code') String? joinCode,@JsonKey(name: 'currency_code') String? currencyCode, List<AccessPersonModel> members, List<AccessPersonModel> requests
});




}
/// @nodoc
class _$MembersAccessModelCopyWithImpl<$Res>
    implements $MembersAccessModelCopyWith<$Res> {
  _$MembersAccessModelCopyWithImpl(this._self, this._then);

  final MembersAccessModel _self;
  final $Res Function(MembersAccessModel) _then;

/// Create a copy of MembersAccessModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? restaurantName = null,Object? isOwner = null,Object? joinCode = freezed,Object? currencyCode = freezed,Object? members = null,Object? requests = null,}) {
  return _then(_self.copyWith(
restaurantName: null == restaurantName ? _self.restaurantName : restaurantName // ignore: cast_nullable_to_non_nullable
as String,isOwner: null == isOwner ? _self.isOwner : isOwner // ignore: cast_nullable_to_non_nullable
as bool,joinCode: freezed == joinCode ? _self.joinCode : joinCode // ignore: cast_nullable_to_non_nullable
as String?,currencyCode: freezed == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String?,members: null == members ? _self.members : members // ignore: cast_nullable_to_non_nullable
as List<AccessPersonModel>,requests: null == requests ? _self.requests : requests // ignore: cast_nullable_to_non_nullable
as List<AccessPersonModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [MembersAccessModel].
extension MembersAccessModelPatterns on MembersAccessModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MembersAccessModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MembersAccessModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MembersAccessModel value)  $default,){
final _that = this;
switch (_that) {
case _MembersAccessModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MembersAccessModel value)?  $default,){
final _that = this;
switch (_that) {
case _MembersAccessModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'restaurant_name')  String restaurantName, @JsonKey(name: 'is_owner')  bool isOwner, @JsonKey(name: 'join_code')  String? joinCode, @JsonKey(name: 'currency_code')  String? currencyCode,  List<AccessPersonModel> members,  List<AccessPersonModel> requests)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MembersAccessModel() when $default != null:
return $default(_that.restaurantName,_that.isOwner,_that.joinCode,_that.currencyCode,_that.members,_that.requests);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'restaurant_name')  String restaurantName, @JsonKey(name: 'is_owner')  bool isOwner, @JsonKey(name: 'join_code')  String? joinCode, @JsonKey(name: 'currency_code')  String? currencyCode,  List<AccessPersonModel> members,  List<AccessPersonModel> requests)  $default,) {final _that = this;
switch (_that) {
case _MembersAccessModel():
return $default(_that.restaurantName,_that.isOwner,_that.joinCode,_that.currencyCode,_that.members,_that.requests);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'restaurant_name')  String restaurantName, @JsonKey(name: 'is_owner')  bool isOwner, @JsonKey(name: 'join_code')  String? joinCode, @JsonKey(name: 'currency_code')  String? currencyCode,  List<AccessPersonModel> members,  List<AccessPersonModel> requests)?  $default,) {final _that = this;
switch (_that) {
case _MembersAccessModel() when $default != null:
return $default(_that.restaurantName,_that.isOwner,_that.joinCode,_that.currencyCode,_that.members,_that.requests);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MembersAccessModel extends MembersAccessModel {
  const _MembersAccessModel({@JsonKey(name: 'restaurant_name') required this.restaurantName, @JsonKey(name: 'is_owner') required this.isOwner, @JsonKey(name: 'join_code') this.joinCode, @JsonKey(name: 'currency_code') this.currencyCode, required final  List<AccessPersonModel> members, required final  List<AccessPersonModel> requests}): _members = members,_requests = requests,super._();
  factory _MembersAccessModel.fromJson(Map<String, dynamic> json) => _$MembersAccessModelFromJson(json);

@override@JsonKey(name: 'restaurant_name') final  String restaurantName;
@override@JsonKey(name: 'is_owner') final  bool isOwner;
@override@JsonKey(name: 'join_code') final  String? joinCode;
@override@JsonKey(name: 'currency_code') final  String? currencyCode;
 final  List<AccessPersonModel> _members;
@override List<AccessPersonModel> get members {
  if (_members is EqualUnmodifiableListView) return _members;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_members);
}

 final  List<AccessPersonModel> _requests;
@override List<AccessPersonModel> get requests {
  if (_requests is EqualUnmodifiableListView) return _requests;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_requests);
}


/// Create a copy of MembersAccessModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MembersAccessModelCopyWith<_MembersAccessModel> get copyWith => __$MembersAccessModelCopyWithImpl<_MembersAccessModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MembersAccessModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MembersAccessModel&&(identical(other.restaurantName, restaurantName) || other.restaurantName == restaurantName)&&(identical(other.isOwner, isOwner) || other.isOwner == isOwner)&&(identical(other.joinCode, joinCode) || other.joinCode == joinCode)&&(identical(other.currencyCode, currencyCode) || other.currencyCode == currencyCode)&&const DeepCollectionEquality().equals(other._members, _members)&&const DeepCollectionEquality().equals(other._requests, _requests));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,restaurantName,isOwner,joinCode,currencyCode,const DeepCollectionEquality().hash(_members),const DeepCollectionEquality().hash(_requests));

@override
String toString() {
  return 'MembersAccessModel(restaurantName: $restaurantName, isOwner: $isOwner, joinCode: $joinCode, currencyCode: $currencyCode, members: $members, requests: $requests)';
}


}

/// @nodoc
abstract mixin class _$MembersAccessModelCopyWith<$Res> implements $MembersAccessModelCopyWith<$Res> {
  factory _$MembersAccessModelCopyWith(_MembersAccessModel value, $Res Function(_MembersAccessModel) _then) = __$MembersAccessModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'restaurant_name') String restaurantName,@JsonKey(name: 'is_owner') bool isOwner,@JsonKey(name: 'join_code') String? joinCode,@JsonKey(name: 'currency_code') String? currencyCode, List<AccessPersonModel> members, List<AccessPersonModel> requests
});




}
/// @nodoc
class __$MembersAccessModelCopyWithImpl<$Res>
    implements _$MembersAccessModelCopyWith<$Res> {
  __$MembersAccessModelCopyWithImpl(this._self, this._then);

  final _MembersAccessModel _self;
  final $Res Function(_MembersAccessModel) _then;

/// Create a copy of MembersAccessModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? restaurantName = null,Object? isOwner = null,Object? joinCode = freezed,Object? currencyCode = freezed,Object? members = null,Object? requests = null,}) {
  return _then(_MembersAccessModel(
restaurantName: null == restaurantName ? _self.restaurantName : restaurantName // ignore: cast_nullable_to_non_nullable
as String,isOwner: null == isOwner ? _self.isOwner : isOwner // ignore: cast_nullable_to_non_nullable
as bool,joinCode: freezed == joinCode ? _self.joinCode : joinCode // ignore: cast_nullable_to_non_nullable
as String?,currencyCode: freezed == currencyCode ? _self.currencyCode : currencyCode // ignore: cast_nullable_to_non_nullable
as String?,members: null == members ? _self._members : members // ignore: cast_nullable_to_non_nullable
as List<AccessPersonModel>,requests: null == requests ? _self._requests : requests // ignore: cast_nullable_to_non_nullable
as List<AccessPersonModel>,
  ));
}


}

// dart format on
