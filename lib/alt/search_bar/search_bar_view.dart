import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vut_itu/alt/search_bar/cubit/search_bar_cubit.dart';
import 'package:vut_itu/logger.dart';
import 'package:vut_itu/settings/settings_view_model.dart';

class SearchBarView extends StatelessWidget {
  final SettingsViewModel settingsViewModel;

  const SearchBarView(this.settingsViewModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SearchBarCubit.fromContext(context, settingsViewModel),
      child: BlocBuilder<SearchBarCubit, SearchBarState>(
        builder: (contextWithCubit, state) {
          return SearchAnchor(
            isFullScreen: false,
            searchController: state.controller,
            builder: (context, controller) {
              return SearchBar(
                controller: controller,
                leading: Icon(Icons.search),
                hintText: 'Search for a place',
                onTap: () => controller.openView(),
              );
            },
            suggestionsBuilder: (context, SearchController controller) async {
              logger.i('Loading suggestions for query: ${controller.text}');
              var suggestions =
                  await BlocProvider.of<SearchBarCubit>(contextWithCubit)
                      .getSuggestions(controller.text);

              return suggestions.map((suggestion) {
                return ListTile(
                  title: Text(suggestion),
                  onTap: () {
                    controller.closeView(suggestion);
                  },
                );
              }).toList();
            },
          );
        },
      ),
    );
  }
}
