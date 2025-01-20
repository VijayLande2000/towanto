import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:towanto/utils/common_widgets/PreferencesHelper.dart';
import 'package:towanto/utils/repositories/AddressRepositories/remove_address_repository.dart';
import 'dart:developer' as developer;

class RemoveAddressViewModel extends ChangeNotifier {
  final _myRepo = RemoveAddressRepository();
  final Set<String> _loadingItems = {}; // Tracks loading state for specific items

  // Check if an item is loading
  bool isLoading(String addressId) {
    return _loadingItems.contains(addressId);
  }

  // Start loading for a specific item
  void _startLoading(String addressId) {
    _loadingItems.add(addressId);
    notifyListeners();
  }

  // Stop loading for a specific item
  void _stopLoading(String addressId) {
    _loadingItems.remove(addressId);
    notifyListeners();
  }

  Future<void> removeAddressPostApi(dynamic data, BuildContext context, String sessionId) async {
    try {
      final value = await _myRepo.removeAddressListApiResponse(data, context, sessionId);
      developer.log('Address removal API response: $value', name: 'RemoveAddressViewModel');
    } catch (e, stackTrace) {
      developer.log(
        'Error during address removal',
        name: 'RemoveAddressViewModel',
        error: e.toString(),
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> removeAddressItem(BuildContext context, String addressId) async {
    final sessionId = await PreferencesHelper.getString("session_id");
    if (sessionId == null) {
      developer.log('Session ID is null', name: 'RemoveAddressViewModel');
      return;
    }

    final body = {
      "params": {
        "address_id": int.tryParse(addressId),
      },
    };

    _startLoading(addressId); // Mark the specific item as loading
    try {
      await removeAddressPostApi(jsonEncode(body), context, sessionId);
    } catch (e) {
      developer.log('Error removing address: $e', name: 'RemoveAddressViewModel');
    } finally {
      _stopLoading(addressId); // Mark the specific item as not loading
    }
  }
}
