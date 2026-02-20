/// Service model representing a washroom/cleaning service from the backend.
class ServiceModel {
  final String id;
  final String serviceId;
  final String serviceTitle;
  final String serviceBody;
  final String serviceTime;
  final String serviceNature;
  final String? serviceWarranty;
  final double mrp;
  final double actualAmount;
  final List<String> whatsIncluded;
  final String visibility;
  final List<String> availableIn;

  ServiceModel({
    required this.id,
    required this.serviceId,
    required this.serviceTitle,
    required this.serviceBody,
    required this.serviceTime,
    required this.serviceNature,
    this.serviceWarranty,
    required this.mrp,
    required this.actualAmount,
    this.whatsIncluded = const [],
    this.visibility = 'Active',
    required this.availableIn,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['_id'] ?? json['id'] ?? '',
      serviceId: json['serviceId'] ?? '',
      serviceTitle: json['serviceTitle'] ?? '',
      serviceBody: json['serviceBody'] ?? '',
      serviceTime: json['serviceTime'] ?? '',
      serviceNature: json['serviceNature'] ?? '',
      serviceWarranty: json['serviceWarranty'],
      mrp: (json['mrp'] ?? 0).toDouble(),
      actualAmount: (json['actualAmount'] ?? 0).toDouble(),
      whatsIncluded: List<String>.from(json['whatsIncluded'] ?? []),
      visibility: json['visibility'] ?? 'Active',
      availableIn: List<String>.from(json['availableIn'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serviceId': serviceId,
      'serviceTitle': serviceTitle,
      'serviceBody': serviceBody,
      'serviceTime': serviceTime,
      'serviceNature': serviceNature,
      'serviceWarranty': serviceWarranty,
      'mrp': mrp,
      'actualAmount': actualAmount,
      'whatsIncluded': whatsIncluded,
      'visibility': visibility,
      'availableIn': availableIn,
    };
  }

  /// Convenience: percentage discount over MRP.
  double get discountPercent =>
      mrp > 0 ? ((mrp - actualAmount) / mrp * 100) : 0;
}
