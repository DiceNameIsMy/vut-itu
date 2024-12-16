part of 'trip_list_screen_cubit.dart';

@immutable
sealed class TripListScreenState {
  final Map<int, TextEditingController> titleControllers;

  TripListScreenState({required this.titleControllers});
}

final class TripListScreenInitial extends TripListScreenState {
  TripListScreenInitial({required super.titleControllers});
}
