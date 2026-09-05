// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'country_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CountryModel {

 String get code; String get name; String get flag; List<String> get currencyCodes; String? get defaultCurrencyCode;
/// Create a copy of CountryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CountryModelCopyWith<CountryModel> get copyWith => _$CountryModelCopyWithImpl<CountryModel>(this as CountryModel, _$identity);

  /// Serializes this CountryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CountryModel&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.flag, flag) || other.flag == flag)&&const DeepCollectionEquality().equals(other.currencyCodes, currencyCodes)&&(identical(other.defaultCurrencyCode, defaultCurrencyCode) || other.defaultCurrencyCode == defaultCurrencyCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,name,flag,const DeepCollectionEquality().hash(currencyCodes),defaultCurrencyCode);

@override
String toString() {
  return 'CountryModel(code: $code, name: $name, flag: $flag, currencyCodes: $currencyCodes, defaultCurrencyCode: $defaultCurrencyCode)';
}


}

/// @nodoc
abstract mixin class $CountryModelCopyWith<$Res>  {
  factory $CountryModelCopyWith(CountryModel value, $Res Function(CountryModel) _then) = _$CountryModelCopyWithImpl;
@useResult
$Res call({
 String code, String name, String flag, List<String> currencyCodes, String? defaultCurrencyCode
});




}
/// @nodoc
class _$CountryModelCopyWithImpl<$Res>
    implements $CountryModelCopyWith<$Res> {
  _$CountryModelCopyWithImpl(this._self, this._then);

  final CountryModel _self;
  final $Res Function(CountryModel) _then;

/// Create a copy of CountryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? name = null,Object? flag = null,Object? currencyCodes = null,Object? defaultCurrencyCode = freezed,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,flag: null == flag ? _self.flag : flag // ignore: cast_nullable_to_non_nullable
as String,currencyCodes: null == currencyCodes ? _self.currencyCodes : currencyCodes // ignore: cast_nullable_to_non_nullable
as List<String>,defaultCurrencyCode: freezed == defaultCurrencyCode ? _self.defaultCurrencyCode : defaultCurrencyCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CountryModel].
extension CountryModelPatterns on CountryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CountryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CountryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CountryModel value)  $default,){
final _that = this;
switch (_that) {
case _CountryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CountryModel value)?  $default,){
final _that = this;
switch (_that) {
case _CountryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String name,  String flag,  List<String> currencyCodes,  String? defaultCurrencyCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CountryModel() when $default != null:
return $default(_that.code,_that.name,_that.flag,_that.currencyCodes,_that.defaultCurrencyCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String name,  String flag,  List<String> currencyCodes,  String? defaultCurrencyCode)  $default,) {final _that = this;
switch (_that) {
case _CountryModel():
return $default(_that.code,_that.name,_that.flag,_that.currencyCodes,_that.defaultCurrencyCode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String name,  String flag,  List<String> currencyCodes,  String? defaultCurrencyCode)?  $default,) {final _that = this;
switch (_that) {
case _CountryModel() when $default != null:
return $default(_that.code,_that.name,_that.flag,_that.currencyCodes,_that.defaultCurrencyCode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CountryModel extends CountryModel {
  const _CountryModel({required this.code, required this.name, required this.flag, required final  List<String> currencyCodes, this.defaultCurrencyCode}): _currencyCodes = currencyCodes,super._();
  factory _CountryModel.fromJson(Map<String, dynamic> json) => _$CountryModelFromJson(json);

@override final  String code;
@override final  String name;
@override final  String flag;
 final  List<String> _currencyCodes;
@override List<String> get currencyCodes {
  if (_currencyCodes is EqualUnmodifiableListView) return _currencyCodes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_currencyCodes);
}

@override final  String? defaultCurrencyCode;

/// Create a copy of CountryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CountryModelCopyWith<_CountryModel> get copyWith => __$CountryModelCopyWithImpl<_CountryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CountryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CountryModel&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.flag, flag) || other.flag == flag)&&const DeepCollectionEquality().equals(other._currencyCodes, _currencyCodes)&&(identical(other.defaultCurrencyCode, defaultCurrencyCode) || other.defaultCurrencyCode == defaultCurrencyCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,name,flag,const DeepCollectionEquality().hash(_currencyCodes),defaultCurrencyCode);

@override
String toString() {
  return 'CountryModel(code: $code, name: $name, flag: $flag, currencyCodes: $currencyCodes, defaultCurrencyCode: $defaultCurrencyCode)';
}


}

/// @nodoc
abstract mixin class _$CountryModelCopyWith<$Res> implements $CountryModelCopyWith<$Res> {
  factory _$CountryModelCopyWith(_CountryModel value, $Res Function(_CountryModel) _then) = __$CountryModelCopyWithImpl;
@override @useResult
$Res call({
 String code, String name, String flag, List<String> currencyCodes, String? defaultCurrencyCode
});




}
/// @nodoc
class __$CountryModelCopyWithImpl<$Res>
    implements _$CountryModelCopyWith<$Res> {
  __$CountryModelCopyWithImpl(this._self, this._then);

  final _CountryModel _self;
  final $Res Function(_CountryModel) _then;

/// Create a copy of CountryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? name = null,Object? flag = null,Object? currencyCodes = null,Object? defaultCurrencyCode = freezed,}) {
  return _then(_CountryModel(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,flag: null == flag ? _self.flag : flag // ignore: cast_nullable_to_non_nullable
as String,currencyCodes: null == currencyCodes ? _self._currencyCodes : currencyCodes // ignore: cast_nullable_to_non_nullable
as List<String>,defaultCurrencyCode: freezed == defaultCurrencyCode ? _self.defaultCurrencyCode : defaultCurrencyCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
