import 'package:flutter/cupertino.dart';
import 'package:towanto/model/Address_Models/add_address_model.dart';
import 'package:towanto/model/Address_Models/get_Address_list_model.dart';
import 'package:towanto/model/CartModels/add_to_cart_model.dart';
import 'package:towanto/model/EnquireyModels/enquirey_model.dart';
import 'package:towanto/model/ProfileDetails/update_account_information_model.dart';
import 'package:towanto/model/WhishListModels/add_whish_list_model.dart';

import '../../network/networkService/BaseApiServices.dart';
import '../../network/networkService/app_url.dart';
import '../../network/networkService/network_service.dart';

class AddAddressRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<AddAddressModel> addAddressListApiResponse(dynamic data, BuildContext context,String sessionId,dynamic from) async {
    try {
      dynamic response = await _apiServices.addAddressListApiResponse(AppUrl.addAddressUrl, data, context,sessionId,from);
      return AddAddressModel.fromJson(response);
    } catch (e,stactrace) {
      print("dfyusg" +stactrace.toString());
      print("dfyusg" +e.toString());
      rethrow;
    }
  }
}