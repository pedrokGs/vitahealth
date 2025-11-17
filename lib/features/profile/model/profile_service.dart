import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vita_health/features/profile/model/profile_model.dart';

abstract interface class ProfileService {
  Future<Profile?> getProfile(String email);
  Future<bool> saveProfile(Profile profile);
}

class ProfileServiceImpl extends ProfileService {
  final String baseUrl;
  ProfileServiceImpl({required this.baseUrl});

  @override
  Future<Profile?> getProfile(String email) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/profile"));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        for (var p in data) {
          if (p["userEmail"] == email) {
            return Profile.fromMap(p);
          }
        }
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> saveProfile(Profile profile) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/profile"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(profile.toMap()),
      );
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      rethrow;
    }
  }
}
