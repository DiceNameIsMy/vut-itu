import 'package:flutter/material.dart';
import 'package:vut_itu/onboarding/selected_places_view_model.dart';

class SearchPlacesView extends StatelessWidget {
  final SelectedPlacesViewModel selectedPlaces;

  const SearchPlacesView(this.selectedPlaces, {super.key});

  static final List<String> places = [
    "Prague",
    "Berlin",
    "Paris",
    "London",
    "Tokyo"
  ];

  @override
  Widget build(BuildContext context) {
    var search = SearchAnchor(
      isFullScreen: false,
      builder: (BuildContext context, SearchController controller) {
        return SearchBar(
          controller: controller,
          onTap: () => controller.openView(),
          onChanged: (_) => controller.openView(),
          leading: const Icon(Icons.search),
        );
      },
      suggestionsBuilder: (context, controller) {
        if (controller.text.isEmpty) {
          return List.empty();
        }
        return List.from(
          places
              .where((p) =>
                  p.toLowerCase().contains(controller.text.toLowerCase()))
              .map((p) => ListTile(
                    title: Text(p),
                    onTap: () {
                      selectedPlaces.addPlace(p);
                      controller.closeView("");
                    },
                  )),
        );
      },
    );

    var selectedPlacesWidget = Column(
      children: selectedPlaces.all
          .map((p) => ListTile(
                title: Text(p),
                trailing: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    selectedPlaces.removePlace(p);
                  },
                ),
              ))
          .toList(),
    );

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [search, SizedBox(height: 16.0), selectedPlacesWidget],
      ),
    );
  }
}
