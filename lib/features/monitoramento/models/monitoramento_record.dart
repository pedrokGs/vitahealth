class MonitoramentoRecord {
  final String userId;
  final double totalDistance;
  final String totalTime;
  final DateTime createdAt;

  MonitoramentoRecord({
    required this.userId,
    required this.totalDistance,
    required this.totalTime,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'totalDistance': totalDistance,
      'totalTime': totalTime,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory MonitoramentoRecord.fromMap(Map<String, dynamic> map) {
    return MonitoramentoRecord(
      userId: map['userId'],
      totalDistance: map['totalDistance'],
      totalTime: map['totalTime'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
