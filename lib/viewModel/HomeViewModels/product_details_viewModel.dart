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


class ProductdetailsViewModel extends ChangeNotifier {
  final _myRepo = ProductDetailsRepository();
  late BuildContext context;
  bool _loading = false;
  List<ProductDetailsModel> responseData = []; // Change to List


  bool get loading => _loading;
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
}