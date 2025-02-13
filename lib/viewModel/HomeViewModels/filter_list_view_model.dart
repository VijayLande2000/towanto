import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:towanto/model/HomeModels/filters_list_model.dart';
import 'package:towanto/utils/common_widgets/PreferencesHelper.dart';
import 'dart:developer' as developer;

import '../../utils/repositories/HomeRepositories/filters_list_repository.dart';

class FilterListViewModel extends ChangeNotifier {
  final FilterListRepository filterRepo = FilterListRepository();

  bool _loading = false;
  FilterListApiModel? _filterList;

  // Add state management for selections
  Map<String, Set<String>> selectedFilters = {};
  RangeValues? selectedPriceRange;

  bool get loading => _loading;
  FilterListApiModel? get filterList => _filterList;

  void setLoading(bool value) {
    _loading = value;
    developer.log('Loading state changed to: $_loading', name: 'FilterListViewModel');
    notifyListeners();
  }

  // Update selected filters
  void updateSelectedFilters(Map<String, Set<String>> filters, RangeValues? priceRange) {
    selectedFilters = filters;
    selectedPriceRange = priceRange;
    notifyListeners();
  }

  // Clear selections
  void clearSelections() {
    selectedFilters.clear();
    selectedPriceRange = null;
    notifyListeners();
  }


  Future<void> getFilterListPostApi(BuildContext context, String sessionId) async {
    try {
      setLoading(true);
      _filterList = null;
      developer.log('Fetching filter list with session ID: $sessionId', name: 'FilterListViewModel');

      final value = await filterRepo.getFilterListApi(context, sessionId);
      if (value != null) {
        _filterList = value;
        // Initialize price range if not set
        if (selectedPriceRange == null && value.priceRange != null) {
          selectedPriceRange = RangeValues(
            value.priceRange!.minPrice.toDouble(),
            value.priceRange!.maxPrice.toDouble(),
          );
        }
        developer.log('Filter API response received: ${jsonEncode(value)}', name: 'FilterListViewModel');
      } else {
        developer.log('No filters received', name: 'FilterListViewModel');
      }
    } catch (e, stackTrace) {
      developer.log('Error fetching filters', name: 'FilterListViewModel', error: e.toString(), stackTrace: stackTrace);
    } finally {
      setLoading(false);
    }
  }

  Future<void> getFilterList(BuildContext context) async {
    final sessionId = await PreferencesHelper.getString("session_id");
    if (sessionId != null) {
      await getFilterListPostApi(context, sessionId);
    } else {
      developer.log('Session ID is null', name: 'FilterListViewModel');
    }
  }

}