import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vut_itu/logger.dart';

class GeoapifyClient {
  final String _apiKey;

  int debounceId = 0;

  GeoapifyClient(this._apiKey);

  Future<List<String>> getDebouncedSearchAutocompletion(String query) async {
    debounceId++;
    var localDebounceId = debounceId;

    await Future.delayed(Duration(seconds: 1));
    if (localDebounceId != debounceId) {
      // Autocompletion was requested again. This request is outdated.
      return [];
    }
    debounceId = 0;

    return await getSearchAutocompletion(query);
  }

  Future<List<String>> getSearchAutocompletion(String query) async {
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
        'format': 'json',
        'apiKey': _apiKey,
      },
    );
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      // TODO: Proper error handling
      throw Exception('Failed to get autocompletion suggestions');
    }

    final List<String> suggestions = [];
    final data = jsonDecode(response.body);

    try {
      final results = data['results'] as List;
      for (var suggestion in results) {
        suggestions.add(suggestion['formatted'] as String);
      }
    } catch (e) {
      logger.e('Failed to parse autocompletion suggestions: $e\n$data');
      return [];
    }

    return suggestions;
  }
}
