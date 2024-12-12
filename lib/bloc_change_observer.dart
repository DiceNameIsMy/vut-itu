import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vut_itu/logger.dart';

class BlocChangeObserver extends BlocObserver {
  const BlocChangeObserver();

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    logger.d('${bloc.runtimeType}: $change');
  }
}
