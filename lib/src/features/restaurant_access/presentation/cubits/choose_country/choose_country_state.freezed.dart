// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'choose_country_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChooseCountryState {

 ChooseCountryStatus get status; List<Country> get countries; List<Country> get filteredCountries; String get query; Country? get selectedCountry; String? get message;
/// Create a copy of ChooseCountryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChooseCountryStateCopyWith<ChooseCountryState> get copyWith => _$ChooseCountryStateCopyWithImpl<ChooseCountryState>(this as ChooseCountryState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChooseCountryState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.countries, countries)&&const DeepCollectionEquality().equals(other.filteredCountries, filteredCountries)&&(identical(other.query, query) || other.query == query)&&(identical(other.selectedCountry, selectedCountry) || other.selectedCountry == selectedCountry)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(countries),const DeepCollectionEquality().hash(filteredCountries),query,selectedCountry,message);

@override
String toString() {
  return 'ChooseCountryState(status: $status, countries: $countries, filteredCountries: $filteredCountries, query: $query, selectedCountry: $selectedCountry, message: $message)';
}


}

/// @nodoc
abstract mixin class $ChooseCountryStateCopyWith<$Res>  {
  factory $ChooseCountryStateCopyWith(ChooseCountryState value, $Res Function(ChooseCountryState) _then) = _$ChooseCountryStateCopyWithImpl;
@useResult
$Res call({
 ChooseCountryStatus status, List<Country> countries, List<Country> filteredCountries, String query, Country? selectedCountry, String? message
});




}
/// @nodoc
class _$ChooseCountryStateCopyWithImpl<$Res>
    implements $ChooseCountryStateCopyWith<$Res> {
  _$ChooseCountryStateCopyWithImpl(this._self, this._then);

  final ChooseCountryState _self;
  final $Res Function(ChooseCountryState) _then;

/// Create a copy of ChooseCountryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? countries = null,Object? filteredCountries = null,Object? query = null,Object? selectedCountry = freezed,Object? message = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ChooseCountryStatus,countries: null == countries ? _self.countries : countries // ignore: cast_nullable_to_non_nullable
as List<Country>,filteredCountries: null == filteredCountries ? _self.filteredCountries : filteredCountries // ignore: cast_nullable_to_non_nullable
as List<Country>,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,selectedCountry: freezed == selectedCountry ? _self.selectedCountry : selectedCountry // ignore: cast_nullable_to_non_nullable
as Country?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChooseCountryState].
extension ChooseCountryStatePatterns on ChooseCountryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChooseCountryState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChooseCountryState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChooseCountryState value)  $default,){
final _that = this;
switch (_that) {
case _ChooseCountryState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChooseCountryState value)?  $default,){
final _that = this;
switch (_that) {
case _ChooseCountryState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ChooseCountryStatus status,  List<Country> countries,  List<Country> filteredCountries,  String query,  Country? selectedCountry,  String? message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChooseCountryState() when $default != null:
return $default(_that.status,_that.countries,_that.filteredCountries,_that.query,_that.selectedCountry,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ChooseCountryStatus status,  List<Country> countries,  List<Country> filteredCountries,  String query,  Country? selectedCountry,  String? message)  $default,) {final _that = this;
switch (_that) {
case _ChooseCountryState():
return $default(_that.status,_that.countries,_that.filteredCountries,_that.query,_that.selectedCountry,_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ChooseCountryStatus status,  List<Country> countries,  List<Country> filteredCountries,  String query,  Country? selectedCountry,  String? message)?  $default,) {final _that = this;
switch (_that) {
case _ChooseCountryState() when $default != null:
return $default(_that.status,_that.countries,_that.filteredCountries,_that.query,_that.selectedCountry,_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _ChooseCountryState implements ChooseCountryState {
  const _ChooseCountryState({this.status = ChooseCountryStatus.initial, final  List<Country> countries = const <Country>[], final  List<Country> filteredCountries = const <Country>[], this.query = '', this.selectedCountry, this.message}): _countries = countries,_filteredCountries = filteredCountries;
  

@override@JsonKey() final  ChooseCountryStatus status;
 final  List<Country> _countries;
@override@JsonKey() List<Country> get countries {
  if (_countries is EqualUnmodifiableListView) return _countries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_countries);
}

 final  List<Country> _filteredCountries;
@override@JsonKey() List<Country> get filteredCountries {
  if (_filteredCountries is EqualUnmodifiableListView) return _filteredCountries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_filteredCountries);
}

@override@JsonKey() final  String query;
@override final  Country? selectedCountry;
@override final  String? message;

/// Create a copy of ChooseCountryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChooseCountryStateCopyWith<_ChooseCountryState> get copyWith => __$ChooseCountryStateCopyWithImpl<_ChooseCountryState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChooseCountryState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._countries, _countries)&&const DeepCollectionEquality().equals(other._filteredCountries, _filteredCountries)&&(identical(other.query, query) || other.query == query)&&(identical(other.selectedCountry, selectedCountry) || other.selectedCountry == selectedCountry)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_countries),const DeepCollectionEquality().hash(_filteredCountries),query,selectedCountry,message);

@override
String toString() {
  return 'ChooseCountryState(status: $status, countries: $countries, filteredCountries: $filteredCountries, query: $query, selectedCountry: $selectedCountry, message: $message)';
}


}

/// @nodoc
abstract mixin class _$ChooseCountryStateCopyWith<$Res> implements $ChooseCountryStateCopyWith<$Res> {
  factory _$ChooseCountryStateCopyWith(_ChooseCountryState value, $Res Function(_ChooseCountryState) _then) = __$ChooseCountryStateCopyWithImpl;
@override @useResult
$Res call({
 ChooseCountryStatus status, List<Country> countries, List<Country> filteredCountries, String query, Country? selectedCountry, String? message
});




}
/// @nodoc
class __$ChooseCountryStateCopyWithImpl<$Res>
    implements _$ChooseCountryStateCopyWith<$Res> {
  __$ChooseCountryStateCopyWithImpl(this._self, this._then);

  final _ChooseCountryState _self;
  final $Res Function(_ChooseCountryState) _then;

/// Create a copy of ChooseCountryState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? countries = null,Object? filteredCountries = null,Object? query = null,Object? selectedCountry = freezed,Object? message = freezed,}) {
  return _then(_ChooseCountryState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ChooseCountryStatus,countries: null == countries ? _self._countries : countries // ignore: cast_nullable_to_non_nullable
as List<Country>,filteredCountries: null == filteredCountries ? _self._filteredCountries : filteredCountries // ignore: cast_nullable_to_non_nullable
as List<Country>,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,selectedCountry: freezed == selectedCountry ? _self.selectedCountry : selectedCountry // ignore: cast_nullable_to_non_nullable
as Country?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
