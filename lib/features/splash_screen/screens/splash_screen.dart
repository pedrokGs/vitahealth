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
  void initState() async {
    super.initState();
    isFirstLogin = ref.watch(sharedPreferencesProvider).getBool('isFirstLogin');

    Future.delayed(Duration(seconds: isFirstLogin == null ? 6 : 3), () {
      Navigator.pushReplacementNamed(context, '/login');
    },);
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: Image.asset('logo_placeholder.png'),);
  }
}
