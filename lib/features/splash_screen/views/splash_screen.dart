import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vita_health/di/shared_providers.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool? isFirstLogin = true;

  @override
  void initState() {
    super.initState();
    final prefs = ref.read(sharedPreferencesProvider);
    isFirstLogin = prefs.getBool('isFirstLogin') ?? true;
    prefs.setBool('isFirstLogin', false);

    manageSplashScreen(isFirstLogin!);
  }

  void manageSplashScreen(bool isFirstLogin) async{
    Future.delayed(Duration(seconds: isFirstLogin ? 6 : 3), () {
      if(!mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
    },);
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: Image.asset('assets/images/logo_placeholder.png'),);
  }
}
