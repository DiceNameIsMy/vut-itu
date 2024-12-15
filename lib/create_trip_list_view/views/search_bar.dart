import 'package:vut_itu/create_trip_list_view/cubit/search_bar_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vut_itu/backend/business_logic/city_model.dart';
import 'package:vut_itu/backend/business_logic/attraction_model.dart';

class SearchBarWithSuggestions<T> extends StatefulWidget {
  final String hintText;
  final String searchType; // E.g., "city" or "attraction"
  final ValueChanged<T> onSuggestionSelected;
  final int? cityId;

  const SearchBarWithSuggestions(
      {Key? key,
      required this.hintText,
      required this.searchType,
      required this.onSuggestionSelected,
      required this.cityId})
      : super(key: key);

  @override
  _SearchBarWithSuggestionsState<T> createState() =>
      _SearchBarWithSuggestionsState<T>();
}

class _SearchBarWithSuggestionsState<T>
    extends State<SearchBarWithSuggestions<T>> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<SearchCubit<T>>()
          .fetchAndShowAll(type: widget.searchType, cityId: widget.cityId);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search TextField
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            labelText: widget.hintText,
            border: OutlineInputBorder(),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      _searchController.clear();
                      context.read<SearchCubit<T>>().filter('');
                    },
                  )
                : Icon(Icons.search),
          ),
          onChanged: (query) {
            context.read<SearchCubit<T>>().filter(query);
          },
        ),
        const SizedBox(height: 8),

        // Suggestions List
        BlocBuilder<SearchCubit<T>, SearchState>(
          builder: (context, state) {
            if (state is SearchLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is SearchResults<T>) {
              final results = state.results;
              if (results.isEmpty) {
                return Center(child: Text('No ${widget.searchType}s found'));
              }

              return ListView.builder(
                shrinkWrap: true,
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final item = results[index];
                  return ListTile(
                    title: Text(
                      widget.searchType == "city"
                          ? (item as CityModel).name
                          : (item as AttractionModel).name,
                    ),
                    onTap: () => widget.onSuggestionSelected(item),
                  );
                },
              );
            } else if (state is SearchError) {
              return Center(child: Text(state.message));
            }

            return Container(); // Default empty state
          },
        ),
      ],
    );
  }
}
