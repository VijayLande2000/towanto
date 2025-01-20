import 'package:flutter/cupertino.dart';
import 'package:towanto/model/CartModels/add_to_cart_model.dart';

import '../../network/networkService/BaseApiServices.dart';
import '../../network/networkService/app_url.dart';
import '../../network/networkService/network_service.dart';

class AddToCartRepository{
  final BaseApiServices _apiServices = NetworkApiService();

  Future<AddToCartModel> addToCartApi(dynamic data, BuildContext context,String SessionId) async {
    try {
      dynamic response = await _apiServices.postAddToCartApiResponse(AppUrl.addToCartUrl, data, context,SessionId);
      return AddToCartModel.fromJson(response);
    } catch (e,stactrace) {
      print("dfyusg" +stactrace.toString());
      print("dfyusg" +e.toString());
      rethrow;
    }
  }
}