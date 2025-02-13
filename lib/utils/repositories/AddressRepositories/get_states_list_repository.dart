// get_all_states_repository.dart
import 'package:flutter/cupertino.dart';

import '../../../model/Address_Models/get_all_states_model.dart';
import '../../network/networkService/BaseApiServices.dart';
import '../../network/networkService/app_url.dart';
import '../../network/networkService/network_service.dart';

class GetAllStatesRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<GetAllStatesResponse> getAllStatesListApiResponse(
      dynamic countryId,
      BuildContext context,
      {String? sessionId}) async {
    try {
      dynamic response = await _apiServices.getAllStatesDetailsApiResponse(
          AppUrl.getAllStates,
          countryId,
          context,
          sessionId??""
      );
      // The response is a List, so pass it directly to FromJson
      return GetAllStatesResponse.fromJson(response);
    } catch (e, stacktrace) {
      print("Error: ${e.toString()}");
      print("Stacktrace: ${stacktrace.toString()}");
      rethrow;
    }
  }
}
