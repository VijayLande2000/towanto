import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:towanto/model/OrdersModels/create_order_model.dart';
import 'package:towanto/model/OrdersModels/order_details_model.dart';
import 'package:towanto/utils/repositories/AddressRepositories/add_address_repository.dart';
import 'package:towanto/utils/repositories/OrdersRepositories/cancel_order_repository.dart';
import 'package:towanto/utils/repositories/OrdersRepositories/order_details_repository.dart';
import 'package:towanto/utils/repositories/ProfileRepositories/update_account_repository.dart';
import 'dart:developer' as developer;
import '../../utils/common_widgets/PreferencesHelper.dart';
import '../../utils/common_widgets/Utils.dart';
import '../../utils/repositories/AddressRepositories/edit_address_repository.dart';
import '../../utils/repositories/OrdersRepositories/create_order_repository.dart';

class CreateOrderViewModel extends ChangeNotifier {
  final _myRepo = CreateOrderRepository();
  late BuildContext context;
  bool _loading = false;
  bool get loading => _loading;

  late OrderData orderDetails;

  setLoading(bool value) {
    _loading = value;
    developer.log('Loading state changed to: $_loading', name: 'CreateOrderViewModel');
    notifyListeners();
  }

  Future<void> createOrderApi(dynamic data, BuildContext context, String sessionId) async {
    try {
      this.context = context;
      setLoading(true);
      developer.log('Starting orders details process with data: ${jsonEncode(data)}', name: 'CreateOrderViewModel');

      final value = await _myRepo.createOrderApiResponse(data, context, sessionId);

     orderDetails = value.result!.orderData!;
     developer.log('order API response received: ${value.toString()}', name: 'CreateOrderViewModel');
       } catch (e, stackTrace) {
      developer.log(
        'Error during order process',
        name: 'CreateOrderViewModel',
        error: e.toString(),
        stackTrace: stackTrace,
      );
    } finally {
      setLoading(false);
    }
  }

  // Submit method with dynamic country, state, and city validation
  Future<void> createOrder(BuildContext context, Params params
      ) async {
    setLoading(true);
    final sessionId = await PreferencesHelper.getString("session_id");
    // Construct the body as per the required format
    var body =  {
      "params":{
        "payment_amount": params.paymentAmount,
        "product_name":"Bhindi Ankur-40 500gm - Ankur (1kg)",
        "name": params.name,
        "contact": params.contact,
        "email": "ramesh.r@ahex.co.in",
        "billing_address": {
          "line1": params.billingAddress.line1,
          "line2": params.billingAddress.line2,
          "zipcode": params.billingAddress.zipcode,
          "city": params.billingAddress.city,
          "state": params.billingAddress.state,
          "country": params.billingAddress.country,
        },
        "shipping_address": {
          "line1": params.shippingAddress.line1,
          "line2": params.shippingAddress.line2,
          "zipcode": params.shippingAddress.zipcode,
          "city": params.shippingAddress.city,
          "state": params.shippingAddress.state,
          "country": params.shippingAddress.country,
        },
        "currency":params.currency
      }
    };
    try {
      await createOrderApi(jsonEncode(body), context, sessionId!);
    } finally {
      setLoading(false);
    }
  }
}
