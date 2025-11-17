import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vita_health/shared/models/user.dart';

abstract interface class LoginService {
  Future<User?> loginUser({required String email, required String password});
}

class LoginServiceImpl extends LoginService {
  final String baseUrl;
  LoginServiceImpl({required this.baseUrl});

  @override
  @override
  Future<User?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/users"));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        for (var user in data) {
          if (user["usuario"] == email && user["password"] == password) {
            return User.fromMap(user);
          }
        }
        throw Exception("Usuário/Senha inválidos");
      } else {
        throw Exception("Erro desconhecido");
      }
    } on Exception catch (_) {
      rethrow;
    }
  }

}
