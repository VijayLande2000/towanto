import 'package:flutter/material.dart';
import 'package:towanto/model/HomeModels/categories_list_details_model.dart';

import '../../network/networkService/BaseApiServices.dart';
import '../../network/networkService/app_url.dart';
import '../../network/networkService/network_service.dart';

class CategoriesListRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<List<CategoriesListDetailsModel>> getCategoryListApi(dynamic data, BuildContext context) async {
    try {
      dynamic response = await _apiServices.getCategoriesListApiResponse(
          AppUrl.getCatogiresListUrl, data, context);
      // Assuming response is a List
      return (response as List)
          .map((item) => CategoriesListDetailsModel.fromJson(item))
          .toList();
      // return CategoriesListDetailsModel.fromJson(response);
    } catch (e, stactrace) {
      print("dfyusg" + stactrace.toString());
      print("dfyusg" + e.toString());

      rethrow;
    }
  }
}