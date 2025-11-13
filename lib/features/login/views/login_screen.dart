import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vita_health/di/shared_providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  int count = 0;
  bool isProfileCreated = false;
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final senhaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    bool? temp = ref.read(sharedPreferencesProvider).getBool('isProfileCreated');
    isProfileCreated = temp??=false;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginNotifierProvider);
    final notifier = ref.watch(loginNotifierProvider.notifier);

    Future<void> timeout() async {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login bloqueado por 30 segundos')));
      await Future.delayed(Duration(seconds: 30), () {
        print('timed out');
        notifier.unlock();
        count = 0;
      },);
    }

    Future<void> login() async {
      if(state.isLocked){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login bloqueado por 30 segundos')));
        return;
      }

      count += 1;

      if(count >= 3){
        print('lockado');
        notifier.lock();
        timeout();
        return;
      }

      if (_formKey.currentState!.validate()) {
        await notifier.login(
          email: usernameController.text,
          password: senhaController.text,
        );
        if(state.errorMessage != null){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage.toString())));
        } else{
          ref.read(sharedPreferencesProvider).setBool('isProfileCreated', true);
          if(!mounted) return;
          Navigator.pushReplacementNamed(context, isProfileCreated ?  '/home' : '/profile');
        }
      }
    }



    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Login'),

                TextFormField(
                  controller: usernameController,
                  enabled: !state.isLocked,
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
                  enabled: !state.isLocked,
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

                ElevatedButton(
                  onPressed: () => login(),
                  child: state.isLoading
                      ? CircularProgressIndicator()
                      : Text("Acessar"),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/register'),
                  child: Text('Cadastre-se'),
                ),

                const SizedBox(height: 24,),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
