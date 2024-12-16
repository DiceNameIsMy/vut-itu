import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vut_itu/backend/geoapify/geoapify_client.dart';
import 'package:vut_itu/backend/location.dart';
import 'package:vut_itu/settings/settings_view_model.dart';

part 'search_bar_state.dart';

class SearchBarCubit extends Cubit<SearchBarState> {
  final GeoapifyClient _geoapifyClient;

  SearchBarCubit(this._geoapifyClient)
      : super(SearchBarInitial(controller: SearchController()));

  factory SearchBarCubit.fromSettings(SettingsViewModel settingsViewModel) {
    return SearchBarCubit(GeoapifyClient(settingsViewModel.geoapifyApiKey));
  }

  void searchQuerySubmitted(String query) {
    state.controller.closeView(query);

    emit(
      SearchBarLoaded(
        controller: state.controller,
        searchTerm: state.searchTerm,
        searchSuggestions: state.searchSuggestions,
      ),
    );
  }

  void locationSelected(Location selectedLocation) {
    state.controller.closeView(selectedLocation.name);

    emit(
      SearchBarLoaded(
        controller: state.controller,
        searchTerm: state.searchTerm,
        searchSuggestions: state.searchSuggestions,
        selectedLocation: selectedLocation,
      ),
    );
  }

  void locationAdded(Location selectedLocation) {
    state.controller.clear();

    // TODO: Create a trip city

    emit(
      SearchBarLoaded(
        controller: state.controller,
        searchTerm: state.searchTerm,
        searchSuggestions: state.searchSuggestions,
        selectedLocation: selectedLocation,
      ),
    );
  }

  Future<List<Location>> getSuggestions(String query) async {
    // TODO: Have 2 searches: city focused and attractions focused. Attractions focused must have a radius filter, I think.

    var suggestions =
        await _geoapifyClient.getDebouncedSearchAutocompletion(query);
    if (suggestions == null) {
      // If request was discarded, do not change state
      return [];
    }
    if (isClosed) {
      return [];
    }

    emit(
      SearchBarLoaded(
        controller: state.controller,
        searchTerm: query,
        searchSuggestions: suggestions,
      ),
    );

    return suggestions;
  }

  Future<List<Location>> getLastSuggestion(String query) async {
    var suggestions = await _geoapifyClient.getSearchAutocompletion(query);

    emit(
      SearchBarLoaded(
        controller: state.controller,
        searchTerm: query,
        searchSuggestions: suggestions,
      ),
    );

    return suggestions;
  }

  void clearQuery() {
    state.controller.clear();
  }
}
