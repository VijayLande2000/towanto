import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/cupertino.dart';
import 'package:towanto/utils/repositories/AuthRepositories/forgpot_passowrd_repository.dart';

import '../../utils/common_widgets/PreferencesHelper.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  final _myRepo = ForgotPassowordRepository();
  late BuildContext context;
  bool _loading = false;

  get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    developer.log('Loading state changed to: $_loading', name: 'ForgotPasswordViewModel');
    notifyListeners();
  }

  final emailController = TextEditingController();

  String? _emailError;
  String? get emailError => _emailError;

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

  Future<void> sendPasswordResetEmail(BuildContext context) async {
    validateEmail(emailController.text);
    if (_emailError == null) {
      try {
        final sessionId = await PreferencesHelper.getString("session_id");

        this.context = context;
        setLoading(true);
        developer.log('Sending password reset email for: ${emailController.text}', name: 'ForgotPasswordViewModel');

        final body = {
          "params":
          {
            "email":emailController.text.toString()
          }
        };

        await _myRepo.forgotPasswordApi(jsonEncode(body), context);
        // Show success message or navigate to login screen
        developer.log('Password reset email sent successfully', name: 'ForgotPasswordViewModel');
      } catch (e, stackTrace) {
        developer.log(
          'Error while sending password reset email',
          name: 'ForgotPasswordViewModel',
          error: e.toString(),
          stackTrace: stackTrace,
        );
        // Show error message to the user
      } finally {
        setLoading(false);
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}