// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'turf.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Turf _$TurfFromJson(Map<String, dynamic> json) => Turf(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      location: json['location'] as String,
      amenities:
          (json['amenities'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$TurfToJson(Turf instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'location': instance.location,
      'amenities': instance.amenities,
    };
