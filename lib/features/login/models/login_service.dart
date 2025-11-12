import 'dart:convert';

import 'package:http/http.dart' as http;

abstract interface class LoginService {
  Future<void> loginUser({required String email, required String password});
}

class LoginServiceImpl extends LoginService {
  final String baseUrl;
  LoginServiceImpl({required this.baseUrl});

  @override
  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/users"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        for (var user in data) {
          if (user["email"] == email || user["password"] == password) {
            return;
          }
          throw Exception("Usuário/Senha inválidos");
        }
      } else {
        throw Exception("Erro desconhecido");
      }
    } on Exception catch (e) {
      rethrow;
    }
  }
}
