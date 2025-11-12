import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vita_health/shared/models/user.dart';

abstract interface class RegisterService {
  Future<void> registerUser({required User user});
}

class RegisterServiceImpl implements RegisterService {
  final String baseUrl;
  RegisterServiceImpl({required this.baseUrl});

  @override
  Future<void> registerUser({required User user}) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/users"),
        headers: <String, String> {
          "Content-Type": "application/json"
        },
        body: jsonEncode(user.toMap())
      );
      if (response.statusCode == 201) {
        return;
      } else {
        throw Exception();
      }
    } on Exception catch (e) {
      rethrow;
    }
  }
}
