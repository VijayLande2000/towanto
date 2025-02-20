import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:towanto/utils/repositories/AddressRepositories/add_address_repository.dart';
import 'package:towanto/utils/repositories/ProfileRepositories/update_account_repository.dart';
import 'dart:developer' as developer;
import '../../model/Address_Models/get_all_countrys_model.dart';
import '../../model/Address_Models/payment_address_model.dart';
import '../../utils/common_widgets/PreferencesHelper.dart';
import '../../utils/common_widgets/Utils.dart';
import '../../utils/repositories/AddressRepositories/edit_address_repository.dart';
import '../../utils/repositories/AddressRepositories/get_countries_list_repository.dart';
import '../../utils/repositories/AddressRepositories/get_states_list_repository.dart';

class EditAddressViewModel extends ChangeNotifier {
  final _myRepo = EditAddressRepository();
  late BuildContext context;
  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    developer.log('Loading state changed to: $_loading',
        name: 'EditAddressViewModel');
    notifyListeners();
  }

  Future<void> editAddressPostApi(dynamic data, BuildContext context,
      String sessionId, String navigateTo, PaymentAddressModel formData) async {
    try {
      this.context = context;
      setLoading(true);
      developer.log('Starting edit process with data: ${jsonEncode(data)}',
          name: 'EditAddressViewModel');

      final value = await _myRepo.editAddressListApiResponse(
          data, context, sessionId, navigateTo, formData);
      developer.log('Account API response received: ${value.toString()}',
          name: 'EditAddressViewModel');
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
      'key': 'name',
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
    // {
    //   'key': 'vat',
    //   'label': 'GST Number',
    //   'hint': 'Enter your GST Number',
    //   'icon': Icons.business_center,
    //   'controller': TextEditingController(),
    // },
    {
      'key': 'city',
      'label': 'city',
      'hint': 'Enter your city Name',
      'icon': Icons.location_city,
      'controller': TextEditingController(),
    },

  ];

  // Errors map for validation messages
  Map<String, String?> errors = {};

  // Validation for each field
  void validateField(String key) {
    final controller =
        formFields.firstWhere((field) => field['key'] == key)['controller']
            as TextEditingController;
    final value = controller.text.trim();

    if (value.isEmpty) {
      errors[key] = "This field cannot be empty";
    } else if (key == 'email' &&
        !RegExp(r"^[^@]+@[^@]+\.[^@]+").hasMatch(value)) {
      errors[key] = "Enter a valid email address";
    } else if (key == 'phone' && value.length < 10) {
      errors[key] = "Enter a valid phone number";
    } else {
      errors[key] = null;
    }
    notifyListeners();
  }

  // Dynamic validation for country, state, and city
  void validateLocationFields(
      dynamic selectedCountry, dynamic selectedState, BuildContext context) {
    if (selectedCountry == null || selectedCountry.isEmpty) {
      Utils.flushBarErrorMessages(
          "Country  or state  cannot be empty", context);
      errors['country'] = "Country cannot be empty";
    } else {
      errors['country'] = null;
    }

    if (selectedState == null || selectedState.isEmpty) {
      Utils.flushBarErrorMessages("Country  or state cannot be empty", context);
      errors['state'] = "State cannot be empty";
    } else {
      errors['state'] = null;
    }
    notifyListeners();
  }

  // Submit method with dynamic country, state, and city validation
  Future<void> submitAccountInfo(
    BuildContext context,
    dynamic selectedCountry,
    dynamic selectedState,
    dynamic addressId,
    dynamic navigateTo,
    String type,
  ) async {
    // Validate all fields
    for (final field in formFields) {
      validateField(field['key']);
    }
    print("FYUDG" + navigateTo.toString());
    // Validate country, state, and city dynamically
    validateLocationFields(selectedCountry, selectedState, context);

    // Check if all fields are valid
    if (errors.values.every((error) => error == null)) {
      setLoading(true);
      final sessionId = await PreferencesHelper.getString("session_id");

      // Construct the body as per the required format
      var body = {
        "params": {
          "address_id":
              int.tryParse(addressId), // Convert the addressId to an integer
          "firm_name": (formFields.firstWhere(
                      (field) => field['key'] == 'firmName')['controller']
                  as TextEditingController)
              .text
              .trim(),
          "name": (formFields.firstWhere((field) =>
                      field['key'] == 'name')['controller']
                  as TextEditingController)
              .text
              .trim(),
          "email": (formFields.firstWhere(
                      (field) => field['key'] == 'email')['controller']
                  as TextEditingController)
              .text
              .trim(),
          "phone": (formFields.firstWhere(
                      (field) => field['key'] == 'phone')['controller']
                  as TextEditingController)
              .text
              .trim(),
          "street": (formFields.firstWhere(
                      (field) => field['key'] == 'address')['controller']
                  as TextEditingController)
              .text
              .trim(),
          "city": (formFields.firstWhere(
                      (field) => field['key'] == 'city')['controller']
                  as TextEditingController)
              .text
              .trim(), // Ensure you are passing the correct value for city
          "zipcode": (formFields.firstWhere(
                      (field) => field['key'] == 'zipCode')['controller']
                  as TextEditingController)
              .text
              .trim(),
          "type": type, // Change to "delivery" if needed dynamically
          "country":
              selectedCountry, // Ensure you are passing the correct value for country
          "state":
              selectedState, // Ensure you are passing the correct value for state
          // "vat": (formFields.firstWhere(
          //             (field) => field['key'] == 'vat')['controller']
          //         as TextEditingController)
          //     .text
          //     .trim(),
        }
      };

      try {
        PaymentAddressModel formData =
          PaymentAddressModel(
            addressId: int.tryParse(addressId) ??
                0, // Convert addressId to integer, default to 0 if null
            name: (formFields.firstWhere((field) => field['key'] == 'name',
                    orElse: () => {
                          'controller': TextEditingController()
                        })['controller'] as TextEditingController)
                .text
                .trim(),
            proprietorName: (formFields.firstWhere(
                    (field) => field['key'] == 'firmName',
                    orElse: () => {
                          'controller': TextEditingController()
                        })['controller'] as TextEditingController)
                .text
                .trim(),
            email: (formFields.firstWhere((field) => field['key'] == 'email',
                    orElse: () => {
                          'controller': TextEditingController()
                        })['controller'] as TextEditingController)
                .text
                .trim(),
            phone: (formFields.firstWhere((field) => field['key'] == 'phone',
                    orElse: () => {
                          'controller': TextEditingController()
                        })['controller'] as TextEditingController)
                .text
                .trim(),
            street: (formFields.firstWhere((field) => field['key'] == 'address',
                    orElse: () => {
                          'controller': TextEditingController()
                        })['controller'] as TextEditingController)
                .text
                .trim(),
            city: (formFields.firstWhere((field) => field['key'] == 'city',
                    orElse: () => {
                          'controller': TextEditingController()
                        })['controller'] as TextEditingController)
                .text
                .trim(),
            zipcode: (formFields.firstWhere(
                    (field) => field['key'] == 'zipCode',
                    orElse: () => {
                          'controller': TextEditingController()
                        })['controller'] as TextEditingController)
                .text
                .trim(),
            type: type ?? "delivery", // Default to "delivery" if null
            country: selectedCountry ?? '',
            state: selectedState ?? '',
            // vat: (formFields.firstWhere((field) => field['key'] == 'vat',
            //         orElse: () => {
            //               'controller': TextEditingController()
            //             })['controller'] as TextEditingController)
            //     .text
            //     .trim(),
          );


        await editAddressPostApi(
            jsonEncode(body), context, sessionId!, navigateTo, formData);
      } finally {
        setLoading(false);
      }
    }
  }

  final _countriesRepo = GetCountriesRepository();
  final _statesRepo = GetAllStatesRepository();
// Maps to store country and state data
  Map<String, String> countryMap = {}; // id : name
  Map<String, String> stateMap = {}; // id : name

// edit_address_view_model.dart
  Future<void> getCountries(BuildContext context) async {
    try {
      _loading = true;
      notifyListeners();

      final sessionId = await PreferencesHelper.getString("session_id");
      final response = await _countriesRepo.getCountriesListApiResponse(context,
          sessionId: sessionId);

      countryMap.clear();

      // Map the countries to the countryMap
      for (var country in response.countries) {
        countryMap[country.id.toString()] = country.name;
      }

      developer.log('Loaded countries: ${countryMap.length}',
          name: 'EditAddressViewModel');
    } catch (e) {
      developer.log('Error fetching countries: $e',
          name: 'EditAddressViewModel');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> getCountriesforSignUp(BuildContext context) async {
    try {
      _loading = true;
      notifyListeners();

      final response =
          await _countriesRepo.getCountriesListApiResponse(context);

      countryMap.clear();

      // Map the countries to the countryMap
      for (var country in response.countries) {
        countryMap[country.id.toString()] = country.name;
      }

      developer.log('Loaded countries: ${countryMap.length}',
          name: 'EditAddressViewModel');
    } catch (e) {
      developer.log('Error fetching countries: $e',
          name: 'EditAddressViewModel');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

// In your ViewModel
// In ViewModel
  Future<void> getStates(BuildContext context, String countryId) async {
    try {
      // _loading = true;
      notifyListeners();

      final sessionId = await PreferencesHelper.getString("session_id");
      final response = await _statesRepo.getAllStatesListApiResponse(
          countryId, context,
          sessionId: sessionId);

      stateMap.clear();

      // Map the states to stateMap
      for (var state in response.states) {
        stateMap[state.id.toString()] = state.name;
      }

      developer.log('Loaded states: ${stateMap.length}',
          name: 'EditAddressViewModel');
    } catch (e) {
      developer.log('Error fetching states: $e', name: 'EditAddressViewModel');
    } finally {
      // _loading = false;
      notifyListeners();
    }
  }
}
