import 'package:flutter_bloc/flutter_bloc.dart';

class BlocChangeObserver extends BlocObserver {
  const BlocChangeObserver();

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('${bloc.runtimeType} $change');
  }
}
