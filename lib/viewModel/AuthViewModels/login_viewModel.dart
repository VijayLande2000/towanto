import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:towanto/utils/repositories/AuthRepositories/login_repository.dart';
import '../../utils/common_widgets/PreferencesHelper.dart';


class LoginViewModel extends ChangeNotifier {
  final _myRepo = LoginRopository();
  late BuildContext context;
  bool _loading = false;
  String? username = "";
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    developer.log('Loading state changed to: $_loading', name: 'LoginViewModel');
    notifyListeners();
  }

  Future<void> loginApi(dynamic data, BuildContext context) async {
    try {
      this.context = context;
      setLoading(true);
      developer.log('Starting login process with data: ${jsonEncode(data)}', name: 'LoginViewModel');

      final value = await _myRepo.loginApi(data, context);
      developer.log('Login API response received: ${value.toString()}', name: 'LoginViewModel');

      if (value != null && value != null) {
        await PreferencesHelper.saveString("login", value.username);
        await PreferencesHelper.saveString("partnerId", value.partnerId.toString());

        // developer.log('Username saved: ${value.username}', name: 'LoginViewModel');
       // username=value.result.username.toString();
       final  savedUsername = await PreferencesHelper.getString("login");
       final  partnerId = await PreferencesHelper.getString("partnerId");

        developer.log('Retrieved saved username: $savedUsername', name: 'LoginViewModel');
        developer.log('Retrieved saved partnerId: $partnerId', name: 'LoginViewModel');

      } else {
        developer.log('Login API response or result was null', name: 'LoginViewModel', error: 'Null Response');
      }

    } catch (e, stackTrace) {
      developer.log(
          'Error during login process',
          name: 'LoginViewModel',
          error: e.toString(),
          stackTrace: stackTrace
      );
      // You might want to show an error message to the user here
    } finally {
      setLoading(false);
    }
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool get isPasswordVisible => _isPasswordVisible;

  String? _emailError;
  String? get emailError => _emailError;

  String? _passwordError;
  String? get passwordError => _passwordError;

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void validateEmail(String value) {
    if (value.isEmpty) {
      _emailError = 'Please enter email address';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      _emailError = 'Please enter valid email address';
    } else {
      _emailError = null;
    }
    notifyListeners();
  }

  void validatePassword(String value) {
    if (value.isEmpty) {
      _passwordError = 'Please enter password';
    } else if (value.length < 6) {
      _passwordError = 'Password must be at least 6 characters';
    } else {
      _passwordError = null;
    }
    notifyListeners();
  }

  Future<void> handleLogin(BuildContext context) async {
    // Validate both fields before proceeding
    validateEmail(emailController.text);
    validatePassword(passwordController.text);
    if (_emailError == null && _passwordError == null) {
      // Implement login logic here

      FocusScope.of(context).unfocus(); // Hide keyboard
      if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {


        var body =
        {
          "jsonrpc": "2.0",
          "params": {
            "db": "towanto-ecommerce-mainbranch-16118324",
            "login": emailController.text.toString(),
            "password": passwordController.text.toString(),
          }
        };

        var jsonBody = jsonEncode(body);

        await loginApi(jsonBody, context);
        print("urfdz"+loading.toString());


        // String? shown=await PreferencesHelper.getString("shown");
        //
        // if (auth.loginSuccess){
        //   if(domainname != null && domainname == 'hj'){
        //     if(shown==null)
        //     {
        //       switcher.switchIcon(iconKey: ".MainActivity",
        //           previousIconKey: ".SecondActivity");
        //       await _dialogBuilder(context);
        //       await PreferencesHelper.saveString("shown","shown");
        //     }
        //   }
        // }
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

}