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
import '../../utils/repositories/AuthRepositories/de_activate_account_repository.dart';

class DeactivateAccountViewModel extends ChangeNotifier {
  final _myRepo = DeactivateAccountRepository();
  late BuildContext context;
  bool _loading = false;
  bool get loading => _loading;


  setLoading(bool value) {
    _loading = value;
    developer.log('Loading state changed to: $_loading', name: 'DeactivateAccountViewModel');
    notifyListeners();
  }

  Future<void> deActivateApi(dynamic data, BuildContext context, String sessionId) async {
    try {
      this.context = context;
      setLoading(true);
      developer.log('Starting orders details process with data: ${jsonEncode(data)}', name: 'DeactivateAccountViewModel');

      final value = await _myRepo.deactivateAccountApiResponse(data, context, sessionId);

      developer.log('order API response received: ${value.toString()}', name: 'DeactivateAccountViewModel');
    } catch (e, stackTrace) {
      developer.log(
        'Error during order process',
        name: 'DeactivateAccountViewModel',
        error: e.toString(),
        stackTrace: stackTrace,
      );
    } finally {
      setLoading(false);
    }
  }

  // Submit method with dynamic country, state, and city validation
  Future<void> deactivateAccountApiCall(BuildContext context, dynamic email,dynamic password
      ) async {
    setLoading(true);
    final sessionId = await PreferencesHelper.getString("session_id");
    print("dfjngk"+email.toString());
    print("dfjngk"+password.toString());
    // Construct the body as per the required format
    var body = {
      "jsonrpc": "2.0",
      "params": {
        "validation": email.toString(),
        "password": password.toString()
      }
    };
    try {
      await deActivateApi(jsonEncode(body), context, sessionId!);
    } finally {
      setLoading(false);
    }
  }
}
