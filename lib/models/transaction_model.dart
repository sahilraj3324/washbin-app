/// Transaction model representing a payment transaction from the backend.
class TransactionModel {
  final String id;
  final String transactionId;
  final DateTime dateTime;
  final String service;
  final String profileId;
  final double amount;
  final String status;

  TransactionModel({
    required this.id,
    required this.transactionId,
    required this.dateTime,
    required this.service,
    required this.profileId,
    required this.amount,
    this.status = 'Pending',
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['_id'] ?? json['id'] ?? '',
      transactionId: json['transactionId'] ?? '',
      dateTime: DateTime.parse(
        json['dateTime'] ?? DateTime.now().toIso8601String(),
      ),
      service: json['service'] ?? '',
      profileId: json['profileId'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      status: json['status'] ?? 'Pending',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transactionId': transactionId,
      'dateTime': dateTime.toIso8601String(),
      'service': service,
      'profileId': profileId,
      'amount': amount,
      'status': status,
    };
  }
}
