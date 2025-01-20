import 'package:flutter/material.dart';
import '../../../model/WhishListModels/whish_list_data.dart';
import '../../network/networkService/BaseApiServices.dart';
import '../../network/networkService/app_url.dart';
import '../../network/networkService/network_service.dart';

class WhishListRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  // Fetch the wishlist items from the API
  Future<List<WishlistItemModel>> getWhishlistListApi(
      String categoryId, BuildContext context, String sessionId) async {
    try {
      // Make the API call to get the response
      dynamic response = await _apiServices.getWhishListApiResponse(
          AppUrl.whishlistListItemUrl, categoryId, context, sessionId);

      // Ensure the response contains valid data
      if (response != null) {
        // If response is a List, handle multiple wishlist items
        if (response is List) {
          return response
              .map((wishlistData) => WishlistItemModel.fromJson(wishlistData))
              .toList();
        }
      }

      // Return empty list if no valid response
      return [];
    } catch (e) {
      print('Error in getWhishlistListApi: $e');
      // Handle any errors and return an empty list
      return [];
    }
  }
}
