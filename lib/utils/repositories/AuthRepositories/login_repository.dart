import 'package:flutter/cupertino.dart';
import 'package:towanto/model/AuthModels/login_model.dart';

import '../../network/networkService/BaseApiServices.dart';
import '../../network/networkService/app_url.dart';
import '../../network/networkService/network_service.dart';

class LoginRopository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<LoginModel> loginApi(dynamic data, BuildContext context) async{
    try {
      dynamic response = await _apiServices.postApiResponse(AppUrl.loginUrl, data, context);
      return LoginModel.fromJson(response);
    } catch (e,stactrace) {
      print("dfyusg" +stactrace.toString());
      print("dfyusg" +e.toString());

      rethrow;
    }
  }





  // Future<LoginUserModel> getUserDetails(
  //     String subId, String tenantName, BuildContext context) async {
  //   try {
  //     dynamic response = await _apiServices.getUserDetails(
  //         '${AppUrl.getUserDetails}/$subId', subId, tenantName, context);
  //     return LoginUserModel.fromJson(response);
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  // Future<DeviceInfoResponse> saveDeviceData(
  //     String deviceId,
  //     String tenantName,
  //     String token,
  //     DeviceRegistrationInfoDTO deviceRegistrationInfoDTO,
  //     BuildContext context) async {
  //   try {
  //     dynamic response = await _apiServices.updateDeviceInfo(
  //         '${AppUrl.updateDeviceInfo}/$deviceId',
  //         tenantName,
  //         token,
  //         deviceRegistrationInfoDTO,
  //         context);
  //     return DeviceInfoResponse.fromJson(response);
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
  //
  // Future<PostDeviceInfoResponse> savePostDeviceData(
  //     String tenantName,
  //     String domainName,
  //     String idToken,
  //     PostDeviceInfoModel deviceInfo,
  //     BuildContext context) async {
  //   try {
  //     dynamic response = await _apiServices.postDeviceInfo(
  //         AppUrl.insertDeviceInfo, tenantName, idToken, deviceInfo, context);
  //     return PostDeviceInfoResponse.fromJson(response);
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
  //
  // Future<PostDeviceInfoResponse> saveConfigdata(
  //     String domainName,
  //     String idToken,
  //     DeviceConfigModel deviceConfig,
  //     BuildContext context) async {
  //   try {
  //     dynamic response = await _apiServices.postDeviceConfigInfo(
  //         AppUrl.insertAnalytics, domainName, idToken, deviceConfig, context);
  //     return PostDeviceInfoResponse.fromJson(response);
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
}
