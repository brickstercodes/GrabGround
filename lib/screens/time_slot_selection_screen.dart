import 'package:flutter/material.dart';
import '../models/booking_flow.dart';

class TimeSlotSelectionScreen extends StatefulWidget {
  final String facilityId;
  final String facilityName;
  final String sport;

  const TimeSlotSelectionScreen({
    super.key,
    required this.facilityId,
    required this.facilityName,
    required this.sport,
  });

  @override
  State<TimeSlotSelectionScreen> createState() =>
      _TimeSlotSelectionScreenState();
}

class _TimeSlotSelectionScreenState extends State<TimeSlotSelectionScreen> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  final List<TimeOfDay> availableSlots = [
    const TimeOfDay(hour: 9, minute: 0),
    const TimeOfDay(hour: 10, minute: 0),
    const TimeOfDay(hour: 11, minute: 0),
    const TimeOfDay(hour: 12, minute: 0),
    const TimeOfDay(hour: 13, minute: 0),
    const TimeOfDay(hour: 14, minute: 0),
    const TimeOfDay(hour: 15, minute: 0),
    const TimeOfDay(hour: 16, minute: 0),
    const TimeOfDay(hour: 17, minute: 0),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Time Slot'),
      ),
      body: Column(
        children: [
          // Date Selection
          ListTile(
            title: const Text('Date'),
            subtitle: Text(
              '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
            ),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 30)),
              );
              if (date != null) {
                setState(() => selectedDate = date);
              }
            },
          ),

          const Divider(),

          // Time Slots
          Expanded(
            child: ListView.builder(
              itemCount: availableSlots.length - 1,
              itemBuilder: (context, index) {
                final start = availableSlots[index];
                final end = availableSlots[index + 1];
                final isSelected = startTime == start && endTime == end;

                return ListTile(
                  title: Text('${_formatTime(start)} - ${_formatTime(end)}'),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : const Icon(Icons.circle_outlined),
                  onTap: () {
                    setState(() {
                      startTime = start;
                      endTime = end;
                    });
                  },
                );
              },
            ),
          ),

          // Continue Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: startTime != null && endTime != null
                  ? () {
                      final booking = BookingFlow(
                        facilityId: widget.facilityId,
                        facilityName: widget.facilityName,
                        sport: widget.sport,
                        date: selectedDate,
                        startTime: startTime!,
                        endTime: endTime!,
                        pricePerHour:
                            90.0, // You might want to fetch this from the facility
                      );

                      Navigator.pushNamed(
                        context,
                        '/billing',
                        arguments: booking,
                      );
                    }
                  : null,
              child: const Text('Continue to Payment'),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
}
