import 'package:flutter/cupertino.dart';
import 'package:towanto/model/AuthModels/forgot_model.dart';
import 'package:towanto/model/CartModels/add_to_cart_model.dart';
import 'package:towanto/model/WhishListModels/add_whish_list_model.dart';

import '../../network/networkService/BaseApiServices.dart';
import '../../network/networkService/app_url.dart';
import '../../network/networkService/network_service.dart';

class ForgotPassowordRepository{
  final BaseApiServices _apiServices = NetworkApiService();

  Future<ForgotModel> forgotPasswordApi(dynamic data, BuildContext context,
      {String? sessionId}) async {
    try {
      dynamic response = await _apiServices.postforgotApiResponse(AppUrl.forgotPasswordUrl, data, context,sessionId??"");
      return ForgotModel.fromJson(response);
    } catch (e,stactrace) {
      print("dfyusg" +stactrace.toString());
      print("dfyusg" +e.toString());
      rethrow;
    }
  }
}