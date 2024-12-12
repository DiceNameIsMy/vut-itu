import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'trip_screen_state.dart';

class TripScreenCubit extends Cubit<TripScreenState> {
  TripScreenCubit() : super(TripScreenInitial());

  factory TripScreenCubit.fromContext(BuildContext context) {
    return TripScreenCubit();
  }
}
