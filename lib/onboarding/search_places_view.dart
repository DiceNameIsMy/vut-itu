import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';
import 'package:vut_itu/onboarding/selected_places_view_model.dart';
import 'package:vut_itu/trip/place_card_view.dart';
import 'package:vut_itu/trip/place_model.dart';

class SearchPlacesView extends StatelessWidget {
  final SelectedPlacesViewModel selectedPlaces;

  const SearchPlacesView(this.selectedPlaces, {super.key});

  static final List<PlaceModel> _places = [
    PlaceModel(
      id: Uuid().v7(),
      title: "Prague",
      description: "The capital city of the Czech Republic.",
      coordinates: LatLng(50.0755, 14.4378),
      imageUrl: "https://example.com/prague.jpg",
    ),
    PlaceModel(
      id: Uuid().v7(),
      title: "Berlin",
      description: "The capital city of Germany.",
      coordinates: LatLng(52.5200, 13.4050),
      imageUrl: "https://example.com/berlin.jpg",
    ),
    PlaceModel(
      id: Uuid().v7(),
      title: "Paris",
      description: "The capital city of France.",
      coordinates: LatLng(48.8566, 2.3522),
      imageUrl: "https://example.com/paris.jpg",
    ),
    PlaceModel(
      id: Uuid().v7(),
      title: "London",
      description: "The capital city of the United Kingdom.",
      coordinates: LatLng(51.5074, -0.1278),
      imageUrl: "https://example.com/london.jpg",
    ),
    PlaceModel(
      id: Uuid().v7(),
      title: "Tokyo",
      description: "The capital city of Japan.",
      coordinates: LatLng(35.6895, 139.6917),
      imageUrl: "https://example.com/tokyo.jpg",
    ),
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
        List<PlaceModel> suggestions;
        if (controller.text.isEmpty) {
          suggestions = _places.take(3).toList(); // TODO: Take recommendations
        } else {
          suggestions = _places
              .where((p) =>
                  p.title.toLowerCase().contains(controller.text.toLowerCase()))
              .take(10)
              .toList();
        }

        return List.from(suggestions.map((p) => PlaceCardView(p, onTap: () {
              selectedPlaces.addPlace(p);
              controller.closeView("");
            })));
      },
    );

    var selectedPlacesWidget = Column(
      children: selectedPlaces.all
          .map((p) => PlaceCardView(
                p,
                trailingWidget: IconButton(
                    onPressed: () {
                      selectedPlaces.removePlace(p);
                    },
                    icon: const Icon(Icons.remove_circle)),
                onTap: () {}, // TODO: Open map with place
              ))
          .toList(),
    );

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          search,
          SizedBox(height: 16.0),
          selectedPlacesWidget,
        ],
      ),
    );
  }
}
