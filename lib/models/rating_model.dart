/// Rating model representing a review/rating document from the backend.
class RatingModel {
  final String id;
  final String bookingId;
  final String profileId;
  final String agentId;
  final String reviewGiven;
  final int stars;
  final List<String> mediaAttached;
  final String visibility;
  final DateTime dateTime;

  RatingModel({
    required this.id,
    required this.bookingId,
    required this.profileId,
    required this.agentId,
    required this.reviewGiven,
    required this.stars,
    this.mediaAttached = const [],
    this.visibility = 'Active',
    required this.dateTime,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      id: json['_id'] ?? json['id'] ?? '',
      bookingId: json['bookingId'] ?? '',
      profileId: json['profileId'] ?? '',
      agentId: json['agentId'] ?? '',
      reviewGiven: json['reviewGiven'] ?? '',
      stars: (json['stars'] ?? 1) as int,
      mediaAttached: List<String>.from(json['mediaAttached'] ?? []),
      visibility: json['visibility'] ?? 'Active',
      dateTime: DateTime.parse(
        json['dateTime'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'profileId': profileId,
      'agentId': agentId,
      'reviewGiven': reviewGiven,
      'stars': stars,
      'mediaAttached': mediaAttached,
      'visibility': visibility,
      'dateTime': dateTime.toIso8601String(),
    };
  }
}
