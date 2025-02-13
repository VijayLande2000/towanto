import 'package:flutter/cupertino.dart';
import 'package:towanto/model/Address_Models/get_Address_list_model.dart';
import 'package:towanto/model/Address_Models/get_all_countrys_model.dart';
import 'package:towanto/model/CartModels/add_to_cart_model.dart';
import 'package:towanto/model/EnquireyModels/enquirey_model.dart';
import 'package:towanto/model/ProfileDetails/update_account_information_model.dart';
import 'package:towanto/model/WhishListModels/add_whish_list_model.dart';

import '../../network/networkService/BaseApiServices.dart';
import '../../network/networkService/app_url.dart';
import '../../network/networkService/network_service.dart';

class GetCountriesRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<GetAllCountriesResponse> getCountriesListApiResponse(BuildContext context,
      {String? sessionId}) async {
    try {
      dynamic response = await _apiServices.getAllCountriesApiResponse(AppUrl.getAllCountries, context, sessionId??"");
      // The response is a List, so we can directly pass it to fromJson
      return GetAllCountriesResponse.fromJson(response);
    } catch (e, stacktrace) {
      print("Error: ${e.toString()}");
      print("Stacktrace: ${stacktrace.toString()}");
      rethrow;
    }
  }
}