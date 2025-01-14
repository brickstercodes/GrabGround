import 'package:flutter/material.dart';

class BookingFlow {
  final String facilityId;
  final String facilityName;
  final String sport;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final double pricePerHour;

  BookingFlow({
    required this.facilityId,
    required this.facilityName,
    required this.sport,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.pricePerHour,
  });

  double get subtotal {
    final hours = endTime.hour -
        startTime.hour +
        (endTime.minute - startTime.minute) / 60;
    return hours * pricePerHour;
  }

  double get tax => subtotal * 0.09; // 9% tax
  double get total => subtotal + tax;
}
