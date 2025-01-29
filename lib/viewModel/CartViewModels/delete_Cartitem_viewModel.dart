import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:towanto/model/CartModels/delete_cart_model.dart';
import 'package:towanto/utils/repositories/AuthRepositories/login_repository.dart';
import 'package:towanto/utils/repositories/CartRepositories/delete_cart_repository.dart';
import 'package:towanto/utils/repositories/HomeRepositories/categories_list_repository.dart';
import '../../model/HomeModels/categories_list_details_model.dart';
import '../../utils/common_widgets/PreferencesHelper.dart';
import 'add_to_cart_viewModel.dart';


class DeleteCartItemViewModel extends ChangeNotifier {
  final _myRepo = DeleteCartRepository();
  late BuildContext context;
  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    developer.log(
        'Loading state changed to: $_loading', name: 'DeleteCartItemViewModel');
    notifyListeners();
  }

  Future<void> deleteCartItemViewModelApi(String partnerId,String id, BuildContext context,String sessionId,String prodcutId) async {
    try {
      this.context = context;
      setLoading(true);
      developer.log('Starting DeleteCartItemViewModel process with data: ${jsonEncode(partnerId)}', name: 'DeleteCartItemViewModel');

      final value = await _myRepo.deleteCartItemApi(partnerId,id, context,sessionId);
      if(value!=null){
        print("id inside delete viewmodel"+id.toString());
        print("id inside delete viewmodel"+prodcutId.toString());

        final addToCartViewModel = Provider.of<AddToCartViewModel>(context, listen: false);
        addToCartViewModel.setCartStatus(int.tryParse(prodcutId) ?? 0, false);
      }
    } catch (e, stackTrace) {
      developer.log(
          'Error during DeleteCartItemViewModel process',
          name: 'DeleteCartItemViewModel',
          error: e.toString(),
          stackTrace: stackTrace
      );
      // You might want to show an error message to the user here
    } finally {
      setLoading(false);
    }
  }
}