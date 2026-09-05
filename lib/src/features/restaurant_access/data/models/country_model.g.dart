// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CountryModel _$CountryModelFromJson(Map<String, dynamic> json) =>
    _CountryModel(
      code: json['code'] as String,
      name: json['name'] as String,
      flag: json['flag'] as String,
      currencyCodes: (json['currencyCodes'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      defaultCurrencyCode: json['defaultCurrencyCode'] as String?,
    );

Map<String, dynamic> _$CountryModelToJson(_CountryModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
      'flag': instance.flag,
      'currencyCodes': instance.currencyCodes,
      'defaultCurrencyCode': instance.defaultCurrencyCode,
    };
