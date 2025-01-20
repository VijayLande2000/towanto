import 'package:flutter/cupertino.dart';
import 'package:towanto/model/CartModels/add_to_cart_model.dart';
import 'package:towanto/model/EnquireyModels/enquirey_model.dart';
import 'package:towanto/model/WhishListModels/add_whish_list_model.dart';

import '../../network/networkService/BaseApiServices.dart';
import '../../network/networkService/app_url.dart';
import '../../network/networkService/network_service.dart';

class EnquireyRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<EnquiryResponseModel> enquireyApiResponse(dynamic data, BuildContext context,String sessionId) async {
    try {
      dynamic response = await _apiServices.postEnquireyApiResponse(AppUrl.postEnquireyUrl, data, context,sessionId);
      return EnquiryResponseModel.fromJson(response);
    } catch (e,stactrace) {
      print("dfyusg" +stactrace.toString());
      print("dfyusg" +e.toString());
      rethrow;
    }
  }
}