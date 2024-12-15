import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vut_itu/alt/search_bar/cubit/search_bar_cubit.dart';
import 'package:vut_itu/backend/location.dart';
import 'package:vut_itu/logger.dart';
import 'package:vut_itu/settings/settings_view_model.dart';

class SearchBarView extends StatelessWidget {
  final SettingsViewModel settingsViewModel;
  final void Function(List<Location>)? onQuerySubmit;
  final void Function(Location)? onLocationSelect;
  final void Function(Location)? onLocationAdd;

  const SearchBarView(
    this.settingsViewModel, {
    super.key,
    this.onQuerySubmit,
    this.onLocationSelect,
    this.onLocationAdd,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SearchBarCubit.fromContext(context, settingsViewModel),
      child: BlocBuilder<SearchBarCubit, SearchBarState>(
        builder: (contextWithCubit, state) {
          return SearchAnchor.bar(
            searchController: state.controller,
            barLeading: Container(),
            barTrailing: [Icon(Icons.search)],
            barHintText: 'Try Prague, Big Ben...',
            barElevation: WidgetStatePropertyAll(0.0),

            onSubmitted: (value) {
              if (onQuerySubmit != null) {
                onQuerySubmit!(state.searchSuggestions);
              }
              BlocProvider.of<SearchBarCubit>(contextWithCubit)
                  .searchQuerySubmitted(value);
            },

            // viewBuilder: , // TODO: Try this builder instead of suggestionsBuilder

            suggestionsBuilder: (context, controller) async {
              logger.i('Loading suggestions for query: ${controller.text}');
              var suggestions =
                  await BlocProvider.of<SearchBarCubit>(contextWithCubit)
                      .getSuggestions(controller.text);

              return suggestions.map((suggestion) {
                return ListTile(
                  title: Text(suggestion.name),
                  onTap: () {
                    BlocProvider.of<SearchBarCubit>(contextWithCubit)
                        .locationSelected(suggestion);
                    if (onLocationSelect != null) {
                      onLocationSelect!(suggestion);
                    }
                  },
                  trailing: IconButton.outlined(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      BlocProvider.of<SearchBarCubit>(contextWithCubit)
                          .locationSelected(suggestion);
                      if (onLocationAdd != null) {
                        onLocationAdd!(suggestion);
                      }
                    },
                  ),
                );
              }).toList();
            },
          );
        },
      ),
    );
  }
}
