import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vita_health/di/shared_providers.dart';
import '../models/login_service.dart';

class LoginState{
  final String? errorMessage;
  final bool isLoading;
  final bool isLocked;

  const LoginState({this.errorMessage, this.isLoading = false, this.isLocked = false});
}

class LoginNotifier extends Notifier<LoginState>{
  late final LoginService loginService;

  @override
  LoginState build() {
    loginService = ref.read(loginServiceProvider);
    return LoginState();
  }

  Future<void> login({required String email, required String password}) async {
    if(state.isLocked){
      return;
    }

    try{
      await loginService.loginUser(email: email, password: password);
      state = LoginState(isLoading: false, errorMessage: null);
    } catch(e){
      state = LoginState(isLoading: false, errorMessage: e.toString());
    }
  }

  void lock(){
    state = LoginState(isLocked: true);
  }

  void unlock(){
    state = LoginState(isLocked: false);
  }
}