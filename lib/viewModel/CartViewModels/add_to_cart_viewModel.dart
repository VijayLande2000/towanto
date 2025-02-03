// add_to_cart_viewmodel.dart
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/common_widgets/PreferencesHelper.dart';
import '../../utils/repositories/CartRepositories/add_to_cart_repository.dart';
import '../HomeViewModels/home_page_data_viewModel.dart';

class AddToCartViewModel extends ChangeNotifier {
  final _myRepo = AddToCartRepository();

  // Map to track cart status for multiple products
  final Map<int, bool> _inCart = {};
  final Map<int, bool> _loading = {};

  bool isInCart(int productId) => _inCart[productId] ?? false;
  bool isLoading(int productId) => _loading[productId] ?? false;

  void setLoading(int productId, bool value) {
    _loading[productId] = value;
    notifyListeners();
  }

  void setCartStatus(int productId, bool value) {
    _inCart[productId] = value;
    notifyListeners();
  }
  /// **Method to Remove All Items from Cart**
  void clearCart() {
    _inCart.clear(); // Remove all cart items
    _loading.clear(); // Clear loading states
    notifyListeners();
  }

  Future<void> addToCartApi(int productId, dynamic data, BuildContext context,String SessionId) async {
    try {
      setLoading(productId, true);
      final response = await _myRepo.addToCartApi(data, context,SessionId);

      if (response?.result?.success != null) {
        print("id inside ADD viewmodel"+productId.toString());
        setCartStatus(productId, true);
      }
    } catch (e, stackTrace) {
      developer.log(
          'Error during AddToCart process',
          name: 'AddToCartViewModel',
          error: e.toString(),
          stackTrace: stackTrace
      );
      setCartStatus(productId, false);
    } finally {
      setLoading(productId, false);
    }
  }

  // Future<void> removeFromCartApi(int productId, dynamic data, BuildContext context) async {
  //   try {
  //     setLoading(productId, true);
  //     final response = await _myRepo.removeFromCartApi(data, context);
  //
  //     if (response?.result?.success != null) {
  //       setCartStatus(productId, false);
  //     }
  //   } catch (e, stackTrace) {
  //     developer.log(
  //         'Error during RemoveFromCart process',
  //         name: 'AddToCartViewModel',
  //         error: e.toString(),
  //         stackTrace: stackTrace
  //     );
  //   } finally {
  //     setLoading(productId, false);
  //   }
  // }

  Future<void> toggleCartStatus(
      String partnerId, int productId, int quantity, BuildContext context) async {
    final bool currentlyInCart = isInCart(productId);
    final sessionId=await PreferencesHelper.getString("session_id");
  print("dfjkgbk"+productId.toString());
    final body = {
      "params": {
        "partner_id":  int.parse(partnerId.toString()),
        "product_id": productId,
        "quantity": quantity,
      },
    };

    if (currentlyInCart) {
      // await addToCartApi(productId, jsonEncode(body), context,sessionId!);
      // await removeFromCartApi(productId, jsonEncode(body), context);
    } else {
      await addToCartApi(productId, jsonEncode(body), context,sessionId!);
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