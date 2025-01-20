import 'package:flutter/material.dart';
import 'package:towanto/model/CartModels/cart_items_list_model.dart';
import 'package:towanto/model/CartModels/delete_cart_model.dart';
import 'package:towanto/model/WhishListModels/delete_whish_list_model.dart';
import '../../network/networkService/BaseApiServices.dart';
import '../../network/networkService/app_url.dart';
import '../../network/networkService/network_service.dart';

class DeleteWhishListRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  // Fetch the cart items from the API
  Future<DeleteWishlistResponseModel> deleteWhishListItemApi(String partnerId, String id,BuildContext context, String sessionId) async {
    try {
      // Make the API call to get the response
      dynamic response = await _apiServices.deleteWhishListApiResponse(
          AppUrl.deletewhishlistItemUrl, partnerId, id,context ,sessionId
      );
      return DeleteWishlistResponseModel.fromJson(response);
    } catch (e,stactrace) {
      print("dfyusg" +stactrace.toString());
      print("dfyusg" +e.toString());
      rethrow;
    }
  }
}