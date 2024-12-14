part of 'search_bar_cubit.dart';

@immutable
sealed class SearchBarState {
  final SearchController controller;

  final String searchTerm;
  final List<Location> searchSuggestions;

  final Location? selectedLocation;

  SearchBarState({
    required this.controller,
    this.searchTerm = '',
    this.searchSuggestions = const [],
    this.selectedLocation,
  });
}

final class SearchBarInitial extends SearchBarState {
  SearchBarInitial({
    required super.controller,
    super.searchTerm,
    super.searchSuggestions = const [],
    super.selectedLocation,
  });
}

final class SearchBarLoaded extends SearchBarState {
  SearchBarLoaded({
    required super.controller,
    required super.searchTerm,
    required super.searchSuggestions,
    super.selectedLocation,
  });
}
