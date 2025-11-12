import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vita_health/di/shared_providers.dart';
import 'package:vita_health/features/register/models/register_service.dart';

import '../../../shared/models/user.dart';

class RegisterState{
  final String? errorMessage;
  final bool isLoading;

  const RegisterState({this.errorMessage, this.isLoading = false});
}

class RegisterNotifier extends Notifier<RegisterState>{
  late final RegisterService registerService;

  @override
  RegisterState build() {
    registerService = ref.read(registerServiceProvider);
    return RegisterState();
  }

  Future<void> register({required User user}) async {
    state = RegisterState(isLoading: true);
    try{
      await registerService.registerUser(user: user);
      state = RegisterState(isLoading: false, errorMessage: null);
    } catch(e){
      state = RegisterState(isLoading: false, errorMessage: "$e");
    }
  }
}