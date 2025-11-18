import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../../di/shared_providers.dart';
import '../../../shared/models/user.dart';
import '../models/monitoramento_record.dart';

class MonitoramentoFinal extends ConsumerStatefulWidget {
  const MonitoramentoFinal({super.key});

  @override
  ConsumerState<MonitoramentoFinal> createState() => _MonitoramentoFinalState();
}

class _MonitoramentoFinalState extends ConsumerState<MonitoramentoFinal> {
  final MapController mapController = MapController();
  bool mapReady = false;

  @override
  void didUpdateWidget(covariant MonitoramentoFinal oldWidget) {
    super.didUpdateWidget(oldWidget);

    final state = ref.read(monitoringProvider);

    if (mapReady && state.currentPosition != null) {
      mapController.move(
        LatLng(
          state.currentPosition!.latitude,
          state.currentPosition!.longitude,
        ),
        17,
      );
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(monitoringProvider);
      final user = ref.read(loginNotifierProvider).currentUser;
      final displayTime = GoRouterState.of(context).extra! as String;

      if (user == null) return;

      final record = MonitoramentoRecord(
        userId: user.usuario,
        totalDistance: state.totalDistance,
        totalTime: displayTime,
        createdAt: DateTime.now(),
      );

      ref.read(monitoringProvider.notifier).salvarMonitoramento(record);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(monitoringProvider);
    User? user = ref.watch(loginNotifierProvider).currentUser;
    user ??= User(email: '', password: '', celular: '', usuario: '', foto: '');

    final displayTime = GoRouterState.of(context).extra! as String;

    if (state.currentPosition != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        mapController.move(
          LatLng(
            state.currentPosition!.latitude,
            state.currentPosition!.longitude,
          ),
          17,
        );
      });
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Progresso'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              onMapReady: () {
                mapController.move(
                  LatLng(
                    state.currentPosition!.latitude,
                    state.currentPosition!.longitude,
                  ),
                  17,
                );
              },
            ),
            mapController: mapController,
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.github.pedrokgs',
              ),

              if (state.currentPosition != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(
                        state.currentPosition!.latitude,
                        state.currentPosition!.longitude,
                      ),
                      child: const Icon(
                        Icons.navigation,
                        color: Colors.blue,
                        size: 40,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          Positioned(
            top: 0,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.25,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundImage: user.foto.isNotEmpty
                              ? FileImage(File(user.foto))
                              : null,
                          child: user.foto.isEmpty
                              ? Icon(Icons.person, size: 30)
                              : null,
                        ),
                        const SizedBox(width: 24),
                        Column(
                          children: [Text(user.usuario), Text(user.email)],
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text('Distância Total'),
                            Text('${state.totalDistance} km'),
                          ],
                        ),
                        Column(
                          children: [Text('Tempo total'), Text(displayTime)],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.2,
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    minimumSize: Size(125, 125),
                    maximumSize: Size(150, 150),
                    shape: CircleBorder(),
                  ),
                  onPressed: () {
                    context.goNamed('selecionar');
                  },
                  child: Text('Finalizar'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
