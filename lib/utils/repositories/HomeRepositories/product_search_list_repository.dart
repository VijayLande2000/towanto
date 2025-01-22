import 'package:flutter/cupertino.dart';
import 'package:towanto/model/Address_Models/get_Address_list_model.dart';
import 'package:towanto/model/CartModels/add_to_cart_model.dart';
import 'package:towanto/model/EnquireyModels/enquirey_model.dart';
import 'package:towanto/model/HomeModels/search_product_model.dart';
import 'package:towanto/model/ProfileDetails/update_account_information_model.dart';
import 'package:towanto/model/WhishListModels/add_whish_list_model.dart';

import '../../network/networkService/BaseApiServices.dart';
import '../../network/networkService/app_url.dart';
import '../../network/networkService/network_service.dart';

class SearchProductRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<SearchProductModel> getSearchProductListApiResponse(dynamic data, BuildContext context,String sessionId) async {
    try {
      dynamic response = await _apiServices.postProductSearchListApiResponse(AppUrl.getproductSearch, data, context,sessionId);
      return SearchProductModel.fromJson(response);
    } catch (e,stactrace) {
      print("dfyusg" +stactrace.toString());
      print("dfyusg" +e.toString());
      rethrow;
    }
  }
}