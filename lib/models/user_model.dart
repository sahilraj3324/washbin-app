/// User model representing the authenticated user from the backend.
class UserModel {
  final String id;
  final String? userId; // server's unique userId (separate from _id)
  final String? firebaseUid;
  final String? phoneNumber;
  final String? email;
  final String? photo;
  final String? fullName;
  final String? city;
  final String? completeAddress;
  final double wallet;
  final String visibility;
  final bool isProfileComplete;

  UserModel({
    required this.id,
    this.userId,
    this.firebaseUid,
    this.phoneNumber,
    this.email,
    this.photo,
    this.fullName,
    this.city,
    this.completeAddress,
    this.wallet = 0,
    this.visibility = 'Active',
    this.isProfileComplete = false,
  });

  /// True once the user has submitted the onboarding form (set by backend).
  bool get hasCompletedProfile {
    return isProfileComplete ||
        (fullName != null &&
            fullName!.isNotEmpty &&
            fullName != 'New User' &&
            city != null &&
            city!.isNotEmpty &&
            completeAddress != null &&
            completeAddress!.isNotEmpty);
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? json['id'] ?? '',
      userId: json['userId'],
      firebaseUid: json['firebaseUid'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      photo: json['photo'],
      fullName: json['fullName'],
      city: json['city'],
      completeAddress: json['completeAddress'],
      wallet: (json['wallet'] ?? 0).toDouble(),
      visibility: json['visibility'] ?? 'Active',
      isProfileComplete: json['isProfileComplete'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'firebaseUid': firebaseUid,
      'phoneNumber': phoneNumber,
      'email': email,
      'photo': photo,
      'fullName': fullName,
      'city': city,
      'completeAddress': completeAddress,
      'wallet': wallet,
      'visibility': visibility,
      'isProfileComplete': isProfileComplete,
    };
  }
}
