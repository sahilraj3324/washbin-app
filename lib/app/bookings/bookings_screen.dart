import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/booking_model.dart';
import 'booking_detail_screen.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mock Bookings for UI demonstration
  final List<BookingModel> _bookings = [
    BookingModel(
      id: 'mock_1',
      bookingId: 'WB-8291',
      profileId: 'prof_1',
      serviceBooked: 'Washroom Cleaning',
      quantity: 1,
      amountPaid: 499.0,
      agentName: 'John Doe',
      agentNumber: '9876543210',
      bookedOn: DateTime(2023, 10, 22),
      bookingDateTime: DateTime(2023, 10, 24, 10, 0),
      status: 'CONFIRMED',
    ),
    BookingModel(
      id: 'mock_2',
      bookingId: 'WB-9012',
      profileId: 'prof_1',
      serviceBooked: 'Sofa Deep Cleaning',
      quantity: 1,
      amountPaid: 899.0,
      agentName: 'Jane Smith',
      agentNumber: '8765432109',
      bookedOn: DateTime(2023, 10, 23),
      bookingDateTime: DateTime(2023, 10, 25, 14, 30),
      status: 'IN PROGRESS',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'My Bookings',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        centerTitle: false,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.notifications_none, color: Colors.black87),
          ),
        ],
      ),
      body: Column(
        children: [
          // Segmented Tab Bar
          Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F5FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              labelColor: const Color(0xFF1D70F5),
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              unselectedLabelColor: Colors.grey[500],
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(text: 'Upcoming'),
                Tab(text: 'Past'),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBookingsList(isUpcoming: true),
                _buildBookingsList(isUpcoming: false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingsList({required bool isUpcoming}) {
    // Filter bookings based on status for demo purposes
    final filteredBookings = _bookings.where((b) {
      if (isUpcoming) {
        return b.status == 'CONFIRMED' || b.status == 'IN PROGRESS';
      } else {
        return b.status == 'COMPLETED' || b.status == 'CANCELLED';
      }
    }).toList();

    if (filteredBookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_note, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              isUpcoming ? 'No upcoming bookings' : 'No past bookings',
              style: TextStyle(color: Colors.grey[500], fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: filteredBookings.length,
      itemBuilder: (context, index) {
        return _buildBookingCard(filteredBookings[index]);
      },
    );
  }

  Widget _buildBookingCard(BookingModel booking) {
    // Determine styles based on status
    Color statusBgColor;
    Color statusTextColor;
    String actionText;

    if (booking.status == 'CONFIRMED') {
      statusBgColor = const Color(0xFFDFF6E7);
      statusTextColor = const Color(0xFF0F9D58);
      actionText = 'Cancel';
    } else if (booking.status == 'IN PROGRESS') {
      statusBgColor = const Color(0xFFFDEAD6); // Orange tint
      statusTextColor = const Color(0xFFD67B27);
      actionText = 'Contact';
    } else if (booking.status == 'COMPLETED') {
      statusBgColor = Colors.grey[200]!;
      statusTextColor = Colors.grey[700]!;
      actionText = 'Rebook';
    } else {
      statusBgColor = const Color(0xFFFFEBEE);
      statusTextColor = Colors.red[700]!;
      actionText = 'Help';
    }

    // Determine icon based on service title
    IconData icon = Icons.cleaning_services;
    final lowerTitle = booking.serviceBooked.toLowerCase();
    if (lowerTitle.contains('washroom')) icon = Icons.shower_outlined;
    if (lowerTitle.contains('sofa')) icon = Icons.weekend_outlined;
    if (lowerTitle.contains('tank')) icon = Icons.water_drop_outlined;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BookingDetailScreen(booking: booking),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[100]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: Icon, Details, Status Pill
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F5FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: const Color(0xFF1D70F5), size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.serviceBooked,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Ref #${booking.id}',
                        style: TextStyle(color: Colors.grey[500], fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    booking.status,
                    style: TextStyle(
                      color: statusTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(height: 1),
            ),

            // Middle row: Date and Time
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat(
                          'MMM dd, yyyy',
                        ).format(booking.bookingDateTime),
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_time_outlined,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat('hh:mm a').format(booking.bookingDateTime),
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Bottom row: Action button
            Text(
              actionText,
              style: const TextStyle(
                color: Color(0xFF0F4A8A), // Dark blue text
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
