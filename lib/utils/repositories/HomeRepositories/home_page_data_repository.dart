import 'package:flutter/material.dart';
import 'package:towanto/model/HomeModels/categories_list_details_model.dart';
import 'package:towanto/model/HomeModels/home_page_model.dart';

import '../../../model/HomeModels/get_all_brands_model.dart';
import '../../network/networkService/BaseApiServices.dart';
import '../../network/networkService/app_url.dart';
import '../../network/networkService/network_service.dart';

class HomePageDataRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<HomeDataModel> getHomePagedataApi(String categoryIds, BuildContext context) async {
    try {
      dynamic response = await _apiServices.getHomePageDataApiResponse(AppUrl.getHomePagedataurl, categoryIds, context);
      return HomeDataModel.fromJson(response);
    } catch (e, stactrace) {
      print("dfyusg" + stactrace.toString());
      print("dfyusg" + e.toString());

      rethrow;
    }
  }
  Future<GetAllBrandsModel?> getAllBrandsListApi(BuildContext context, dynamic sessionId) async {
    try {
      // Make the API call to get the response
      dynamic response = await _apiServices.getAllBrandsListApiResponse(AppUrl.getAllBrands, context, sessionId);

      // Ensure the response contains valid data
      if (response != null && response is Map<String, dynamic>) {
        return GetAllBrandsModel.fromJson(response);
      }

      // Return null if no valid response
      return null;
    } catch (e, stacktrace) {
      print('Error in getAllBrandsListApi: $e');
      print('StackTrace: $stacktrace');
      return null;
    }
  }


}