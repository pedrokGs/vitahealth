import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vita_health/di/shared_providers.dart';
import 'package:vita_health/features/home/views/home_screen.dart';

import '../../../shared/models/user.dart';
import '../model/profile_model.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final pesoController = TextEditingController();
  final alturaController = TextEditingController();

  DateTime dataNascimento = DateTime.now();
  double imcFinal = 0;
  String faixaImc = '';

  // Caminhada
  bool isCaminhadaEnabled = false;
  final horaCaminhadaController = TextEditingController();
  Map<String, bool> caminhadaDays = {
    "Dom": false,
    "Seg": false,
    "Ter": false,
    "Qua": false,
    "Qui": false,
    "Sex": false,
    "Sab": false,
  };

  // Corrida
  bool isCorridaEnabled = false;
  final horaCorridaController = TextEditingController();
  Map<String, bool> corridaDays = {
    "Dom": false,
    "Seg": false,
    "Ter": false,
    "Qua": false,
    "Qui": false,
    "Sex": false,
    "Sab": false,
  };

  // Pular Corda
  bool isPularCordaEnabled = false;
  final horaPularCordaController = TextEditingController();
  Map<String, bool> pularCordaDays = {
    "Dom": false,
    "Seg": false,
    "Ter": false,
    "Qua": false,
    "Qui": false,
    "Sex": false,
    "Sab": false,
  };

  void calculateIMC() {
    final peso = double.tryParse(pesoController.text.trim()) ?? 0;
    final altura = double.tryParse(alturaController.text.trim()) ?? 0;

    if (peso > 0 && altura > 0) {
      imcFinal = peso / (altura * altura);

      if (imcFinal < 18.5)
        faixaImc = "MAGREZA";
      else if (imcFinal < 24.9)
        faixaImc = "NORMAL";
      else if (imcFinal < 29.9)
        faixaImc = "SOBREPESO";
      else if (imcFinal < 39.9)
        faixaImc = "OBESIDADE";
      else
        faixaImc = "OBESIDADE GRAVE";
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileNotifierProvider);
    final notifier = ref.read(profileNotifierProvider.notifier);

    User? user = ref.watch(loginNotifierProvider).currentUser;
    user ??= User(email: '', password: '', celular: '', usuario: '', foto: '');

    return Scaffold(
      appBar: AppBar(title: Text("Cadastro de perfil")),

      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Seja Bem-Vindo(a)',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),

              Text(
                "Como esse é seu primeiro acesso, precisamos de mais algumas informações para continuar!",
                style: Theme.of(context).textTheme.bodyLarge,
              ),

              const SizedBox(height: 24),

              // FORM
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final selected = await showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (selected != null) {
                          setState(() => dataNascimento = selected);
                        }
                      },
                      child: Text('Data de Nascimento'),
                    ),

                    Text(
                      "${dataNascimento.day}/${dataNascimento.month}/${dataNascimento.year}",
                    ),

                    TextFormField(
                      controller: pesoController,
                      decoration: InputDecoration(labelText: "Peso (Kg)"),
                      keyboardType: TextInputType.number,
                      onChanged: (_) => setState(() => calculateIMC()),
                    ),

                    const SizedBox(height: 24),

                    TextFormField(
                      controller: alturaController,
                      decoration: InputDecoration(labelText: "Altura (m)"),
                      keyboardType: TextInputType.number,
                      onChanged: (_) => setState(() => calculateIMC()),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'Seu IMC é ${imcFinal.toStringAsFixed(2)} — $faixaImc',
                style: Theme.of(context).textTheme.titleMedium,
              ),

              const SizedBox(height: 48),

              Text(
                "Treino Semanal",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),

              // CAMINHADA
              ExerciseSelector(
                title: "Caminhada",
                isEnabled: isCaminhadaEnabled,
                onToggle: (v) => setState(() => isCaminhadaEnabled = v),
                hourController: horaCaminhadaController,
                daysMap: caminhadaDays,
                onDayChanged: () => setState(() {}),
              ),

              const SizedBox(height: 24),

              // CORRIDA
              ExerciseSelector(
                title: "Corrida",
                isEnabled: isCorridaEnabled,
                onToggle: (v) => setState(() => isCorridaEnabled = v),
                hourController: horaCorridaController,
                daysMap: corridaDays,
                onDayChanged: () => setState(() {}),
              ),

              const SizedBox(height: 24),

              // PULAR CORDA
              ExerciseSelector(
                title: "Pular Corda",
                isEnabled: isPularCordaEnabled,
                onToggle: (v) => setState(() => isPularCordaEnabled = v),
                hourController: horaPularCordaController,
                daysMap: pularCordaDays,
                onDayChanged: () => setState(() {}),
              ),

              const SizedBox(height: 24),

              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    final hoje = DateTime.now();
                    int idade = hoje.year - dataNascimento.year;

                    if (hoje.month < dataNascimento.month ||
                        (hoje.month == dataNascimento.month &&
                            hoje.day < dataNascimento.day)) {
                      idade--;
                    }

                    if (idade < 18) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Cadastro permitido somente para maiores de 18 anos.",
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    Profile p = Profile(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      dataNascimento: dataNascimento,
                      peso: double.parse(pesoController.text),
                      altura: double.parse(alturaController.text),
                      imc: imcFinal,
                      faixaImc: faixaImc,
                      caminhadaDays: caminhadaDays,
                      horaCaminhada: horaCaminhadaController.text,
                      corridaDays: corridaDays,
                      horaCorrida: horaCorridaController.text,
                      pularCordaDays: pularCordaDays,
                      horaPularCorda: horaPularCordaController.text,
                      userEmail: user!.email,
                      nome: user.usuario,
                    );

                    await notifier.saveProfile(p);

                    if (state.saved) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Perfil salvo com sucesso!")),
                      );
                    }
                    context.go('/home');
                  },
                  child: state.isLoading
                      ? CircularProgressIndicator()
                      : Text("Salvar"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExerciseSelector extends StatelessWidget {
  final String title;
  final bool isEnabled;
  final Function(bool) onToggle;
  final TextEditingController hourController;
  final Map<String, bool> daysMap;
  final VoidCallback onDayChanged;

  ExerciseSelector({
    required this.title,
    required this.isEnabled,
    required this.onToggle,
    required this.hourController,
    required this.daysMap,
    required this.onDayChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Checkbox(value: isEnabled, onChanged: (v) => onToggle(v!)),
            Text(title),
            const SizedBox(width: 32),

            Expanded(
              child: TextField(
                enabled: isEnabled,
                controller: hourController,
                readOnly: true,
                decoration: const InputDecoration(labelText: "Horário"),
                onTap: () async {
                  final t = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(hour: 12, minute: 0),
                  );
                  if (t != null) hourController.text = t.format(context);
                },
              ),
            ),
          ],
        ),

        if (isEnabled)
          Column(
            children: [
              const SizedBox(height: 12),

              Row(
                children: daysMap.keys.map((dia) {
                  return Expanded(
                    child: Column(
                      children: [
                        Checkbox(
                          value: daysMap[dia]!,
                          onChanged: (v) {
                            daysMap[dia] = v!;
                            onDayChanged();
                          },
                        ),
                        Text(dia),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
      ],
    );
  }
}
