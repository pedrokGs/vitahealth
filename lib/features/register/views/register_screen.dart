import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vita_health/di/shared_providers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vita_health/shared/models/user.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final celularController = TextEditingController();
  final usernameController = TextEditingController();
  final senhaController = TextEditingController();
  final confirmaSenhaController = TextEditingController();

  File? userPhoto;

  Future<void> pickPhoto() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image == null) return;

    final directory = await getApplicationDocumentsDirectory();
    final String path = "${directory.path}/${DateTime.now()}.png";

    final File savedImage = await File(image.path).copy(path);

    setState(() {
      userPhoto = savedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(registerNotifierProvider.notifier);
    final state = ref.watch(registerNotifierProvider);

    Future<void> register() async {
      if (senhaController.text != confirmaSenhaController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('As senhas não coincidem')),
        );
        return;
      }

      if (_formKey.currentState!.validate()) {
        final User user = User(
          email: emailController.text,
          password: senhaController.text,
          celular: celularController.text,
          usuario: usernameController.text,
          foto: userPhoto?.path ?? '',
        );

        await notifier.register(user: user);

        if (!mounted) return;

        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cadastro realizado com sucesso')),
        );

        Navigator.pushReplacementNamed(context, '/login');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Usuário'),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [

                // FOTO DO USUÁRIO
                GestureDetector(
                  onTap: pickPhoto,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage:
                    userPhoto != null ? FileImage(userPhoto!) : null,
                    child: userPhoto == null
                        ? Icon(Icons.camera_alt, size: 40, color: Colors.white70)
                        : null,
                  ),
                ),

                const SizedBox(height: 24),

                TextFormField(
                  controller: nomeController,
                  decoration: InputDecoration(labelText: "Nome"),
                  validator: (value) {
                    RegExp regExp = RegExp(r'^\s*\S+(?:\s+\S+)+\s*$');
                    if (!regExp.hasMatch(value!)) {
                      return 'O nome precisa de no mínimo 2 palavras';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: "Email"),
                  validator: (value) {
                    RegExp regExp = RegExp(r'^[\w\-\.]+@([\w-]+\.)+[\w-]{2,}$');
                    if (!regExp.hasMatch(value!)) {
                      return 'Insira um email válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                TextFormField(
                  controller: celularController,
                  decoration: InputDecoration(labelText: "Celular"),
                  keyboardType: TextInputType.phone,
                  validator: (value) =>
                  value!.isEmpty ? 'O campo é obrigatório!' : null,
                ),
                const SizedBox(height: 24),

                TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(labelText: "Usuário"),
                  validator: (value) {
                    RegExp regExp = RegExp(
                      r'^(?=.{8,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$',
                    );
                    if (!regExp.hasMatch(value!)) {
                      return 'O usuário é inválido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                TextFormField(
                  controller: senhaController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: "Senha"),
                  validator: (value) {
                    RegExp regExp = RegExp(
                      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z0-9]{8,}$',
                    );
                    if (!regExp.hasMatch(value!)) {
                      return 'A senha não é válida';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                TextFormField(
                  controller: confirmaSenhaController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: "Confirma Senha"),
                  validator: (value) {
                    if (value != senhaController.text) {
                      return 'As senhas não coincidem';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 48),

                ElevatedButton(
                  onPressed: state.isLoading ? null : register,
                  child: state.isLoading
                      ? CircularProgressIndicator()
                      : Text('Cadastrar'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancelar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
