import 'package:json_annotation/json_annotation.dart';

part 'turf.g.dart';

@JsonSerializable()
class Turf {
  final int id;
  final String name;
  final String description;
  final double price;
  final String location;
  final List<String> amenities;

  Turf({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.location,
    required this.amenities,
  });

  factory Turf.fromJson(Map<String, dynamic> json) => _$TurfFromJson(json);
  Map<String, dynamic> toJson() => _$TurfToJson(this);

  // Fallback fromJson in case something goes wrong
  factory Turf.fallback() {
    return Turf(
      id: 0,
      name: '',
      description: '',
      price: 0.0,
      location: '',
      amenities: [],
    );
  }
}
