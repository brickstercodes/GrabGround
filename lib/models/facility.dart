// lib/models/facility.dart
class Facility {
  final String id;
  final String name;
  final String address;
  final String managerId;
  final List<String> images;
  final double pricePerHour;
  final Map<String, dynamic> amenities;
  final String sportType; // football, cricket, etc.

  Facility({
    required this.id,
    required this.name,
    required this.address,
    required this.managerId,
    required this.images,
    required this.pricePerHour,
    required this.amenities,
    required this.sportType,
  });

  factory Facility.fromJson(Map<String, dynamic> json) {
    return Facility(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      managerId: json['managerId'],
      images: List<String>.from(json['images']),
      pricePerHour: json['pricePerHour'].toDouble(),
      amenities: json['amenities'],
      sportType: json['sportType'],
    );
  }
}
