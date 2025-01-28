import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:towanto/model/OrdersModels/order_details_model.dart';
import 'package:towanto/utils/repositories/AddressRepositories/add_address_repository.dart';
import 'package:towanto/utils/repositories/OrdersRepositories/cancel_order_repository.dart';
import 'package:towanto/utils/repositories/OrdersRepositories/order_details_repository.dart';
import 'package:towanto/utils/repositories/ProfileRepositories/update_account_repository.dart';
import 'dart:developer' as developer;
import '../../utils/common_widgets/PreferencesHelper.dart';
import '../../utils/common_widgets/Utils.dart';
import '../../utils/repositories/AddressRepositories/edit_address_repository.dart';

class CancelOrderViewModel extends ChangeNotifier {
  final _myRepo = CancelOrderRepository();
  late BuildContext context;
  bool _loading = false;
  bool get loading => _loading;

  late Message orderDetails;

  setLoading(bool value) {
    _loading = value;
    developer.log('Loading state changed to: $_loading', name: 'CancelOrderViewModel');
    notifyListeners();
  }

  Future<void> cancelOrderApi(dynamic data, BuildContext context, String sessionId) async {
    try {
      this.context = context;
      setLoading(true);
      developer.log('Starting orders details process with data: ${jsonEncode(data)}', name: 'CancelOrderViewModel');

      final value = await _myRepo.cancelOrderApiResponse(data, context, sessionId);

      developer.log('order API response received: ${value.toString()}', name: 'CancelOrderViewModel');
    } catch (e, stackTrace) {
      developer.log(
        'Error during order process',
        name: 'CancelOrderViewModel',
        error: e.toString(),
        stackTrace: stackTrace,
      );
    } finally {
      setLoading(false);
    }
  }

  // Submit method with dynamic country, state, and city validation
  Future<void> cancelOrder(BuildContext context, dynamic orderId
      ) async {
    setLoading(true);
    final sessionId = await PreferencesHelper.getString("session_id");
    // Construct the body as per the required format
    var body = {
      "params":
      {
        "order_id":"$orderId"
      }
    };

    try {
      await cancelOrderApi(jsonEncode(body), context, sessionId!);
    } finally {
      setLoading(false);
    }
  }
}
