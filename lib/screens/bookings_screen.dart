import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';

class Booking {
  String title;

  Booking({required this.title});
}

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
      ),
      body: Consumer<BookingProvider>(
        builder: (context, bookingProvider, child) {
          final bookings = bookingProvider.bookings;

          return bookings.isEmpty
              ? const Center(child: Text('No bookings yet'))
              : ListView.builder(
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final booking = bookings[index];
                    return ListTile(
                      title: Text('Booking #${booking.id}'),
                      subtitle: Text('Status: ${booking.status}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          bookingProvider.removeBooking(booking.id);
                        },
                      ),
                      onTap: () {
                        // Navigate to booking details screen (if applicable)
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => BookingDetailScreen(booking: booking)));
                      },
                    );
                  },
                );
        },
      ),
    );
  }
}
