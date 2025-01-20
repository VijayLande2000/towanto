import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/cupertino.dart';
import '../../utils/repositories/CartRepositories/updateCart_repository.dart';
import '../../utils/common_widgets/PreferencesHelper.dart';

class UpdateCartViewModel extends ChangeNotifier {
  final _myRepo = UpdateCartRepository();
  bool _loading = false;

  bool get loading => _loading;


  setLoading(bool value) {
    _loading = value;
    developer.log('Loading state changed to: $_loading', name: 'UpdateCartViewModel');
    notifyListeners();
  }

  Future<void> updateCart(String productId, String quantity, BuildContext context) async {
    try {
      setLoading(true);
      developer.log('Updating cart with product ID: $productId, quantity: $quantity', name: 'UpdateCartViewModel');

      // Validate and parse productId
      final int? parsedProductId = int.tryParse(productId);
      if (parsedProductId == null) {
        throw FormatException("Invalid product ID: $productId");
      }

      // Validate and parse quantity, converting it to an integer if it's a floating-point number
      final double? parsedQuantityDouble = double.tryParse(quantity);
      if (parsedQuantityDouble == null) {
        throw FormatException("Invalid quantity: $quantity");
      }
      final int parsedQuantity = parsedQuantityDouble.toInt();

      var body = {
        "jsonrpc": "2.0",
        "params": {
          "id": parsedProductId,
          "quantity": parsedQuantity,
        }
      };

      final sessionId = await PreferencesHelper.getString("session_id");
      if (sessionId == null) {
        developer.log('Session ID is null. Cannot proceed with API call.', name: 'UpdateCartViewModel');
        return;
      }

      var jsonBody = jsonEncode(body);
      final response = await _myRepo.updateCartApi(jsonBody, context, sessionId);
      if (response != null) {
        developer.log('Cart updated successfully: ${response.toString()}', name: 'UpdateCartViewModel');
      } else {
        developer.log('Cart API response or result was null', name: 'UpdateCartViewModel');
      }
    } catch (e, stackTrace) {
      developer.log(
        'Error during cart update',
        name: 'UpdateCartViewModel',
        error: e.toString(),
        stackTrace: stackTrace,
      );
    } finally {
      setLoading(false);
    }
  }
}
