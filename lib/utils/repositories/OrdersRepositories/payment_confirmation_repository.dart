import 'package:flutter/cupertino.dart';
import '../../../model/OrdersModels/payment_confirmation.dart';
import '../../network/networkService/BaseApiServices.dart';
import '../../network/networkService/app_url.dart';
import '../../network/networkService/network_service.dart';

class PaymentConfirmationRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<PaymentConfirmationModel> paymentConfirmationApiResponse(dynamic data, BuildContext context,String sessionId) async {
    try {
      dynamic response = await _apiServices.paymentConfirmationApiResponse(AppUrl.paymentConfirmation, data, context,sessionId);
      return PaymentConfirmationModel.fromJson(response);
    } catch (e,stactrace) {
      print("dfyusg" +stactrace.toString());
      print("dfyusg" +e.toString());
      rethrow;
    }
  }
}