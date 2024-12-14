part of 'search_bar_cubit.dart';

@immutable
sealed class SearchBarState {
  final SearchController controller;

  final String searchTerm;
  final List<String> searchSuggestions;

  SearchBarState(
      {required this.controller,
      this.searchTerm = '',
      this.searchSuggestions = const []});
}

final class SearchBarInitial extends SearchBarState {
  SearchBarInitial(
      {required super.controller, super.searchSuggestions = const []});
}

final class SearchBarLoaded extends SearchBarState {
  SearchBarLoaded(
      {required super.controller,
      required super.searchTerm,
      required super.searchSuggestions});
}
