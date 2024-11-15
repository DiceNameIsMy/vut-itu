import 'dart:async';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:vut_itu/map/map_screen.dart';
import 'package:vut_itu/onboarding/selected_places_view_model.dart';
import 'package:vut_itu/places/places_view_model.dart';
import 'package:vut_itu/trip/place_card_view.dart';
import 'package:vut_itu/backend/place_model.dart';

class SearchPlacesView extends StatefulWidget {
  final SelectedPlacesViewModel selectedPlaces;

  SearchPlacesView(this.selectedPlaces, {super.key});

  @override
  State<SearchPlacesView> createState() => _SearchPlacesViewState();
}

class _SearchPlacesViewState extends State<SearchPlacesView> {
  late Timer? _debounce;
  final SearchViewModel placesViewModel = SearchViewModel();

  void _onSearchTermChanged(SearchController controller) {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }
    _debounce = Timer(const Duration(seconds: 2), () {
      controller.openView();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildPlaceSearchWidget(),
        SizedBox(height: 16.0),
        _buildSelectedPlacesList(context),
      ],
    );
  }

  SearchAnchor _buildPlaceSearchWidget() {
    return SearchAnchor(
      isFullScreen: false,
      builder: (BuildContext context, SearchController controller) {
        return SearchBar(
          controller: controller,
          hintText: 'City or place name',
          onTap: () => controller.openView(),
          onChanged: (String newTitle) {
            if (controller.isOpen) {
              _onSearchTermChanged(controller);
            } else {
              controller.openView();
            }
          },
          leading: const Icon(Icons.search),
          trailing: [
            IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    var centerAt = LatLng(50.0755, 14.4378);
                    var initZoomLevel = 6.0;
                    return MapScreen(
                        centerAt: centerAt, initZoomLevel: initZoomLevel);
                  }));
                },
                icon: Icon(Icons.map)),
          ],
        );
      },
      suggestionsBuilder: (context, SearchController controller) async {
        if (controller.text.isEmpty) {
          await placesViewModel.getRecommendations(3);
        } else {
          await placesViewModel.findByTitle(controller.text, 1, 10);
        }

        List<PlaceModel> suggestions = placesViewModel.foundPlaces;
        return List.from(suggestions.map((p) => PlaceCardView(p, onTap: () {
              widget.selectedPlaces.addPlace(p);
              controller.closeView('');
            })));
      },
    );
  }

  Column _buildSelectedPlacesList(BuildContext context) {
    return Column(
      children: widget.selectedPlaces.all
          .map((p) => PlaceCardView(
                p,
                trailingWidget: IconButton(
                  onPressed: () {
                    widget.selectedPlaces.removePlace(p);
                  },
                  icon: const Icon(Icons.remove_circle),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MapScreen(
                              centerAt: p.coordinates,
                            )),
                  );
                },
              ))
          .toList(),
    );
  }
}
