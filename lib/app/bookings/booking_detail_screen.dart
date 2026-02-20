import 'package:flutter/material.dart';
import '../../models/booking_model.dart';
import 'package:intl/intl.dart';

class BookingDetailScreen extends StatelessWidget {
  final BookingModel booking;
  const BookingDetailScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Booking Details')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Service: ${booking.serviceBooked}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text('Status: ${booking.status}'),
            const SizedBox(height: 8),
            Text(
              'Date: ${DateFormat.yMMMMEEEEd().format(booking.bookingDateTime)}',
            ),
            const SizedBox(height: 8),
            Text('Agent: ${booking.agentName} (${booking.agentNumber})'),
            const SizedBox(height: 8),
            Text('Amount Paid: ₹${booking.amountPaid}'),
            const Spacer(),
            if (booking.status == 'Pending')
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Cancel booking
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Cancel Booking'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
