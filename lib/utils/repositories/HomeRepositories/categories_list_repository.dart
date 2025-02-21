import 'package:flutter/material.dart';
import 'package:towanto/model/HomeModels/categories_list_details_model.dart';

import '../../network/networkService/BaseApiServices.dart';
import '../../network/networkService/app_url.dart';
import '../../network/networkService/network_service.dart';

class CategoriesListRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<CategoriesListDetailsModel> getCategoryListApi(dynamic data, BuildContext context,dynamic sessionId) async {
    try {
      dynamic response = await _apiServices.getCategoriesListApiResponse(
          AppUrl.getCatogiresListUrl, data, context,sessionId);
      // Assuming response is a List
      return CategoriesListDetailsModel.fromJson(response);

      // return CategoriesListDetailsModel.fromJson(response);
    } catch (e, stactrace) {
      print("dfyusg" + stactrace.toString());
      print("dfyusg" + e.toString());

      rethrow;
    }
  }


  Future<CategoriesListDetailsModel> getFilterCategoryListApi(dynamic data, BuildContext context,dynamic sessionId) async {
    try {
      dynamic response = await _apiServices.postFilterProductsApiResponse(
          AppUrl.getFilterProducts, data, context,sessionId);
      // Assuming response is a List
      return CategoriesListDetailsModel.fromJson(response);

      // return CategoriesListDetailsModel.fromJson(response);
    } catch (e, stactrace) {
      print("dfyusg" + stactrace.toString());
      print("dfyusg" + e.toString());

      rethrow;
    }
  }
}