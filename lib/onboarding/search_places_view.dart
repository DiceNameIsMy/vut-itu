import 'package:flutter/material.dart';

class SearchPlacesView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SeachPlacesViewState();
}

class _SeachPlacesViewState extends State<SearchPlacesView> {
  static final List<String> places = [
    "Prague",
    "Berlin",
    "Paris",
    "London",
    "Tokyo"
  ];

  List<String> selectedPlaces = [];

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
                      if (!selectedPlaces.contains(p)) {
                        selectedPlaces.add(p);
                        setState(() {});
                      }
                      controller.closeView("");
                    },
                  )),
        );
      },
    );
    var selectedPlacesWidget = Column(
      children: selectedPlaces
          .map((p) => ListTile(
                title: Text(p),
                trailing: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    selectedPlaces.remove(p);
                    setState(() {});
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
