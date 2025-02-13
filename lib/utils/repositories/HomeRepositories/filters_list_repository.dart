import 'package:flutter/material.dart';
import '../../../model/HomeModels/filters_list_model.dart';
import '../../network/networkService/BaseApiServices.dart';
import '../../network/networkService/app_url.dart';
import '../../network/networkService/network_service.dart';

class FilterListRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  // Fetch the filter list from the API
  Future<FilterListApiModel?> getFilterListApi(BuildContext context,dynamic sessionId) async {
    try {
      // Make the API call to get the response
      dynamic response = await _apiServices.getFiltersListApiResponse(AppUrl.getAllFilters, context,sessionId);

      // Ensure the response contains valid data
      if (response != null && response is Map<String, dynamic>) {
        return FilterListApiModel.fromJson(response);
      }

      // Return null if no valid response
      return null;
    } catch (e, stacktrace) {
      print('Error in getFilterListApi: $e');
      print('StackTrace: $stacktrace');
      // Handle any errors and return null
      return null;
    }
  }
}
