import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../../di/shared_providers.dart';
import '../models/monitoramento_record.dart';

class MonitoramentoState {
  final Position? currentPosition;
  final bool isTracking;
  final double totalDistance;

  const MonitoramentoState({
    this.currentPosition,
    this.isTracking = false,
    this.totalDistance = 0.0,
  });

  MonitoramentoState copyWith({
    Position? currentPosition,
    bool? isTracking,
    double? totalDistance,
  }) => MonitoramentoState(
    currentPosition: currentPosition ?? this.currentPosition,
    isTracking: isTracking ?? this.isTracking,
    totalDistance: totalDistance ?? this.totalDistance,
  );
}

class MonitoramentoStateNotifier extends Notifier<MonitoramentoState> {
  StreamSubscription<Position>? _subscription;

  @override
  MonitoramentoState build() {
    return const MonitoramentoState();
  }

  Future<void> startTracking() async {
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    final initial = await Geolocator.getCurrentPosition();
    state = state.copyWith(currentPosition: initial, isTracking: true);

    final stream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 1,
      )
    );

    _subscription = stream.listen((event) => _updatePosition(event),);
  }

  void _updatePosition(Position newPos){
    final prevPos = state.currentPosition;

    double addedDistance = 0.0;
    if(prevPos != null){
      addedDistance = Geolocator.distanceBetween(prevPos.latitude, prevPos.longitude, newPos.latitude, newPos.longitude);
    }

    state = state.copyWith(currentPosition: newPos, totalDistance: state.totalDistance + addedDistance);
  }

  void pauseTracking() {
    _subscription?.pause();
    state = state.copyWith(isTracking: false);
  }

  void resumeTracking() {
    _subscription?.resume();
    state = state.copyWith(isTracking: true);
  }

  void stopTracking() {
    _subscription?.cancel();
    _subscription = null;
    state = state.copyWith(isTracking: false);
  }

  Future<void> salvarMonitoramento(MonitoramentoRecord record) async {
    final service = ref.read(monitoramentoServiceProvider);

    try {
      await service.enviarMonitoramento(record);
    } catch (e) {
      print("Erro ao salvar monitoramento: $e");
    }
  }
}
