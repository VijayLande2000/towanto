import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:towanto/model/Address_Models/get_Address_list_model.dart';
import 'package:towanto/utils/repositories/AddressRepositories/get_address_list_repository.dart';
import 'package:towanto/utils/repositories/ProfileRepositories/update_account_repository.dart';
import 'dart:developer' as developer;
import '../../utils/common_widgets/PreferencesHelper.dart';
import '../../utils/common_widgets/Utils.dart';

class GetAddressViewModel extends ChangeNotifier {
  final _myRepo = GetAddressRepository();
  late BuildContext context;
  bool _loading = false;
  bool get loading => _loading;
  List<Address> addresses = []; // Initialize with an empty list

  setLoading(bool value) {
    _loading = value;
    developer.log('Loading state changed to: $_loading', name: 'getAddressViewModel');
    notifyListeners();
  }

  Future<void> getAddressListPostApi(dynamic data, BuildContext context, String sessionId) async {
    try {
      this.context = context;
      setLoading(true);
      addresses.clear();
      developer.log('Starting getAddressViewModel process with data: ${jsonEncode(data)}', name: 'getAddressViewModel');

      final value = await _myRepo.getAddressListApiResponse(data, context, sessionId);
      if (value.result?.addresses != null) {
        addresses.addAll(value.result!.addresses!); // Safely add addresses
      }

      developer.log('Account API response received: ${value.toString()}', name: 'getAddressViewModel');
      developer.log('Account API response received: ${addresses.length}', name: 'getAddressViewModel');
    } catch (e, stackTrace) {
      developer.log(
        'Error during account process',
        name: 'getAddressViewModel',
        error: e.toString(),
        stackTrace: stackTrace,
      );
    } finally {
      setLoading(false);
    }
  }

  // Submit method with dynamic country, state, and city validation
  Future<void> getAddressList(BuildContext context) async {
    setLoading(true);
    final sessionId = await PreferencesHelper.getString("session_id");
    final partner_id = await PreferencesHelper.getString("partnerId");
    var body = {
      "params":{
        "partner_id": int.tryParse(partner_id.toString())
      }
    };
    await getAddressListPostApi(jsonEncode(body), context, sessionId!);
  }


  Future<void> getupdateAddressListPostApi(dynamic data, BuildContext context, String sessionId) async {
    try {
      this.context = context;
      addresses.clear();
      developer.log('Starting getAddressViewModel process with data: ${jsonEncode(data)}', name: 'getAddressViewModel');

      final value = await _myRepo.getAddressListApiResponse(data, context, sessionId);
      if (value.result?.addresses != null) {
        addresses.addAll(value.result!.addresses!); // Safely add addresses
      }


      developer.log('Account API response received: ${value.toString()}', name: 'getAddressViewModel');
      developer.log('Account API response received: ${addresses.length}', name: 'getAddressViewModel');
    } catch (e, stackTrace) {
      developer.log(
        'Error during account process',
        name: 'getAddressViewModel',
        error: e.toString(),
        stackTrace: stackTrace,
      );
    } finally {
      setLoading(false);
    }
  }


  Future<void> getupdateAddressList(BuildContext context) async {
    final sessionId = await PreferencesHelper.getString("session_id");
    final partner_id = await PreferencesHelper.getString("partnerId");
    var body = {
      "params":{
        "partner_id": int.tryParse(partner_id.toString())
      }
    };
    await getupdateAddressListPostApi(jsonEncode(body), context, sessionId!);
  }


  }

