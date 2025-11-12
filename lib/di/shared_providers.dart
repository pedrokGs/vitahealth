import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vita_health/features/register/models/register_service.dart';
import 'package:vita_health/features/register/viewmodels/register_state.dart';

final String baseUrl = 'http://10.0.2.2:3000';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) => throw UnimplementedError(),); // override na main

final registerServiceProvider = Provider<RegisterService>((ref) => RegisterServiceImpl(baseUrl: baseUrl));
final registerNotifierProvider = NotifierProvider(() => RegisterNotifier(),);