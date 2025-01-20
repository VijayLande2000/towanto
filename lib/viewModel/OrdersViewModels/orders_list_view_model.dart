import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:towanto/model/OrdersModels/orders_list_model.dart';
import '../../utils/repositories/OrdersRepositories/orders_list_repository.dart';

class OrdersListViewModel extends ChangeNotifier {
  final OrdersListRepository _myRepo = OrdersListRepository();
  late BuildContext context;

  bool _loading = false;
  List<Data> _responseData = []; // Private list for order items

  // Getter for loading state
  bool get loading => _loading;

  // Getter for order items list
  List<Data> get ordersItemsList => _responseData;

  // Method to set the loading state
  void setLoading(bool value) {
    _loading = value;
    developer.log('Loading state changed to: $_loading', name: 'OrdersListViewModel');
    notifyListeners();
  }
  Future<void> ordersListViewModelApi(String partnerId, String sessionId, BuildContext context) async {
    try {
      this.context = context;
      setLoading(true);
      ordersItemsList.clear();
      final value = await _myRepo.getOrdersListApi(partnerId, context,sessionId);
      if (value.data!= null) {
        ordersItemsList.addAll(value.data!);
      }
    } catch (e, stackTrace) {
      developer.log(
        'Error during account process',
        name: 'getOrdersViewModel',
        error: e.toString(),
        stackTrace: stackTrace,
      );
    } finally {
      setLoading(false);
    }
  }
}
