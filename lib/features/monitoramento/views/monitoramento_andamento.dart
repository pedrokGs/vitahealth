import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../di/shared_providers.dart';

class MonitoramentoAndamento extends ConsumerStatefulWidget {
  const MonitoramentoAndamento({super.key});

  @override
  ConsumerState createState() => _MonitoramentoAndamentoState();
}

class _MonitoramentoAndamentoState
    extends ConsumerState<MonitoramentoAndamento> {
  final _stopwatch = Stopwatch();
  late Timer _timer;
  String _displayTime = '00:00:00';

  bool isPaused = false;

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 30), (Timer t) {
      setState(() {
        _displayTime =
            '${_stopwatch.elapsed.inHours.toString().padLeft(2, '0')}:${(_stopwatch.elapsed.inMinutes % 60).toString().padLeft(2, '0')}:${(_stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}';
      });
    });
    _stopwatch.start();
  }

  void _finish() {
    ref.read(monitoringProvider.notifier).stopTracking();
    _stopwatch.stop();
    _timer.cancel();

    context.goNamed('monitoramento/concluido', extra: _displayTime);
  }

  void _stop() {
    _timer.cancel();
    _stopwatch.stop();
  }

  void _pause() {
    ref.read(monitoringProvider.notifier).pauseTracking();
    setState(() {
      isPaused = true;
    });

    _stopwatch.stop();
    _timer.cancel();
  }

  void _continue() {
    ref.read(monitoringProvider.notifier).resumeTracking();
    setState(() {
      isPaused = false;
    });

    _startTimer();
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(monitoringProvider);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Tempo', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Text(
              _displayTime,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 32),
            Text('Distância', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Text(
              '${state.totalDistance}',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 12),
            Text('KM', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 24),
            if (!isPaused)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  minimumSize: const Size(125, 125),
                  shape: const CircleBorder(),
                ),
                onPressed: _pause,
                child: const Text('Pausar'),
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: const Size(110, 110),
                      shape: const CircleBorder(),
                    ),
                    onPressed: _continue,
                    child: const Text('Continuar'),
                  ),
                  const SizedBox(width: 24),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: const Size(110, 110),
                      shape: const CircleBorder(),
                    ),
                    onPressed: _finish,
                    child: const Text('Concluir'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
