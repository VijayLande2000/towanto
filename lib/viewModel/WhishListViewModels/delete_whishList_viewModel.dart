import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:towanto/model/CartModels/delete_cart_model.dart';
import 'package:towanto/utils/repositories/AuthRepositories/login_repository.dart';
import 'package:towanto/utils/repositories/CartRepositories/delete_cart_repository.dart';
import 'package:towanto/utils/repositories/HomeRepositories/categories_list_repository.dart';
import 'package:towanto/utils/repositories/WhishListRepository/delete_whishList_repository.dart';
import '../../model/HomeModels/categories_list_details_model.dart';
import '../../utils/common_widgets/PreferencesHelper.dart';


class DeleteWhishlistItemViewModel extends ChangeNotifier {
  final _myRepo = DeleteWhishListRepository();
  late BuildContext context;
  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    developer.log(
        'Loading state changed to: $_loading', name: 'DeleteWhishtemViewModel');
    notifyListeners();
  }

  Future<void> deleteWhishtlistViewModelApi(String partnerId,String id, BuildContext context,String sessionId) async {
    try {
      this.context = context;
      setLoading(true);
      developer.log(
          'Starting DeleteWhishtemViewModel process with data: ${jsonEncode(
              partnerId)}', name: 'DeleteWhishtemViewModel');

      final value = await _myRepo.deleteWhishListItemApi(partnerId,id, context,sessionId);
    } catch (e, stackTrace) {
      developer.log(
          'Error during DeleteWhishtemViewModel process',
          name: 'DeleteWhishtemViewModel',
          error: e.toString(),
          stackTrace: stackTrace
      );
      // You might want to show an error message to the user here
    } finally {
      setLoading(false);
    }
  }
}