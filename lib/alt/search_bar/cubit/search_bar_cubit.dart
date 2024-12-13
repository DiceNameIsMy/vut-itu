import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vut_itu/alt/geoapify/geoapify_client.dart';
import 'package:vut_itu/settings/settings_view_model.dart';

part 'search_bar_state.dart';

class SearchBarCubit extends Cubit<SearchBarState> {
  final GeoapifyClient _geoapifyClient;

  SearchBarCubit(this._geoapifyClient)
      : super(SearchBarInitial(controller: SearchController()));

  factory SearchBarCubit.fromContext(
      BuildContext context, SettingsViewModel settingsViewModel) {
    return SearchBarCubit(GeoapifyClient(settingsViewModel.geoapifyApiKey));
  }

  Future<List<String>> loadSuggestions(String query) async {
    var suggestions =
        await _geoapifyClient.getDebouncedSearchAutocompletion(query);
    return suggestions;
  }
}
