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
import '../../utils/repositories/OrdersRepositories/payment_confirmation_repository.dart';

class PaymentConfirmationViewModel extends ChangeNotifier {
  final _myRepo = PaymentConfirmationRepository();
  late BuildContext context;
  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    developer.log('Loading state changed to: $_loading', name: 'PaymentConfirmationViewModel');
    notifyListeners();
  }

  Future<void> paymentConfirmationApi(dynamic data, BuildContext context, String sessionId) async {
    try {
      this.context = context;
      setLoading(true);
      developer.log('Starting orders details process with data: ${jsonEncode(data)}', name: 'PaymentConfirmationViewModel');

      final value = await _myRepo.paymentConfirmationApiResponse(data, context, sessionId);

      developer.log('payment API response received: ${value.toString()}', name: 'PaymentConfirmationViewModel');
    } catch (e, stackTrace) {
      developer.log(
        'Error during order process',
        name: 'PaymentConfirmationViewModel',
        error: e.toString(),
        stackTrace: stackTrace,
      );
    } finally {
      setLoading(false);
    }
  }

  // Submit method with dynamic country, state, and city validation
  Future<void> paymentConfirmation(BuildContext context
      ) async {
    setLoading(true);
    final sessionId = await PreferencesHelper.getString("session_id");
    final partnerId = await PreferencesHelper.getString("partnerId");

    try {
      await paymentConfirmationApi(partnerId,context,sessionId!);
    } finally {
      setLoading(false);
    }
  }
}
