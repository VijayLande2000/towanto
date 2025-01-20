import 'package:flutter/material.dart';
import 'package:towanto/model/CartModels/cart_items_list_model.dart';
import 'package:towanto/model/OrdersModels/orders_list_model.dart';
import '../../network/networkService/BaseApiServices.dart';
import '../../network/networkService/app_url.dart';
import '../../network/networkService/network_service.dart';

class OrdersListRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  // Fetch the cart items from the API
  Future<OrdersListModel> getOrdersListApi(String partnerId, BuildContext context, String sessionId) async {
    try {
      // Make the API call to get the response
      dynamic response = await _apiServices.getOrdersListApiResponse(
          AppUrl.getOrderslist, partnerId, context, sessionId
      );
      return OrdersListModel.fromJson(response);
    } catch (e) {
      print('Error in getOrdersListApi: $e');
      rethrow;
    }
  }
}