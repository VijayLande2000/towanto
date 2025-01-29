import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:towanto/model/CartModels/cart_items_list_model.dart';
import 'package:towanto/utils/repositories/CartRepositories/cart_list_repository.dart';

import '../../utils/common_widgets/PreferencesHelper.dart';

class CartListViewModel extends ChangeNotifier {
  final _myRepo = CartListRepository();
  late BuildContext context;
  bool _loading = false;

  bool _subCategoryloading = false;

  List<CartItemsListModel> _responseData = []; // Private list for cart items

  bool get loading => _loading;

  bool get subCategoryLoading => _subCategoryloading;

  List<CartItemsListModel> get cartItemsList => _responseData; // Return cart items list

  double get totalAmount {
    // Compute the totalAmount by summing it up across all CartItemsListModel
    return _responseData.fold(0.0, (sum, item) => sum + (item.totalAmount ?? 0.0));
  }
  double totalTax = 0.0;
  double totalDiscount = 0.0;
  double totalSubtotal = 0.0;
  List<dynamic> productIds =[];
  int? orderId;

  void setLoading(bool value) {
    _loading = value;
    developer.log(
        'Loading state changed to: $_loading', name: 'CartListViewModel');
    notifyListeners();
  }
  void setSubCategoryLoading(bool value) {
    _subCategoryloading = value;
    developer.log(
        'Loading state changed to: $_loading', name: 'CartListViewModel');
    notifyListeners();
  }



  Future<void> cartListViewModelApi(String categoryId, String sessionId, BuildContext context) async {
    try {
      this.context = context;
      setLoading(true);
      developer.log(
          'Starting CartListViewModel process with data: ${jsonEncode(categoryId)}', name: 'CartListViewModel');

      final value = await _myRepo.getCartListApi(categoryId, context, sessionId);

      _responseData = value; // Update the list
      // Extract the first order_id and store it
      if (value.isNotEmpty) {
        final firstOrder = value.first;
        orderId = firstOrder.products[0].orderId.first as int?;
        await PreferencesHelper.saveString("order_id", orderId.toString());
        developer.log('Extracted order ID: $orderId', name: 'CartListViewModel');
      }

// Iterate through the fetched cart items
      value.forEach((item) {
        item.products.forEach((product) {
          // Ensure these properties are being accessed and summed correctly
          totalTax += product.priceTax.toDouble() ?? 0.0;
          totalDiscount += product.discount.toDouble() ?? 0.0;
          totalSubtotal += product.priceSubtotal.toDouble() ?? 0.0;
        });
      });
      notifyListeners(); // Notify listeners after updating the data

      developer.log(
          'CartListViewModel API response received: ${_responseData.toString()}',
          name: 'CartListViewModel');

    } catch (e, stackTrace) {
      developer.log(
          'Error during CartListViewModel process',
          name: 'CartListViewModel',
          error: e.toString(),
          stackTrace: stackTrace);
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateCartListApi(String categoryId, String sessionId, BuildContext context) async {
    try {
      this.context = context;
      developer.log(
          'Starting updateCartListApi process with data: ${jsonEncode(categoryId)}',
          name: 'CartListViewModel');

      final value = await _myRepo.getCartListApi(categoryId, context, sessionId);
      _responseData = value; // Update the list

       totalTax = 0.0;
       totalDiscount = 0.0;
       totalSubtotal = 0.0;
       value.forEach((item) {
        item.products.forEach((product) {
          // Ensure these properties are being accessed and summed correctly
          totalTax += product.priceTax.toDouble() ?? 0.0;
          totalDiscount += product.discount.toDouble() ?? 0.0;
          totalSubtotal += product.priceSubtotal.toDouble() ?? 0.0;
        });
      });
      notifyListeners(); // Notify listeners after updating the data

      developer.log(
          'updateCartListApi API response received: ${_responseData.toString()}',
          name: 'CartListViewModel');
    } catch (e, stackTrace) {
      developer.log(
          'Error during updateCartListApi process',
          name: 'CartListViewModel',
          error: e.toString(),
          stackTrace: stackTrace);
    }
  }


  Future<void> cartListProductIdsViewModelApi(String categoryId, String sessionId, BuildContext context) async {
    try {
      this.context = context;
      setLoading(true);
      developer.log(
          'Starting CartListViewModel process with data: ${jsonEncode(categoryId)}', name: 'CartListViewModel');

      final value = await _myRepo.getCartListApi(categoryId, context, sessionId);

      _responseData = value; // Update the list
// Iterate through the fetched cart items
      productIds.clear();
      value.forEach((item) {
        item.products.forEach((product) {
          if (product.productId.isNotEmpty) {
            String productId = extractProductId(product.productId.toString());
            productIds.add(productId); // Add the first element (ID) from the productId list
          }
        });
      });
      productIds.forEach((element) {
        print("product id="+element.toString());
      });

      notifyListeners(); // Notify listeners after updating the data

      developer.log(
          'CartListViewModel API response received: ${_responseData.toString()}',
          name: 'CartListViewModel');

    } catch (e, stackTrace) {
      developer.log(
          'Error during CartListViewModel process',
          name: 'CartListViewModel',
          error: e.toString(),
          stackTrace: stackTrace);
    } finally {
      setLoading(false);
    }
  }

  Future<void> cartListSubProductIdsViewModelApi(String categoryId, String sessionId, BuildContext context) async {
    try {
      this.context = context;
      setSubCategoryLoading(true);
      developer.log(
          'Starting CartListViewModel process with data: ${jsonEncode(categoryId)}', name: 'CartListViewModel');

      final value = await _myRepo.getCartListApi(categoryId, context, sessionId);

      _responseData = value; // Update the list
// Iterate through the fetched cart items
      productIds.clear();
      value.forEach((item) {
        item.products.forEach((product) {
          if (product.productId.isNotEmpty) {
            String productId = extractProductId(product.productId.toString());
            productIds.add(productId); // Add the first element (ID) from the productId list
          }
        });
      });
      productIds.forEach((element) {
        print("product id="+element.toString());
      });

      notifyListeners(); // Notify listeners after updating the data

      developer.log(
          'CartListViewModel API response received: ${_responseData.toString()}',
          name: 'CartListViewModel');

    } catch (e, stackTrace) {
      developer.log(
          'Error during CartListViewModel process',
          name: 'CartListViewModel',
          error: e.toString(),
          stackTrace: stackTrace);
    } finally {
      setSubCategoryLoading(false);
    }
  }


  String extractProductId(String productDetail) {
    // This regex extracts the first numeric value from the string
    final RegExp regExp = RegExp(r'\d+');
    final match = regExp.firstMatch(productDetail);
    if (match != null) {
      return match.group(0)!; // Returns the first match (the numeric ID)
    }
    return ''; // Returns an empty string if no ID is found
  }

}
