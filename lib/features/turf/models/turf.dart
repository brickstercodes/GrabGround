import 'package:json_annotation/json_annotation.dart';

part 'turf.g.dart';

@JsonSerializable()
class Turf {
  final int id;
  final String name;
  final String description;
  final double price;
  final String location;
  final String type;
  final List<double>? embedding;
  final DateTime createdAt;

  Turf({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.location,
    required this.type,
    this.embedding,
    required this.createdAt,
  });

  factory Turf.fromJson(Map<String, dynamic> json) => _$TurfFromJson(json);
  Map<String, dynamic> toJson() => _$TurfToJson(this);
}
