import 'package:flutter/material.dart';
import 'package:towanto/model/CartModels/cart_items_list_model.dart';
import 'package:towanto/model/CartModels/delete_cart_model.dart';
import '../../network/networkService/BaseApiServices.dart';
import '../../network/networkService/app_url.dart';
import '../../network/networkService/network_service.dart';

class DeleteCartRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  // Fetch the cart items from the API
  Future<DeleteCart> deleteCartItemApi(String partnerId, String id,BuildContext context, String sessionId) async {
    try {
      // Make the API call to get the response
      dynamic response = await _apiServices.deleteCartApiResponse(
          AppUrl.deletecartItemUrl, partnerId, id,context ,sessionId
      );

      return DeleteCart.fromJson(response);
    } catch (e,stactrace) {
      print("dfyusg" +stactrace.toString());
      print("dfyusg" +e.toString());
      rethrow;
    }
  }
}