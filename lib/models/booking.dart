// TODO Implement this library.

class Booking {
  final String id;
  final String facilityId;
  final String userId;
  final DateTime startTime;
  final DateTime endTime;
  final double totalAmount;
  final String status; // pending, confirmed, cancelled, completed

  Booking({
    required this.id,
    required this.facilityId,
    required this.userId,
    required this.startTime,
    required this.endTime,
    required this.totalAmount,
    required this.status,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      facilityId: json['facilityId'],
      userId: json['userId'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      totalAmount: json['totalAmount'].toDouble(),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'facilityId': facilityId,
      'userId': userId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'totalAmount': totalAmount,
      'status': status,
    };
  }
}
