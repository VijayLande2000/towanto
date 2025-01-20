import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:towanto/utils/repositories/WhishListRepository/whishList_list_repository.dart';

import '../../model/WhishListModels/whish_list_data.dart';

class WhishListViewModel extends ChangeNotifier {
  final _myRepo = WhishListRepository();
  late BuildContext context;
  bool _loading = false;
  List<WishlistItemModel> _responseData = []; // Private list for cart items

  bool get loading => _loading;
  List<WishlistItemModel> get whishListItemsList => _responseData; // Return cart items list


  void setLoading(bool value) {
    _loading = value;
    developer.log(
        'Loading state changed to: $_loading', name: 'Whish List ListViewModel');
    notifyListeners();
  }

  Future<void> whishListViewModelApi(String categoryId, String sessionId, BuildContext context) async {
    try {
      this.context = context;
      setLoading(true);
      developer.log('Starting whish ListViewModel process with data: ${jsonEncode(categoryId)}', name: 'whish ListViewModel');

      final value = await _myRepo.getWhishlistListApi(categoryId, context, sessionId);
      _responseData = value; // Update the list

      notifyListeners(); // Notify listeners after updating the data

      developer.log(
          'whish list view model API response received: ${_responseData.toString()}',
          name: 'whish list view model');

    } catch (e, stackTrace) {
      developer.log(
          'Error during whish list view model process',
          name: 'whish list view model',
          error: e.toString(),
          stackTrace: stackTrace);
    } finally {
      setLoading(false);
    }
  }


  Future<void> updateWhishListViewModelApi(String categoryId, String sessionId, BuildContext context) async {
    try {
      this.context = context;
      developer.log('Starting whish ListViewModel process with data: ${jsonEncode(categoryId)}', name: 'whish ListViewModel');

      final value = await _myRepo.getWhishlistListApi(categoryId, context, sessionId);
      _responseData = value; // Update the list

      notifyListeners(); // Notify listeners after updating the data

      developer.log(
          'whish list view model API response received: ${_responseData.toString()}',
          name: 'whish list view model');

    } catch (e, stackTrace) {
      developer.log(
          'Error during whish list view model process',
          name: 'whish list view model',
          error: e.toString(),
          stackTrace: stackTrace);
    } finally {
      // setLoading(false);
    }
  }

}
