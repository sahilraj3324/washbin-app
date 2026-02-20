/// Support model representing a help/support ticket from the backend.
class SupportModel {
  final String id;
  final String profileId;
  final String? bookingId;
  final String title;
  final String body;
  final List<String> media;
  final String action;

  SupportModel({
    required this.id,
    required this.profileId,
    this.bookingId,
    required this.title,
    required this.body,
    this.media = const [],
    this.action = 'Open',
  });

  factory SupportModel.fromJson(Map<String, dynamic> json) {
    return SupportModel(
      id: json['_id'] ?? json['id'] ?? '',
      profileId: json['profileId'] ?? '',
      bookingId: json['bookingId'],
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      media: List<String>.from(json['media'] ?? []),
      action: json['action'] ?? 'Open',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'profileId': profileId,
      if (bookingId != null) 'bookingId': bookingId,
      'title': title,
      'body': body,
      'media': media,
      'action': action,
    };
  }
}
