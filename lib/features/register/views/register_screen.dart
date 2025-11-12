import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vita_health/di/shared_providers.dart';
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

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(registerNotifierProvider.notifier);
    final state = ref.watch(registerNotifierProvider);

    Future<void> register() async {
      if (senhaController.text != confirmaSenhaController.text) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('As senhas não coincidem')));
      }
      if (_formKey.currentState!.validate()) {
          final User user = User(
            email: emailController.text,
            password: senhaController.text,
            celular: celularController.text,
            usuario: usernameController.text,
            foto: '',
          );
          await notifier.register(user: user);
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, '/login');
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Dados salvos com sucesso')));
          if(state.errorMessage != null){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? "Ocorreu um erro inesperado"),
              ),
            );
          }
      }
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Cadastro de Usuário'),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const SizedBox(height: 100),
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
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'O campo é obrigatório!';
                    }
                    return null;
                  },
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
                  decoration: InputDecoration(labelText: "Confirma Senha"),
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

                const SizedBox(height: 48),

                ElevatedButton(
                  onPressed: () => register(),
                  child: state.isLoading
                      ? CircularProgressIndicator()
                      : Text('Cadastrar'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: state.isLoading
                      ? CircularProgressIndicator()
                      : Text('Cancelar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
