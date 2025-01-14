import '../../turf/models/turf.dart';

class ChatResponse {
  final String message;
  final List<Turf> similarTurfs;
  final DateTime timestamp;

  ChatResponse({
    required this.message,
    required this.similarTurfs,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      message: json['message'] as String,
      similarTurfs: (json['similar_turfs'] as List)
          .map((t) => Turf.fromJson(t as Map<String, dynamic>))
          .toList(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}
