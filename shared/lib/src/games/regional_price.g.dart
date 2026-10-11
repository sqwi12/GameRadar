// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'regional_price.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RegionalPrice _$RegionalPriceFromJson(Map<String, dynamic> json) =>
    _RegionalPrice(
      price: GamePrice.fromJson(json['price'] as Map<String, dynamic>),
      finalPriceKzt: (json['final_price_kzt'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RegionalPriceToJson(_RegionalPrice instance) =>
    <String, dynamic>{
      'price': instance.price.toJson(),
      'final_price_kzt': ?instance.finalPriceKzt,
    };
