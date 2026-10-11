// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_low.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StoreLow _$StoreLowFromJson(Map<String, dynamic> json) => _StoreLow(
  price: (json['price'] as num).toInt(),
  regularPrice: (json['regular_price'] as num).toInt(),
  cut: (json['cut'] as num).toInt(),
  currency: json['currency'] as String,
  at: DateTime.parse(json['at'] as String),
);

Map<String, dynamic> _$StoreLowToJson(_StoreLow instance) => <String, dynamic>{
  'price': instance.price,
  'regular_price': instance.regularPrice,
  'cut': instance.cut,
  'currency': instance.currency,
  'at': instance.at.toIso8601String(),
};
