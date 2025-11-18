import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/enums/activity_type.dart';

class SelecionarExercicioScreen extends StatefulWidget {
  const SelecionarExercicioScreen({super.key});

  @override
  State<SelecionarExercicioScreen> createState() =>
      _SelecionarExercicioScreenState();
}

class _SelecionarExercicioScreenState extends State<SelecionarExercicioScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: BackButton(), title: Text("Sem Logo"), centerTitle: true,),
      body: Padding(
        padding: EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSelectButton(ExerciseType.corrida),
              _buildSelectButton(ExerciseType.caminhada),
              _buildSelectButton(ExerciseType.pularCorda),
            ],
          ),
        ),
      ),
    );
  }

  _buildSelectButton(ExerciseType type) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            switch (type) {
              case ExerciseType.corrida:
                context.goNamed('monitoramento', extra: type);

              case ExerciseType.caminhada:
                context.goNamed('monitoramento', extra: type);

              case ExerciseType.pularCorda:
                null;
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.3,
            height: MediaQuery.of(context).size.width * 0.3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: Colors.grey,
            ),
            child: Icon(switch (type) {
              ExerciseType.corrida => Icons.run_circle_outlined,

              ExerciseType.caminhada => Icons.directions_walk,

              ExerciseType.pularCorda => Icons.accessibility_new,
            }),
          ),
        ),
        Text(type.name.toUpperCase()),
      ],
    );
  }
}
