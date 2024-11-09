import 'package:flutter/material.dart';

class TripViewmodel extends ChangeNotifier {
  TripViewmodel({required this.id, String? title}) : _title = title;

  final String id;

  String? _title;

  String? get title => _title;

  set title(String? newTitle) {
    if (_title != newTitle) {
      _title = newTitle;
      notifyListeners();
    }
  }
}
