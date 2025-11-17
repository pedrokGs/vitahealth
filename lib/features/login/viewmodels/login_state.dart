import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vita_health/di/shared_providers.dart';
import 'package:vita_health/shared/models/user.dart';
import '../models/login_service.dart';

class LoginState{
  final String? errorMessage;
  final bool isLoading;
  final bool isLocked;
  final User? currentUser;

  const LoginState({this.errorMessage, this.isLoading = false, this.isLocked = false, this.currentUser});
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
      final user = await loginService.loginUser(email: email, password: password);
      if(user == null) return;
      state = LoginState(isLoading: false, errorMessage: null, currentUser: user);
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