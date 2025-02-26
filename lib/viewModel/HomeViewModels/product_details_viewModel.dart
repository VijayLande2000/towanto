import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:towanto/model/HomeModels/product_details_model.dart';
import 'package:towanto/utils/repositories/AuthRepositories/login_repository.dart';
import 'package:towanto/utils/repositories/HomeRepositories/categories_list_repository.dart';
import 'package:towanto/utils/repositories/HomeRepositories/product_details_repository.dart';
import '../../model/HomeModels/categories_list_details_model.dart';
import '../../utils/common_widgets/PreferencesHelper.dart';
import '../../utils/common_widgets/Utils.dart';


class ProductdetailsViewModel extends ChangeNotifier {
  final _myRepo = ProductDetailsRepository();
  late BuildContext context;
  bool _loading = false;
  List<ProductDetailsModel> responseData = []; // Change to List

  int? _minQuantity; // Change to int
  bool get loading => _loading;
  int? get minQuantity => _minQuantity; // Change return type to int
  int? _apiMinQuantity; // Minimum quantity fetched from the API


  List<ProductDetailsModel> get responseList => responseData; // Change return type to List


  setLoading(bool value) {
    _loading = value;
    developer.log(
        'Loading state changed to: $_loading', name: 'ProductdetailsViewModel');
    notifyListeners();
  }

  Future<void> getProductDetailsViewModelApi(String categoryId, BuildContext context) async {
    try {
      this.context = context;
      setLoading(true);
      developer.log(
          'Starting ProductdetailsViewModel process with data: ${jsonEncode(categoryId)}',
          name: 'ProductdetailsViewModel'
      );

      final value = await _myRepo.getProductDetailsApi(categoryId, context);

      // Clear existing data
      responseData.clear();

      // Only add and access data if the list is not empty
      if (value.isNotEmpty) {
        responseData.addAll(value);
        // Extract and parse the minimum quantity
        if (responseData[0].minimumOrderQty != null) {
          String minQtyString = responseData[0].minimumOrderQty!;
          _minQuantity = _parseMinQuantity(minQtyString); // Parse the string to int
          setApiMinQuantity(_minQuantity!);
          developer.log(
              'Parsed minimum quantity: $_minQuantity',
              name: 'ProductdetailsViewModel'
          );
        }
        developer.log(
            'Product price: ${value[0].productPrice}',
            name: 'ProductdetailsViewModel'
        );
      } else {
        developer.log(
            'No product details returned from API',
            name: 'ProductdetailsViewModel'
        );
        // Handle empty response - maybe show a message to the user
        // You might want to add error handling logic here
      }

      developer.log(
          'ProductdetailsViewModel API response received: ${responseData.toString()}',
          name: 'ProductdetailsViewModel'
      );

    } catch (e, stackTrace) {
      developer.log(
          'Error during ProductdetailsViewModel process',
          name: 'ProductdetailsViewModel',
          error: e.toString(),
          stackTrace: stackTrace
      );
      // Show error message to the user
    } finally {
      setLoading(false);
    }
  }

  // Helper function to parse the minimum quantity string
  int? _parseMinQuantity(String minQtyString) {
    try {
      // Remove non-numeric characters (e.g., "kg", "g", etc.)
      String numericString = minQtyString.replaceAll(RegExp(r'[^0-9]'), '');
      return int.tryParse(numericString); // Parse to int
    } catch (e) {
      developer.log(
          'Error parsing minimum quantity: $e',
          name: 'ProductdetailsViewModel'
      );
      return null; // Return null if parsing fails
    }
  }
  // Set the minimum quantity fetched from the API
  void setApiMinQuantity(int apiMinQuantity) {
    _apiMinQuantity = apiMinQuantity;
    _minQuantity = _apiMinQuantity; // Initialize current quantity to API minimum
    notifyListeners();
  }

  // Increment quantity
  void incrementQuantity() {
    if (_minQuantity != null) {
      _minQuantity = _minQuantity! + 1;
      notifyListeners(); // Notify listeners to update the UI
    }
  }

  // Decrement quantity, ensuring it doesn't go below the API minimum
  void decrementQuantity() {
    if (_minQuantity != null && _apiMinQuantity != null) {
      if (_minQuantity! > _apiMinQuantity!) {
        _minQuantity = _minQuantity! - 1;
        notifyListeners(); // Notify listeners to update the UI
      }
      else{
        Utils.flushBarErrorMessages("Minimum Order Quantity for the product is $_apiMinQuantity", context);
      }
    }
  }
}