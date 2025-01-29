import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/common_widgets/PreferencesHelper.dart';
import '../../utils/repositories/WhishListRepository/add_to_whishList_repository.dart';
import '../HomeViewModels/home_page_data_viewModel.dart';

class AddToWhishListViewModel extends ChangeNotifier {
  final _myRepo = AddToWhishListRepository();

  // General loading and wishlist state
  bool _isInWhishList = false;
  bool _isLoading = false;

  bool get isInWhishList => _isInWhishList;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setWhishListStatus(bool value) {
    _isInWhishList = value;
    notifyListeners();
  }

  Future<void> addToWhishListApi(dynamic data, BuildContext context, String sessionId) async {
    try {
      setLoading(true);
      final response = await _myRepo.addToWhishListApi(data, context, sessionId);

      if (response.success != null) {
        setWhishListStatus(true);
      }
    } catch (e, stackTrace) {
      developer.log(
        'Error during AddToWhishList process',
        name: 'AddToWhishListViewModel',
        error: e.toString(),
        stackTrace: stackTrace,
      );
      setWhishListStatus(false);
    } finally {
      setLoading(false);
    }
  }

  Future<void> toggleWishlistStatus(String partnerId, int productId, BuildContext context) async {
    if (_isLoading) return; // Prevent duplicate requests

    final sessionId = await PreferencesHelper.getString("session_id");

    final body = {
      "params": {
        "partner_id": int.parse(partnerId),
        "product_id": productId,
      },
    };

    if (_isInWhishList) {
      // Optionally handle removal from wishlist here
      // setWhishListStatus(false);
    } else {
      await addToWhishListApi(jsonEncode(body), context, sessionId!);
      await fetchHomePageData(context);
    }
  }

  Future<void> fetchHomePageData(BuildContext context) async {
    // Obtain the instance of CategoriesListViewModel
    final homePageViewModel =
    Provider.of<HomePageDataViewModel>(context, listen: false);
    await homePageViewModel.fetchHomePageData("6,4", context);
  }
}
