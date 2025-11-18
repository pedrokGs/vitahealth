import 'package:vita_health/features/monitoramento/models/monitoramento_record.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class IMonitoramentoService {
  Future<void> enviarMonitoramento(MonitoramentoRecord record);
}

class MonitoramentoService implements IMonitoramentoService {
  final String baseUrl;

  MonitoramentoService({required this.baseUrl});

  Future<void> enviarMonitoramento(MonitoramentoRecord record) async {
    final url = Uri.parse("$baseUrl/monitoramento");

    final response = await http.post(
      url,
      headers: { "Content-Type": "application/json" },
      body: jsonEncode(record.toMap()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Erro ao enviar monitoramento: ${response.body}");
    }
  }
}
