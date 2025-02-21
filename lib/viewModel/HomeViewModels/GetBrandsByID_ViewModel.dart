import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../../model/HomeModels/getBrandsByIDModel.dart';
import '../../utils/common_widgets/PreferencesHelper.dart';
import '../../utils/repositories/HomeRepositories/getBrandsByID.dart';
import 'dart:developer' as developer;

import '../../utils/repositories/HomeRepositories/getBrandsByID.dart';
import '../../utils/repositories/HomeRepositories/getBrandsByID.dart';

class GetBrandsByIDViewModel extends ChangeNotifier {
  final _myRepo = GetBrandsByIDRepository();
  late BuildContext context;
  bool _getBrandsloading = false;
  GetBrandsByIdModel? responseData;

  bool get getBrandsLoading => _getBrandsloading;

  void setBrandsLoading(bool value) {
    _getBrandsloading = value;
    developer.log('Loading state changed to: $_getBrandsloading', name: 'GetBrandsByIDViewModel');
    notifyListeners();
  }

  Future<void> getBrandsbyIDViewModelApi(int id, BuildContext context) async {
    this.context = context;

    try {
      final sessionId = await PreferencesHelper.getString("session_id");

      if (sessionId == null) {
        throw Exception("Session ID is null");
      }

      setBrandsLoading(true);

      developer.log('Starting API call with ID: $id', name: 'GetBrandsByIDViewModel');

      responseData = await _myRepo.getBrandsListData(id, context, sessionId);

      developer.log('API response: ${responseData.toString()}', name: 'GetBrandsByIDViewModel');

      notifyListeners(); // Notify listeners after updating responseData
    } catch (e, stackTrace) {
      developer.log(
        'Error in GetBrandsByIDViewModel API',
        name: 'GetBrandsByIDViewModel',
        error: e,
        stackTrace: stackTrace,
      );
    } finally {
      setBrandsLoading(false);
    }
  }
}