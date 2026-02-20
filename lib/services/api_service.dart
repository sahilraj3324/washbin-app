import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/auth_response.dart';
import '../models/user_model.dart';
import '../models/booking_model.dart';
import '../models/service_model.dart';
import '../models/rating_model.dart';
import '../models/transaction_model.dart';
import '../models/support_model.dart';

/// Service for communicating with the washbin backend API.
class ApiService {
  // Update this to your actual backend URL
  static const String baseUrl = 'https://washbin-server.vercel.app';

  // ─────────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────────

  Map<String, String> _authHeaders(String token) => {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };

  Map<String, String> get _jsonHeaders => {'Content-Type': 'application/json'};

  Never _throw(http.Response response) {
    final errorBody = jsonDecode(response.body);
    // NestJS validation errors return `message` as a List<String>.
    // Coerce either form to a plain string before throwing.
    final rawMessage = errorBody['message'];
    final message = rawMessage is List
        ? rawMessage.join(', ')
        : (rawMessage?.toString() ?? 'Request failed');
    throw ApiException(statusCode: response.statusCode, message: message);
  }

  // ─────────────────────────────────────────────
  // AUTH / USERS
  // ─────────────────────────────────────────────

  /// POST /users/firebase-login — Exchange Firebase token for App JWT.
  Future<AuthResponse> loginWithFirebase(
    String firebaseToken, {
    String? name,
  }) async {
    final url = Uri.parse('$baseUrl/users/firebase-login');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $firebaseToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({if (name != null && name.isNotEmpty) 'name': name}),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return AuthResponse.fromJson(jsonDecode(response.body));
    }
    _throw(response);
  }

  /// GET /users/:id
  Future<UserModel> getUser(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$id'));
    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    }
    _throw(response);
  }

  /// GET /users/userId/:userId
  Future<UserModel> getUserByUserId(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/users/userId/$userId'));
    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    }
    _throw(response);
  }

  /// PATCH /users/:id — Update user profile.
  Future<UserModel> updateUserProfile(
    String userId,
    Map<String, dynamic> data,
    String token,
  ) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/users/$userId'),
      headers: _authHeaders(token),
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    }
    _throw(response);
  }

  /// DELETE /users/:id
  Future<void> deleteUser(String id, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/users/$id'),
      headers: _authHeaders(token),
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      _throw(response);
    }
  }

  // ─────────────────────────────────────────────
  // BOOKINGS
  // ─────────────────────────────────────────────

  /// GET /bookings
  Future<List<BookingModel>> getBookings(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/bookings'),
      headers: _authHeaders(token),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => BookingModel.fromJson(e)).toList();
    }
    _throw(response);
  }

  /// GET /bookings/:id
  Future<BookingModel> getBooking(String id, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/bookings/$id'),
      headers: _authHeaders(token),
    );
    if (response.statusCode == 200) {
      return BookingModel.fromJson(jsonDecode(response.body));
    }
    _throw(response);
  }

  /// GET /bookings/profile/:profileId
  Future<List<BookingModel>> getBookingsByProfile(
    String profileId,
    String token,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/bookings/profile/$profileId'),
      headers: _authHeaders(token),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => BookingModel.fromJson(e)).toList();
    }
    _throw(response);
  }

  /// POST /bookings
  Future<BookingModel> createBooking(
    Map<String, dynamic> data,
    String token,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/bookings'),
      headers: _authHeaders(token),
      body: jsonEncode(data),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return BookingModel.fromJson(jsonDecode(response.body));
    }
    _throw(response);
  }

  /// PATCH /bookings/:id
  Future<BookingModel> updateBooking(
    String id,
    Map<String, dynamic> data,
    String token,
  ) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/bookings/$id'),
      headers: _authHeaders(token),
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      return BookingModel.fromJson(jsonDecode(response.body));
    }
    _throw(response);
  }

  /// DELETE /bookings/:id
  Future<void> deleteBooking(String id, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/bookings/$id'),
      headers: _authHeaders(token),
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      _throw(response);
    }
  }

  // ─────────────────────────────────────────────
  // SERVICES
  // ─────────────────────────────────────────────

  /// GET /services
  Future<List<ServiceModel>> getServices() async {
    final response = await http.get(
      Uri.parse('$baseUrl/services'),
      headers: _jsonHeaders,
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => ServiceModel.fromJson(e)).toList();
    }
    _throw(response);
  }

  /// GET /services/:id
  Future<ServiceModel> getService(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/services/$id'),
      headers: _jsonHeaders,
    );
    if (response.statusCode == 200) {
      return ServiceModel.fromJson(jsonDecode(response.body));
    }
    _throw(response);
  }

  /// GET /services/city/:city
  Future<List<ServiceModel>> getServicesByCity(String city) async {
    final response = await http.get(
      Uri.parse('$baseUrl/services/city/$city'),
      headers: _jsonHeaders,
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => ServiceModel.fromJson(e)).toList();
    }
    _throw(response);
  }

  /// POST /services
  Future<ServiceModel> createService(
    Map<String, dynamic> data,
    String token,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/services'),
      headers: _authHeaders(token),
      body: jsonEncode(data),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return ServiceModel.fromJson(jsonDecode(response.body));
    }
    _throw(response);
  }

  /// PATCH /services/:id
  Future<ServiceModel> updateService(
    String id,
    Map<String, dynamic> data,
    String token,
  ) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/services/$id'),
      headers: _authHeaders(token),
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      return ServiceModel.fromJson(jsonDecode(response.body));
    }
    _throw(response);
  }

  /// DELETE /services/:id
  Future<void> deleteService(String id, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/services/$id'),
      headers: _authHeaders(token),
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      _throw(response);
    }
  }

  // ─────────────────────────────────────────────
  // RATINGS
  // ─────────────────────────────────────────────

  /// GET /ratings
  Future<List<RatingModel>> getRatings() async {
    final response = await http.get(
      Uri.parse('$baseUrl/ratings'),
      headers: _jsonHeaders,
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => RatingModel.fromJson(e)).toList();
    }
    _throw(response);
  }

  /// GET /ratings/:id
  Future<RatingModel> getRating(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/ratings/$id'),
      headers: _jsonHeaders,
    );
    if (response.statusCode == 200) {
      return RatingModel.fromJson(jsonDecode(response.body));
    }
    _throw(response);
  }

  /// GET /ratings/booking/:bookingId
  Future<List<RatingModel>> getRatingsByBooking(String bookingId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/ratings/booking/$bookingId'),
      headers: _jsonHeaders,
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => RatingModel.fromJson(e)).toList();
    }
    _throw(response);
  }

  /// GET /ratings/agent/:agentId
  Future<List<RatingModel>> getRatingsByAgent(String agentId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/ratings/agent/$agentId'),
      headers: _jsonHeaders,
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => RatingModel.fromJson(e)).toList();
    }
    _throw(response);
  }

  /// POST /ratings
  Future<RatingModel> createRating(
    Map<String, dynamic> data,
    String token,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/ratings'),
      headers: _authHeaders(token),
      body: jsonEncode(data),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return RatingModel.fromJson(jsonDecode(response.body));
    }
    _throw(response);
  }

  /// PATCH /ratings/:id
  Future<RatingModel> updateRating(
    String id,
    Map<String, dynamic> data,
    String token,
  ) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/ratings/$id'),
      headers: _authHeaders(token),
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      return RatingModel.fromJson(jsonDecode(response.body));
    }
    _throw(response);
  }

  /// DELETE /ratings/:id
  Future<void> deleteRating(String id, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/ratings/$id'),
      headers: _authHeaders(token),
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      _throw(response);
    }
  }

  // ─────────────────────────────────────────────
  // TRANSACTIONS
  // ─────────────────────────────────────────────

  /// GET /transactions
  Future<List<TransactionModel>> getTransactions(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/transactions'),
      headers: _authHeaders(token),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => TransactionModel.fromJson(e)).toList();
    }
    _throw(response);
  }

  /// GET /transactions/:id
  Future<TransactionModel> getTransaction(String id, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/transactions/$id'),
      headers: _authHeaders(token),
    );
    if (response.statusCode == 200) {
      return TransactionModel.fromJson(jsonDecode(response.body));
    }
    _throw(response);
  }

  /// GET /transactions/profile/:profileId
  Future<List<TransactionModel>> getTransactionsByProfile(
    String profileId,
    String token,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/transactions/profile/$profileId'),
      headers: _authHeaders(token),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => TransactionModel.fromJson(e)).toList();
    }
    _throw(response);
  }

  /// POST /transactions
  Future<TransactionModel> createTransaction(
    Map<String, dynamic> data,
    String token,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/transactions'),
      headers: _authHeaders(token),
      body: jsonEncode(data),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return TransactionModel.fromJson(jsonDecode(response.body));
    }
    _throw(response);
  }

  /// PATCH /transactions/:id
  Future<TransactionModel> updateTransaction(
    String id,
    Map<String, dynamic> data,
    String token,
  ) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/transactions/$id'),
      headers: _authHeaders(token),
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      return TransactionModel.fromJson(jsonDecode(response.body));
    }
    _throw(response);
  }

  /// DELETE /transactions/:id
  Future<void> deleteTransaction(String id, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/transactions/$id'),
      headers: _authHeaders(token),
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      _throw(response);
    }
  }

  // ─────────────────────────────────────────────
  // SUPPORT
  // ─────────────────────────────────────────────

  /// GET /support
  Future<List<SupportModel>> getSupportTickets(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/support'),
      headers: _authHeaders(token),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => SupportModel.fromJson(e)).toList();
    }
    _throw(response);
  }

  /// GET /support/:id
  Future<SupportModel> getSupportTicket(String id, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/support/$id'),
      headers: _authHeaders(token),
    );
    if (response.statusCode == 200) {
      return SupportModel.fromJson(jsonDecode(response.body));
    }
    _throw(response);
  }

  /// GET /support/profile/:profileId
  Future<List<SupportModel>> getSupportTicketsByProfile(
    String profileId,
    String token,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/support/profile/$profileId'),
      headers: _authHeaders(token),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => SupportModel.fromJson(e)).toList();
    }
    _throw(response);
  }

  /// GET /support/status/:action  (action = 'Open' | 'Closed' | 'Forwarded')
  Future<List<SupportModel>> getSupportTicketsByStatus(
    String action,
    String token,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/support/status/$action'),
      headers: _authHeaders(token),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => SupportModel.fromJson(e)).toList();
    }
    _throw(response);
  }

  /// POST /support
  Future<SupportModel> createSupportTicket(
    Map<String, dynamic> data,
    String token,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/support'),
      headers: _authHeaders(token),
      body: jsonEncode(data),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return SupportModel.fromJson(jsonDecode(response.body));
    }
    _throw(response);
  }

  /// PATCH /support/:id
  Future<SupportModel> updateSupportTicket(
    String id,
    Map<String, dynamic> data,
    String token,
  ) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/support/$id'),
      headers: _authHeaders(token),
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      return SupportModel.fromJson(jsonDecode(response.body));
    }
    _throw(response);
  }

  /// DELETE /support/:id
  Future<void> deleteSupportTicket(String id, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/support/$id'),
      headers: _authHeaders(token),
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      _throw(response);
    }
  }
}

/// Custom exception for API errors.
class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException({required this.statusCode, required this.message});

  @override
  String toString() => 'ApiException: $statusCode - $message';
}
