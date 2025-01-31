import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:towanto/utils/repositories/ProfileRepositories/update_account_repository.dart';
import 'dart:developer' as developer;
import '../../utils/common_widgets/PreferencesHelper.dart';
import '../../utils/common_widgets/Utils.dart';
import '../../utils/repositories/ProfileRepositories/logged_in_user_info_repository.dart';

class AccountInfoViewModel extends ChangeNotifier {
  final _myRepo = UpdateAccountRepository();
  final  fetchRepo=LoggedInUserInfoRepository(); // Repository for fetching account information

  late BuildContext context;
  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    developer.log('Loading state changed to: $_loading', name: 'updateAccountViewModel');
    notifyListeners();
  }
  Future<void> fetchAndAssignAccountInfo(BuildContext context) async {
    try {
      setLoading(true);
      final sessionId = await PreferencesHelper.getString("session_id");

      var body = {
        "jsonrpc": "2.0",
        "params": {}
      };
      final response = await fetchRepo.getLoggedInUserInformationApiResponse(
          jsonEncode(body), context, sessionId!);

      // Define a mapping between API response keys and form field keys
      final Map<String, String> apiToFormFieldMapping = {
        'name': 'name',
        'username': 'email',
        'zipcode': 'zipCode',
        'phone': 'phone',
        'vat': 'gstNumber',
        'street': 'address',
        'street2': 'address2',
        'city': 'city',
        'country': 'country',
        'state': 'state',
        'firm_name': 'firmName',  // mapping `firm_name` to `firmName` in form fields
      };



      // Extract the 'result' field from the API response
      final responseData = response.toJson()['result'];

      // Print the API response for debugging
      developer.log('API Response: ${response.toJson()}', name: 'AccountInfo');

      // Assign fetched data to the corresponding form field controllers
      formFields.forEach((field) {
        final formKey = field['key']; // Key from the form field
        developer.log('Processing form field: $formKey', name: 'AccountInfo');

        // Find the corresponding API key based on the mapping
        final apiKey = apiToFormFieldMapping.entries
            .firstWhere((entry) => entry.value == formKey, orElse: () => MapEntry('', ''))
            .key;

        if (apiKey.isNotEmpty) {
          developer.log('Matched API key for $formKey: $apiKey', name: 'AccountInfo');

          // Get the value from the 'result' field of the API response
          final value = responseData[apiKey];
          if (value != null) {
            developer.log('Assigning value "$value" to controller for $formKey', name: 'AccountInfo');
            (field['controller'] as TextEditingController).text = value.toString();
          } else {
            developer.log('No value found for API key: $apiKey', name: 'AccountInfo');
          }
        } else {
          developer.log('No matching API key found for form key: $formKey', name: 'AccountInfo');
        }
      });

      notifyListeners();
    } catch (e, stackTrace) {
      Utils.flushBarErrorMessages('Failed to fetch account information.', context);
      developer.log('Error: $e\nStackTrace: $stackTrace', name: 'AccountInfo');
    } finally {
      setLoading(false);
    }
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
      'key': 'name',
      'label': 'Firm Name',
      'hint': 'Enter your firm name',
      'icon': Icons.business,
      'controller': TextEditingController(),
    },
    {
      'key': 'firmName',
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

      // Sanitize the country name by removing any extra spaces or emojis
      String sanitizedCountry = selectedCountry?.toString().replaceAll(RegExp(r'\s+'), '').replaceAll(RegExp(r'[^\x00-\x7F]'), '') ?? '';
      var body = {
        "jsonrpc": "2.0",
        "params": {
          "name": (formFields.firstWhere((field) => field['key'] == 'firmName')['controller'] as TextEditingController).text.trim(),
          "email": (formFields.firstWhere((field) => field['key'] == 'email')['controller'] as TextEditingController).text.trim(),
          "phone": (formFields.firstWhere((field) => field['key'] == 'phone')['controller'] as TextEditingController).text.trim(),
          "vat": (formFields.firstWhere((field) => field['key'] == 'gstNumber')['controller'] as TextEditingController).text.trim(),
          "street": (formFields.firstWhere((field) => field['key'] == 'address')['controller'] as TextEditingController).text.trim(),
          "street2": selectedCountry,  // Use street2 if available
          "city": selectedCity,
          "zipcode": (formFields.firstWhere((field) => field['key'] == 'zipCode')['controller'] as TextEditingController).text.trim(),
          "company_name":"ahex"
        }
      };

      // var body = {
      //   "jsonrpc": "2.0",
      //   "params": {
      //     "name": (formFields.firstWhere((field) => field['key'] == 'firmName')['controller'] as TextEditingController).text.trim(),
      //     "proprietor_name": (formFields.firstWhere((field) => field['key'] == 'proprietorName')['controller'] as TextEditingController).text.trim(),
      //     "email": (formFields.firstWhere((field) => field['key'] == 'email')['controller'] as TextEditingController).text.trim(),
      //     "phone": (formFields.firstWhere((field) => field['key'] == 'phone')['controller'] as TextEditingController).text.trim(),
      //     "street": (formFields.firstWhere((field) => field['key'] == 'address')['controller'] as TextEditingController).text.trim(),
      //     "city": selectedCity,
      //     "zipcode": (formFields.firstWhere((field) => field['key'] == 'zipCode')['controller'] as TextEditingController).text.trim(),
      //     // "type": "delivery", // You can customize this if needed
      //     "country": sanitizedCountry,  // Use sanitized country
      //     "state": selectedState,
      //     "vat": (formFields.firstWhere((field) => field['key'] == 'gstNumber')['controller'] as TextEditingController).text.trim()
      //   }
      // };
      // Call the updateAccountPostApi method with the prepared body
      await updateAccountPostApi(jsonEncode(body), context, sessionId!);
    }
  }
  @override
  void dispose() {
    for (var field in formFields) {
      (field['controller'] as TextEditingController).dispose();
    }
    super.dispose();
  }

}
