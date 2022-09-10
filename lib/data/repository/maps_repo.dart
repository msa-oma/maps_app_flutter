import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/place.dart';
import '../models/place_directions.dart';
import '../models/place_suggestion.dart';
import '../webservices/places_web_services.dart';

class MapsRepository {
  final PlacesWebServices placesWebServices;
  MapsRepository(
    this.placesWebServices,
  );

//

  Future<List<PlaceSuggestion>> fetchSuggestionPlace(
      String place, String sessionToken) async {
    final suggestions =
        await placesWebServices.fetchSuggestions(place, sessionToken);

    return suggestions
        .map((suggestion) => PlaceSuggestion.fromJson(suggestion))
        .toList();
  }

//

  Future<Place> getPlaceLocation(String placeId, String sessionToken) async {
    final place = //place details
        await placesWebServices.getPlaceLocation(placeId, sessionToken);
    return Place.fromJson(place);
  }

//

  Future<PlaceDirections> getDirections(
      LatLng origin, LatLng destination) async {
    final directions = //place details
        await placesWebServices.getDirections(origin, destination);
    return PlaceDirections.fromJson(directions);
  }
}
