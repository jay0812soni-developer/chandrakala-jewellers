import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/logger_service.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    AppLogger.debug('BLOC EVENT [${bloc.runtimeType}]: $event');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    AppLogger.debug(
      'BLOC STATE [${bloc.runtimeType}]: ${change.currentState.runtimeType} -> ${change.nextState.runtimeType}',
    );
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    AppLogger.error(
      'BLOC ERROR in [${bloc.runtimeType}]',
      error,
      stackTrace,
    );
    super.onError(bloc, error, stackTrace);
  }
}
