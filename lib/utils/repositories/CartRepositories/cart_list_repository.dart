import 'package:flutter/material.dart';
import 'package:towanto/model/CartModels/cart_items_list_model.dart';
import '../../network/networkService/BaseApiServices.dart';
import '../../network/networkService/app_url.dart';
import '../../network/networkService/network_service.dart';

class CartListRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  // Fetch the cart items from the API
  Future<List<CartItemsListModel>> getCartListApi(String categoryId, BuildContext context, String sessionId) async {
    try {
      // Make the API call to get the response
      dynamic response = await _apiServices.getCartListApiResponse(
          AppUrl.cartItemsListUrl, categoryId, context, sessionId
      );

      // Ensure the response contains valid data
      if (response != null) {
        // If response is a List, handle multiple cart items
        if (response is List) {
          return response.map((cartData) => CartItemsListModel(
            products: (cartData['products'] as List? ?? [])
                .map((item) => Product.fromJson(item))
                .toList(),
            totalAmount: cartData['total_amount']?.toDouble() ?? 0.0,
          )).toList();
        }
        // If response is a Map, handle single cart item
        else if (response is Map<String, dynamic>) {
          return [
            CartItemsListModel(
              products: (response['products'] as List? ?? [])
                  .map((item) => Product.fromJson(item))
                  .toList(),
              totalAmount: response['total_amount']?.toDouble() ?? 0.0,
            )
          ];
        }
      }

      // Return empty list if no valid response
      return [];
    } catch (e,stackrace) {
      print('Error in getCartListApi: $e');
      print('Error in getCartListApi: $stackrace');
      // Handle any errors and return empty list
      return [];
    }
  }
}