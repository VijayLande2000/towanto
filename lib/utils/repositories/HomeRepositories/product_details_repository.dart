import 'package:flutter/material.dart';
import 'package:towanto/model/HomeModels/categories_list_details_model.dart';
import 'package:towanto/model/HomeModels/product_details_model.dart';
import 'dart:developer' as developer;

import '../../network/networkService/BaseApiServices.dart';
import '../../network/networkService/app_url.dart';
import '../../network/networkService/network_service.dart';

class ProductDetailsRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<List<ProductDetailsModel>> getProductDetailsApi(dynamic data, BuildContext context) async {
    try {
      dynamic response = await _apiServices.getProductDetailsApiResponse(
          AppUrl.getProductDetailsUrl,
          data,
          context
      );

      // Add null check and type check
      if (response != null && response is List) {
        return response
            .map((item) => ProductDetailsModel.fromJson(item))
            .toList();
      }

      // Return empty list if response is null or not a List
      return [];

    } catch (e, stackTrace) {
      developer.log(
          'Error in getProductDetailsApi',
          error: e.toString(),
          stackTrace: stackTrace
      );
      // You might want to show an error message or handle specific error cases
      rethrow;
    }
  }
}