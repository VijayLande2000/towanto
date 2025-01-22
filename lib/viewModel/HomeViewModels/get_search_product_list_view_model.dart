import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:towanto/model/Address_Models/get_Address_list_model.dart';
import 'package:towanto/utils/repositories/AddressRepositories/get_address_list_repository.dart';
import 'package:towanto/utils/repositories/ProfileRepositories/update_account_repository.dart';
import 'dart:developer' as developer;
import '../../model/HomeModels/search_product_model.dart';
import '../../utils/common_widgets/PreferencesHelper.dart';
import '../../utils/common_widgets/Utils.dart';
import '../../utils/repositories/HomeRepositories/product_search_list_repository.dart';

class SearchProductViewModel extends ChangeNotifier {
  final _myRepo = SearchProductRepository();
  late BuildContext context;
  bool _loading = false;
  bool get loading => _loading;
  List<Products> products = []; // Initialize with an empty list

  setLoading(bool value) {
    _loading = value;
    developer.log('Loading state changed to: $_loading', name: 'getproductsViewModel');
    notifyListeners();
  }

  Future<void> getproductsListPostApi(dynamic data, BuildContext context, String sessionId) async {
    try {
      this.context = context;
      setLoading(true);
      products.clear();
      developer.log('Starting getproductsViewModel process with data: ${jsonEncode(data)}', name: 'getproductsViewModel');

      final value = await _myRepo.getSearchProductListApiResponse(data, context, sessionId);
      if (value.result?.products != null) {
        products.addAll(value.result!.products!); // Safely add addresses
      }

      developer.log('Account API response received: ${value.toString()}', name: 'getproductsViewModel');
      developer.log('Account API response received: ${products.length}', name: 'getproductsViewModel');
    } catch (e, stackTrace) {
      developer.log(
        'Error during account process',
        name: 'getproductsViewModel',
        error: e.toString(),
        stackTrace: stackTrace,
      );
    } finally {
      setLoading(false);
    }
  }

  // Submit method with dynamic country, state, and city validation
  Future<void> getproductsList(BuildContext context,String searchText) async {
    setLoading(true);
    final sessionId = await PreferencesHelper.getString("session_id");
    var body = {
      "params":
      {
        "name":searchText
      }
    };
    await getproductsListPostApi(jsonEncode(body), context, sessionId!);
  }
  //
  //
  // Future<void> getupdateAddressListPostApi(dynamic data, BuildContext context, String sessionId) async {
  //   try {
  //     this.context = context;
  //     addresses.clear();
  //     developer.log('Starting getAddressViewModel process with data: ${jsonEncode(data)}', name: 'getAddressViewModel');
  //
  //     final value = await _myRepo.getAddressListApiResponse(data, context, sessionId);
  //     if (value.result?.addresses != null) {
  //       addresses.addAll(value.result!.addresses!); // Safely add addresses
  //     }
  //
  //
  //     developer.log('Account API response received: ${value.toString()}', name: 'getAddressViewModel');
  //     developer.log('Account API response received: ${addresses.length}', name: 'getAddressViewModel');
  //   } catch (e, stackTrace) {
  //     developer.log(
  //       'Error during account process',
  //       name: 'getAddressViewModel',
  //       error: e.toString(),
  //       stackTrace: stackTrace,
  //     );
  //   } finally {
  //     setLoading(false);
  //   }
  // }
  //
  //
  // Future<void> getupdateAddressList(BuildContext context) async {
  //   final sessionId = await PreferencesHelper.getString("session_id");
  //   final partner_id = await PreferencesHelper.getString("partnerId");
  //   var body = {
  //     "params":{
  //       "partner_id": int.tryParse(partner_id.toString())
  //     }
  //   };
  //   await getupdateAddressListPostApi(jsonEncode(body), context, sessionId!);
  // }


  }

