/// Booking model representing a booking document from the backend.
class BookingModel {
  final String id;
  final String bookingId;
  final String profileId;
  final String serviceBooked;
  final int quantity;
  final double amountPaid;
  final String agentName;
  final String agentNumber;
  final DateTime bookedOn;
  final DateTime bookingDateTime;
  final String status;

  BookingModel({
    required this.id,
    required this.bookingId,
    required this.profileId,
    required this.serviceBooked,
    required this.quantity,
    required this.amountPaid,
    required this.agentName,
    required this.agentNumber,
    required this.bookedOn,
    required this.bookingDateTime,
    this.status = 'Pending',
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['_id'] ?? json['id'] ?? '',
      bookingId: json['bookingId'] ?? '',
      profileId: json['profileId'] ?? '',
      serviceBooked: json['serviceBooked'] ?? '',
      quantity: (json['quantity'] ?? 0) as int,
      amountPaid: (json['amountPaid'] ?? 0).toDouble(),
      agentName: json['agentName'] ?? '',
      agentNumber: json['agentNumber'] ?? '',
      bookedOn: DateTime.parse(
        json['bookedOn'] ?? DateTime.now().toIso8601String(),
      ),
      bookingDateTime: DateTime.parse(
        json['bookingDateTime'] ?? DateTime.now().toIso8601String(),
      ),
      status: json['status'] ?? 'Pending',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'profileId': profileId,
      'serviceBooked': serviceBooked,
      'quantity': quantity,
      'amountPaid': amountPaid,
      'agentName': agentName,
      'agentNumber': agentNumber,
      'bookedOn': bookedOn.toIso8601String(),
      'bookingDateTime': bookingDateTime.toIso8601String(),
      'status': status,
    };
  }
}
