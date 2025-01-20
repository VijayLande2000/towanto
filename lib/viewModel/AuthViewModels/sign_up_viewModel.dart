import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/cupertino.dart';
import 'package:towanto/utils/repositories/AuthRepositories/login_repository.dart';
import 'package:towanto/utils/repositories/AuthRepositories/sign_up_repository.dart';

import '../../model/AuthModels/login_model.dart';
import '../../utils/common_widgets/PreferencesHelper.dart';
import '../../utils/common_widgets/Utils.dart';
import '../../utils/network/networkService/app_exceptions.dart';

class SignUpViewModel extends ChangeNotifier {
  final _myRepo = SignUpRopository();
  late BuildContext context;
  bool _loading = false;

  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    developer.log('Loading state changed to: $_loading', name: 'SignUpViewModel');
    notifyListeners();
  }

  Future<void> signUpApi(dynamic data, BuildContext context) async {
    try {
      this.context = context;
      setLoading(true);
      developer.log('Starting SignUp process with data: ${jsonEncode(data)}', name: 'SignUpViewModel');

      final value = await _myRepo.signUp(data, context);
      developer.log('SignUp API response received: ${value.toString()}', name: 'SignUpViewModel');

      // if (value != null && value.result != null) {
      //   await PreferencesHelper.saveString("login", value.result.username);
      //   developer.log('Username saved: ${value.result.username}', name: 'LoginViewModel');
      //
      //   final savedUsername = await PreferencesHelper.getString("login");
      //   developer.log('Retrieved saved username: $savedUsername', name: 'LoginViewModel');
      // } else {
      //   developer.log('Login API response or result was null', name: 'LoginViewModel', error: 'Null Response');
      // }

    } catch (e, stackTrace) {
      developer.log(
          'Error during SignUP process',
          name: 'SignUpViewModel',
          error: e.toString(),
          stackTrace: stackTrace
      );
      // You might want to show an error message to the user here
    } finally {
      setLoading(false);
    }
  }


}