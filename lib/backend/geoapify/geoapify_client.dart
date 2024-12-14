import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vut_itu/backend/location.dart';
import 'package:vut_itu/logger.dart';

/// Visit and signup at https://apidocs.geoapify.com/ (for free) to get an API key.
/// Put into the .env file at the root of the project like this:
/// GEOAPIFY_API_KEY=your_api_key
class GeoapifyClient {
  final String _apiKey;

  int debounceId = 0;

  GeoapifyClient(this._apiKey);

  Future<List<Location>?> getDebouncedSearchAutocompletion(String query) async {
    debounceId++;
    var localDebounceId = debounceId;

    // TODO: Cache results

    await Future.delayed(Duration(seconds: 1));
    if (localDebounceId != debounceId) {
      // Autocompletion was requested again. This request is outdated.
      return null;
    }
    debounceId = 0;

    return await getSearchAutocompletion(query);
  }

  Future<List<Location>> getSearchAutocompletion(String query) async {
    logger.i('Getting autocompletion suggestions for query: $query');

    if (query.length < 3) {
      logger.i('Query too short for autocompletion');
      return [];
    }

    final uri = Uri(
      scheme: 'https',
      host: 'api.geoapify.com',
      path: '/v1/geocode/autocomplete',
      queryParameters: {
        'text': query,
        'type': 'city', // TODO: In future allow places, addresses, etc.
        'format': 'json',
        'apiKey': _apiKey,
      },
    );
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      // TODO: Proper error handling
      throw Exception('Failed to get autocompletion suggestions');
    }

    final List<Location> suggestions = [];
    final data = jsonDecode(response.body);

    try {
      final json = data['results'] as List;
      for (var suggestionJson in json) {
        suggestions.add(Location.fromJson(suggestionJson));
      }
    } catch (e) {
      logger.e('Failed to parse autocompletion suggestions: $e\n$data');
      return [];
    }

    return suggestions;
  }
}
