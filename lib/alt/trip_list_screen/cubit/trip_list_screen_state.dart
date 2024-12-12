part of 'trip_list_screen_cubit.dart';

@immutable
sealed class TripListScreenState {}

final class TripListScreenInitial extends TripListScreenState {}

final class TripListScreenAddNew extends TripListScreenState {
  final TripModel newTrip;
  final TextEditingController nameTextFieldController;

  TripListScreenAddNew(this.newTrip, this.nameTextFieldController);

  void nameChanged(String newName) {
    // Add new trip
  }

  void startDateChanged(DateTime newDate) {
    // Add new trip
  }

  void endDateChanged(DateTime newDate) {
    // Add new trip
  }

  void budgetChanged(double newBudget) {
    // Add new trip
  }
}
