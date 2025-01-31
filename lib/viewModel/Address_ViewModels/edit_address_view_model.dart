import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:towanto/utils/repositories/AddressRepositories/add_address_repository.dart';
import 'package:towanto/utils/repositories/ProfileRepositories/update_account_repository.dart';
import 'dart:developer' as developer;
import '../../utils/common_widgets/PreferencesHelper.dart';
import '../../utils/common_widgets/Utils.dart';
import '../../utils/repositories/AddressRepositories/edit_address_repository.dart';

class EditAddressViewModel extends ChangeNotifier {
  final _myRepo = EditAddressRepository();
  late BuildContext context;
  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    developer.log('Loading state changed to: $_loading', name: 'EditAddressViewModel');
    notifyListeners();
  }

  Future<void> editAddressPostApi(dynamic data, BuildContext context, String sessionId,String navigateTo,dynamic formData) async {
    try {
      this.context = context;
      setLoading(true);
      developer.log('Starting login process with data: ${jsonEncode(data)}', name: 'EditAddressViewModel');

      final value = await _myRepo.editAddressListApiResponse(data, context, sessionId,navigateTo,formData);
      developer.log('Account API response received: ${value.toString()}', name: 'EditAddressViewModel');
    } catch (e, stackTrace) {
      developer.log(
        'Error during account process',
        name: 'EditAddressViewModel',
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
  Future<void> submitAccountInfo(
      BuildContext context,
      dynamic selectedCountry,
      dynamic selectedState,
      dynamic selectedCity,
      dynamic addressId, dynamic navigateTo,
      String type,
      ) async {
    // Validate all fields
    for (final field in formFields) {
      validateField(field['key']);
    }
   print("FYUDG"+navigateTo.toString());
    // Validate country, state, and city dynamically
    validateLocationFields(selectedCountry, selectedState, selectedCity, context);

    // Check if all fields are valid
    if (errors.values.every((error) => error == null)) {
      setLoading(true);
      final sessionId = await PreferencesHelper.getString("session_id");

      // Construct the body as per the required format
      var body = {
        "params": {
          "address_id": int.tryParse(addressId), // Convert the addressId to an integer
          "name": (formFields.firstWhere((field) => field['key'] == 'firmName')['controller']
          as TextEditingController)
              .text
              .trim(),
          "firm_name": (formFields.firstWhere((field) => field['key'] == 'proprietorName')['controller']
          as TextEditingController)
              .text
              .trim(),
          "email": (formFields.firstWhere((field) => field['key'] == 'email')['controller']
          as TextEditingController)
              .text
              .trim(),
          "phone": (formFields.firstWhere((field) => field['key'] == 'phone')['controller']
          as TextEditingController)
              .text
              .trim(),
          "street": (formFields.firstWhere((field) => field['key'] == 'address')['controller']
          as TextEditingController)
              .text
              .trim(),
          "city": selectedCity, // Ensure you are passing the correct value for city
          "zipcode": (formFields.firstWhere((field) => field['key'] == 'zipCode')['controller']
          as TextEditingController)
              .text
              .trim(),
          "type": type, // Change to "delivery" if needed dynamically
          "country": selectedCountry, // Ensure you are passing the correct value for country
          "state": selectedState, // Ensure you are passing the correct value for state
          "vat": (formFields.firstWhere((field) => field['key'] == 'gstNumber')['controller']
          as TextEditingController)
              .text
              .trim(),
        }
      };

      try {
        final formData = {
          'address': '${(formFields.firstWhere((field) => field['key'] == 'address')['controller'] as TextEditingController).text}, '
              '${selectedCity ?? ''}\n'
              '${selectedState ?? ''}, ${selectedCountry ?? ''}\n'
              '${(formFields.firstWhere((field) => field['key'] == 'zipCode')['controller'] as TextEditingController).text}',
          'contact': (formFields.firstWhere((field) => field['key'] == 'phone')['controller'] as TextEditingController)
              .text
              .trim(),
          'name': (formFields.firstWhere((field) => field['key'] == 'firmName')['controller'] as TextEditingController)
              .text
              .trim(),
          'email': (formFields.firstWhere((field) => field['key'] == 'email')['controller'] as TextEditingController)
              .text
              .trim(),
          'addressId': addressId ?? '', // Include addressId if available
        };
        await editAddressPostApi(jsonEncode(body), context, sessionId!,navigateTo,formData);
      } finally {
        setLoading(false);
      }
    }
  }
}
