import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:towanto/utils/repositories/AuthRepositories/login_repository.dart';
import 'package:towanto/utils/repositories/HomeRepositories/categories_list_repository.dart';
import '../../model/HomeModels/categories_list_details_model.dart';
import '../../utils/common_widgets/PreferencesHelper.dart';


class CategoriesListViewModel extends ChangeNotifier {
  final _myRepo = CategoriesListRepository();
  late BuildContext context;
  bool _loading = false;
   CategoriesListDetailsModel? responseData; // Change to List


  bool get loading => _loading;
  CategoriesListDetailsModel? get responseList => responseData; // Change return type to List


  setLoading(bool value) {
    _loading = value;
    developer.log(
        'Loading state changed to: $_loading', name: 'CategoriesListViewModel');
    notifyListeners();
  }

  Future<void> categoriesListViewModelApi(String categoryId, BuildContext context) async {
    try {
      this.context = context;
      setLoading(true);
      developer.log(
          'Starting CategoriesListViewModel process with data: ${jsonEncode(
              categoryId)}', name: 'CategoriesListViewModel');

      final value = await _myRepo.getCategoryListApi(categoryId, context);
          responseData=value;


      developer.log(
          'CategoriesListViewModel API response received: ${responseData.toString()}',
          name: 'CategoriesListViewModel');
      //
      // if (value != null && value.result != null) {
      //   await PreferencesHelper.saveString("login", value.result.username);
      //   developer.log('Username saved: ${value.result.username}', name: 'CategoriesListViewModel');
      //
      //   final savedUsername = await PreferencesHelper.getString("login");
      //   developer.log('Retrieved saved username: $savedUsername', name: 'LoginViewModel');
      // } else {
      //   developer.log('Login API response or result was null', name: 'LoginViewModel', error: 'Null Response');
      // }

    } catch (e, stackTrace) {
      developer.log(
          'Error during CategoriesListViewModel process',
          name: 'CategoriesListViewModel',
          error: e.toString(),
          stackTrace: stackTrace
      );
      // You might want to show an error message to the user here
    } finally {
      setLoading(false);
    }
  }
}