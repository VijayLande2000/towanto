import 'package:flutter/cupertino.dart';
import 'package:towanto/model/CartModels/update_cart_model.dart';
import '../../network/networkService/BaseApiServices.dart';
import '../../network/networkService/app_url.dart';
import '../../network/networkService/network_service.dart';

class UpdateCartRepository {
  final BaseApiServices _apiServices = NetworkApiService();
  Future<UpdateCartModel> updateCartApi(dynamic data, BuildContext context,String sessionId) async{
    try {
      dynamic response = await _apiServices.updateCartApiResponse(AppUrl.updatecartItemUrl, data, context,sessionId);
      return UpdateCartModel.fromJson(response);
    } catch (e,stactrace) {
      print("dfyusg" +stactrace.toString());
      print("dfyusg" +e.toString());

      rethrow;
    }
  }
}
