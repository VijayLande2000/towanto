import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:towanto/utils/repositories/ProfileRepositories/update_account_repository.dart';
import 'dart:developer' as developer;
import '../../utils/common_widgets/PreferencesHelper.dart';
import '../../utils/common_widgets/Utils.dart';

class AccountInfoViewModel extends ChangeNotifier {
  final _myRepo = UpdateAccountRepository();
  late BuildContext context;
  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    developer.log('Loading state changed to: $_loading', name: 'updateAccountViewModel');
    notifyListeners();
  }

  Future<void> updateAccountPostApi(dynamic data, BuildContext context, String sessionId) async {
    try {
      this.context = context;
      setLoading(true);
      developer.log('Starting login process with data: ${jsonEncode(data)}', name: 'updateAccountViewModel');

      final value = await _myRepo.updateAccountInformationApiResponse(data, context, sessionId);
      developer.log('Account API response received: ${value.toString()}', name: 'updateAccountViewModel');
    } catch (e, stackTrace) {
      developer.log(
        'Error during account process',
        name: 'updateAccountViewModel',
        error: e.toString(),
        stackTrace: stackTrace,
      );
    } finally {
      setLoading(false);
    }
  }

  // List of form fields
  List<Map<String, dynamic>> formFields = [
    {
      'key': 'firmName',
      'label': 'Firm Name',
      'hint': 'Enter your firm name',
      'icon': Icons.business,
      'controller': TextEditingController(),
    },
    {
      'key': 'proprietorName',
      'label': 'Proprietor Name',
      'hint': 'Enter proprietor name',
      'icon': Icons.person,
      'controller': TextEditingController(),
    },
    {
      'key': 'email',
      'label': 'Email',
      'hint': 'Enter your email',
      'icon': Icons.email,
      'controller': TextEditingController(),
    },
    {
      'key': 'address',
      'label': 'Address',
      'hint': 'Enter your address',
      'icon': Icons.home,
      'controller': TextEditingController(),
    },
    {
      'key': 'zipCode',
      'label': 'Zip Code',
      'hint': 'Enter your zip code',
      'icon': Icons.location_on,
      'controller': TextEditingController(),
    },
    {
      'key': 'phone',
      'label': 'Phone',
      'hint': 'Enter your phone number',
      'icon': Icons.phone,
      'controller': TextEditingController(),
    },
    {
      'key': 'gstNumber',
      'label': 'GST Number',
      'hint': 'Enter your GST Number',
      'icon': Icons.business_center,
      'controller': TextEditingController(),
    },
  ];

  // Errors map for validation messages
  Map<String, String?> errors = {};

  // Validation for each field
  void validateField(String key) {
    final controller = formFields.firstWhere((field) => field['key'] == key)['controller'] as TextEditingController;
    final value = controller.text.trim();

    if (value.isEmpty) {
      errors[key] = "This field cannot be empty";
    } else if (key == 'email' && !RegExp(r"^[^@]+@[^@]+\.[^@]+").hasMatch(value)) {
      errors[key] = "Enter a valid email address";
    } else if (key == 'phone' && value.length < 10) {
      errors[key] = "Enter a valid phone number";
    } else {
      errors[key] = null;
    }
    notifyListeners();
  }

  // Dynamic validation for country, state, and city
  void validateLocationFields(dynamic selectedCountry, dynamic selectedState, dynamic selectedCity, BuildContext context) {
    if (selectedCountry == null || selectedCountry.isEmpty) {
      Utils.flushBarErrorMessages("Country  or state or city cannot be empty", context);
      errors['country'] = "Country cannot be empty";
    } else {
      errors['country'] = null;
    }

    if (selectedState == null || selectedState.isEmpty) {
      Utils.flushBarErrorMessages("Country  or state or city cannot be empty", context);
      errors['state'] = "State cannot be empty";
    } else {
      errors['state'] = null;
    }

    if (selectedCity == null || selectedCity.isEmpty) {
      Utils.flushBarErrorMessages("Country  or state or city cannot be empty", context);
      errors['city'] = "City cannot be empty";
    } else {
      errors['city'] = null;
    }

    notifyListeners();
  }

  // Submit method with dynamic country, state, and city validation
  Future<void> submitAccountInfo(BuildContext context, dynamic selectedCountry, dynamic selectedState, dynamic selectedCity) async {
    // Validate all fields
    for (final field in formFields) {
      validateField(field['key']);
    }

    // Validate country, state, and city dynamically
    validateLocationFields(selectedCountry, selectedState, selectedCity, context);

    // Check if all fields are valid
    if (errors.values.every((error) => error == null)) {
      setLoading(true);
      final sessionId = await PreferencesHelper.getString("session_id");

      var body = {
        "jsonrpc": "2.0",
        "params": {
          for (final field in formFields)
            field['key']: (field['controller'] as TextEditingController).text.trim(),
          "street": selectedCountry,
          "street2": selectedState,
          "city": selectedCity,
        }
      };
      await updateAccountPostApi(jsonEncode(body), context, sessionId!);
    }
  }
}
