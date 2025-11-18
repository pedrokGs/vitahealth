
import 'package:go_router/go_router.dart';
import 'package:vita_health/features/monitoramento/views/monitoramento_andamento.dart';
import 'package:vita_health/features/monitoramento/views/monitoramento_final.dart';
import 'package:vita_health/features/monitoramento/views/monitoramento_inicial.dart';
import 'package:vita_health/features/register/views/register_screen.dart';

import '../features/home/views/home_screen.dart';
import '../features/login/views/login_screen.dart';
import '../features/profile/views/profile_screen.dart';
import '../features/selecao/views/selecionar_exercicio_screen.dart';
import '../features/splash_screen/views/splash_screen.dart';

final router = GoRouter(
  initialLocation: "/splash",
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => SplashScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => RegisterScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => ProfileScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: '/selecionarExercicios',
      name: 'selecionar',
      builder: (context, state) => SelecionarExercicioScreen(),
    ),
    GoRoute(
      path: '/monitorarExercicio',
      name: 'monitoramento',
      builder: (context, state) => MonitoramentoInicial(),
      routes: [
        GoRoute(
          path: '/monitoramentoEmAndamento',
          name: 'monitoramento/andamento',
          builder: (context, state) => MonitoramentoAndamento(),
        ),
        GoRoute(
          path: '/monitoramentoConcluido',
          name: 'monitoramento/concluido',
          builder: (context, state) => MonitoramentoFinal(),
        ),
      ],
    ),
  ],
);
