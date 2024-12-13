import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'trip_screen_state.dart';

class TripScreenCubit extends Cubit<TripScreenState> {
  TripScreenCubit() : super(TripScreenInitial());

  factory TripScreenCubit.fromContext(BuildContext context) {
    return TripScreenCubit();
  }
}
