import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:towanto/utils/repositories/AuthRepositories/login_repository.dart';
import 'package:towanto/utils/repositories/HomeRepositories/categories_list_repository.dart';
import '../../model/HomeModels/categories_list_details_model.dart';
import '../../utils/common_widgets/PreferencesHelper.dart';


class CategoriesListViewModel extends ChangeNotifier {

  //create late model here

  final _myRepo = CategoriesListRepository();
  late BuildContext context;
  bool _loading = false;
  bool _subCategoryloading = false;
   CategoriesListDetailsModel? responseData; // Change to List

  // Recursive category tree map: { Category -> { Subcategory -> { Sub-subcategory -> {...} } } }
  // Recursive category tree map: { Category -> { Subcategory -> { Sub-subcategory -> {...} } } }
  Map<String, dynamic> categoryTree = {};
  /// Recursive function to build a nested map for categories and subcategories

  /// Recursive function to build a nested map for categories and subcategories
  Map<String, dynamic> buildCategoryTree(List<CategoryChilds> subcategories) {
    Map<String, dynamic> tree = {};
    for (var subcategory in subcategories) {
      String name = subcategory.displayName ?? "Unknown";
      String id = subcategory.id?.toString() ?? "Unknown"; // Convert int to String

      // Recursively add deeper subcategories
      if (subcategory.subcategories != null && subcategory.subcategories!.isNotEmpty) {
        tree[name] = {
          'id': id,
          'subcategories': buildCategoryTree(subcategory.subcategories!)
        };
      } else {
        tree[name] = {'id': id, 'subcategories': {}}; // No further subcategories, empty map
      }
    }
    return tree;
  }


  bool get loading => _loading;
  bool get subCategoryLoading => _subCategoryloading;
  CategoriesListDetailsModel? get responseList => responseData; // Change return type to List


  setLoading(bool value) {
    _loading = value;
    developer.log(
        'Loading state changed to: $_loading', name: 'CategoriesListViewModel');
    notifyListeners();
  }


  setSubCategoryLoading(bool value) {
    _subCategoryloading = value;
    developer.log(
        'Loading state changed to: $_subCategoryloading', name: 'CategoriesListViewModel');
    notifyListeners();
  }

  Future<void> categoriesListViewModelApi(String categoryId, BuildContext context) async {
    try {
      responseData = null;
      categoryTree.clear(); // Reset tree before updating
      this.context = context;
      final sessionId = await PreferencesHelper.getString("session_id");

      setLoading(true);
      // developer.log(
      //     'Starting CategoriesListViewModel process with data: ${jsonEncode(
      //         categoryId)}', name: 'CategoriesListViewModel');

      final value = await _myRepo.getCategoryListApi(categoryId, context,sessionId);
          responseData=value;
//model = repose
      //notifiy providres
      //set loaidn faslse

    //   for (var category in value.categories) {
    //     categories.add(category.displayName??"");
    // // Accessing subcategories
    //
    // for (var subcategory in category.subcategories) {
    // print("Subcategory Name: ${subcategory.name}");
    // print("Subcategory Display Name: ${subcategory.displayName}");
    // }
    //
    //
    // print("Category: ${category.id}");
    //     print("Subcategories: ${category.subcategories}");
    //   }




      for (var category in value.categories) {
        String categoryName = category.displayName ?? "Unknown";
        String categoryId = category.id?.toString() ?? "Unknown"; // Convert int to String
        categoryTree[categoryName] = {
          'id': categoryId,
          'subcategories': buildCategoryTree(category.subcategories)
        };
      }

      // developer.log('Category Tree: ${jsonEncode(categoryTree)}', name: 'CategoriesListViewModel');
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

  Future<void> subCategoriesListViewModelApi(String categoryId, BuildContext context) async {
    try {
      this.context = context;

      final sessionId = await PreferencesHelper.getString("session_id");

      setSubCategoryLoading(true);
      developer.log(
          'Starting CategoriesListViewModel process with data: ${jsonEncode(
              categoryId)}', name: 'CategoriesListViewModel');

      final value = await _myRepo.getCategoryListApi(categoryId, context,sessionId);
      responseData=value;
      //   for (var category in value.categories) {
      //     categories.add(category.displayName??"");
      // // Accessing subcategories
      //
      // for (var subcategory in category.subcategories) {
      // print("Subcategory Name: ${subcategory.name}");
      // print("Subcategory Display Name: ${subcategory.displayName}");
      // }
      //
      //
      // print("Category: ${category.id}");
      //     print("Subcategories: ${category.subcategories}");
      //   }

      // categoryTree.clear(); // Reset tree before updating
      //
      // for (var category in value.categories) {
      //   String categoryName = category.displayName ?? "Unknown";
      //   String categoryId = category.id?.toString() ?? "Unknown"; // Convert int to String
      //   categoryTree[categoryName] = {
      //     'id': categoryId,
      //     'subcategories': buildCategoryTree(category.subcategories)
      //   };
      // }
      //
      // developer.log('Category Tree: ${jsonEncode(categoryTree)}', name: 'CategoriesListViewModel');
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
      setSubCategoryLoading(false);
    }
  }

}