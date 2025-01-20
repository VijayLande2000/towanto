import 'package:flutter/material.dart';
import 'package:towanto/model/HomeModels/categories_list_details_model.dart';
import 'package:towanto/model/HomeModels/home_page_model.dart';

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
}