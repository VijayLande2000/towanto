import 'package:flutter/cupertino.dart';

class AppliedFilterListViewModel extends ChangeNotifier {
  Map<String, dynamic>? _filters;
  Map<String, dynamic>? get filters => _filters;

  void updateFilters(Map<String, dynamic> newFilters) {
    _filters = newFilters;
    notifyListeners(); // Notify listeners to update the UI
  }
}