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
    try {
      return ChatResponse(
        message: json['message']?.toString() ?? '',
        similarTurfs: (json['similar_turfs'] as List?)
            ?.map((t) {
              try {
                return Turf.fromJson(Map<String, dynamic>.from(t));
              } catch (e) {
                print('Error parsing turf: $e');
                return Turf.fallback();
              }
            })
            .toList() ??
            [],
        timestamp: json['timestamp'] != null
            ? DateTime.parse(json['timestamp'].toString())
            : DateTime.now(),
      );
    } catch (e) {
      print('Error parsing ChatResponse: $e');
      return ChatResponse(
        message: 'Error parsing response',
        similarTurfs: [],
      );
    }
  }
}
