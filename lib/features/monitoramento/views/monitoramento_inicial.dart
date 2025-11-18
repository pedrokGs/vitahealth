import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../../di/shared_providers.dart';
import '../../../shared/enums/activity_type.dart';

class MonitoramentoInicial extends ConsumerStatefulWidget {
  const MonitoramentoInicial({super.key});

  @override
  ConsumerState<MonitoramentoInicial> createState() =>
      _MonitoramentoInicialState();
}

class _MonitoramentoInicialState extends ConsumerState<MonitoramentoInicial> {
  final mapController = MapController();

  @override
  void initState() {
    final notifier = ref.read(monitoringProvider.notifier);
    notifier.startTracking();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(monitoringProvider);

    final ExerciseType exerciseType =
        GoRouterState.of(context).extra! as ExerciseType;

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
        leading: BackButton(onPressed: () => context.goNamed('selecionar')),
        title: Text(exerciseType.name.toUpperCase()),
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
                      shape: CircleBorder()
                    ),
                    onPressed: () {
                    context.goNamed('monitoramento/andamento', extra: exerciseType);
                }, child: Text('Iniciar')),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
