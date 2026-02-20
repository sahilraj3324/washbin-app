import 'user_model.dart';

/// Response model for the /users/firebase-login endpoint.
class AuthResponse {
  final UserModel user;
  final String accessToken;

  AuthResponse({required this.user, required this.accessToken});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      user: UserModel.fromJson(json['user'] ?? {}),
      accessToken: json['accessToken'] ?? '',
    );
  }
}
