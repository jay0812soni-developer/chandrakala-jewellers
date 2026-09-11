import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app.dart';
import 'core/bloc/app_bloc_observer.dart';
import 'core/services/logger_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Unified logger hooked into BLoC lifecycle
  Bloc.observer = AppBlocObserver();
  AppLogger.info('Initializing ChandraKala Jewellers Flutter App...');

  runApp(const CJApp());
}
