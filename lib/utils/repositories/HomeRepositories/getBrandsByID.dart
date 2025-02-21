import 'package:flutter/cupertino.dart';

import '../../../model/HomeModels/getBrandsByIDModel.dart';
import '../../network/networkService/BaseApiServices.dart';
import '../../network/networkService/app_url.dart';
import '../../network/networkService/network_service.dart';

class GetBrandsByIDRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<GetBrandsByIdModel> getBrandsListData(int id, BuildContext context,String sessionId) async {
    try {
      dynamic response = await _apiServices.getBrandsByIDApiResponse(AppUrl.getBrandsByiD, id, context,sessionId);
      return GetBrandsByIdModel.fromJson(response);
    } catch (e, stactrace) {
      print("dfyusg" + stactrace.toString());
      print("dfyusg" + e.toString());
      rethrow;
    }
  }
}