import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  bool isCaminhadaEnabled = false;
  String horaCaminhada = "";
  final horaCaminhadaController = TextEditingController();
  final Map<String, bool> caminhadaDays = {
    "Dom": false,
    "Seg": false,
    "Ter": false,
    "Qua": false,
    "Qui": false,
    "Sex": false,
    "Sab": false,
  };

  bool isCorridaEnabled = false;
  String horaCorrida = "";
  final horaCorridaController = TextEditingController();
  final Map<String, bool> corridaDays = {
    "Dom": false,
    "Seg": false,
    "Ter": false,
    "Qua": false,
    "Qui": false,
    "Sex": false,
    "Sab": false,
  };

  bool isPularCordaEnabled = false;
  String horaPularCorda = "";
  final horaPularCordaController = TextEditingController();
  final Map<String, bool> pularCordaDays = {
    "Dom": false,
    "Seg": false,
    "Ter": false,
    "Qua": false,
    "Qui": false,
    "Sex": false,
    "Sab": false,
  };

  void calculateIMC() {
    final peso = double.parse(pesoController.text.trim());
    final altura = double.parse(alturaController.text.trim());

    imcFinal = peso / (altura * altura);

    if (imcFinal < 18.5) {
      faixaImc = "MAGREZA";
    } else if (imcFinal < 24.9) {
      faixaImc = "NORMAL";
    } else if (imcFinal < 29.9) {
      faixaImc = "SOBREPESO";
    } else if (imcFinal < 39.9) {
      faixaImc = "OBESIDADE";
    }
    if (imcFinal > 40.0) {
      faixaImc = "OBESIDADE GRAVE";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cadastro de perfil")),

      body: Padding(
        padding: EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            children: [
              Text(
                'Seja Bem-Vindo(a)',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              Text(
                "     Como esse é seu primeiro acesso, precisamos de mais algumas informações para continuar!",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        dataNascimento = (await showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        ))!;
                        setState(() {});
                      },
                      child: Text('Data de Nascimento'),
                    ),
                    Text(
                      '${dataNascimento.day}/${dataNascimento.month}/${dataNascimento.year}',
                    ),

                    TextFormField(
                      controller: pesoController,
                      decoration: InputDecoration(labelText: "Peso (em Kg)"),
                      onChanged: (value) {
                        setState(() {
                          calculateIMC();
                        });
                      },
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "O campo não pode ser vazio";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: alturaController,
                      decoration: InputDecoration(
                        labelText: "Altura (em metros)",
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          calculateIMC();
                        });
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "O campo não pode ser vazio";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Seu IMC é de ${imcFinal.toStringAsFixed(2)}, o que indica $faixaImc!',
              ),

              const SizedBox(height: 48),
              Text(
                'Treino Semanal',
                style: Theme.of(context).textTheme.titleLarge,
              ),

              Row(
                children: [
                  Checkbox(
                    value: isCaminhadaEnabled,
                    onChanged: (value) {
                      setState(() {
                        isCaminhadaEnabled = value!;
                      });
                    },
                  ),
                  Text('Caminhada'),
                  const SizedBox(width: 32),

                  Expanded(
                    child: TextField(
                      onTap: () async {
                        final data = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay(hour: 12, minute: 00),
                        );
                        horaCaminhadaController.text = data!.format(context);
                      },
                      controller: horaCaminhadaController,
                      enabled: isCaminhadaEnabled,
                      decoration: InputDecoration(labelText: "Horário"),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Builder(builder: (context) {
                    for(var day in caminhadaDays){
                      return Column(
                        children: [
                          Checkbox(value: value, onChanged: onChanged)
                        ],
                      );
                    },;
                  },)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
