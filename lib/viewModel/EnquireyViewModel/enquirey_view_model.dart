import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:towanto/utils/repositories/EnquireyRepositories/enquirey_repository.dart';
import 'dart:developer' as developer;

import '../../utils/common_widgets/PreferencesHelper.dart';
import '../../utils/common_widgets/Utils.dart';

class EnquiryViewModel extends ChangeNotifier {


  final _myRepo = EnquireyRepository();
  late BuildContext context;
  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    developer.log('Loading state changed to: $_loading', name: 'EnquiryViewModel');
    notifyListeners();
  }

  Future<void> enquireyPostApi(dynamic data, BuildContext context,String sessionId) async {
    try {
      this.context = context;
      setLoading(true);
      developer.log('Starting login process with data: ${jsonEncode(data)}', name: 'EnquiryViewModel');

      final value = await _myRepo.enquireyApiResponse(data, context,sessionId);
      developer.log('enquirey API response received: ${value.toString()}', name: 'EnquiryViewModel');


    } catch (e, stackTrace) {
      developer.log(
          'Error during enquirey process',
          name: 'EnquiryViewModel',
          error: e.toString(),
          stackTrace: stackTrace
      );
      // You might want to show an error message to the user here
    } finally {
      setLoading(false);
    }
  }


  // Controllers and Fields
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController requirementController = TextEditingController();

  // Form fields configuration
  late final List<Map<String, dynamic>> formFields = [
    {
      'key': 'firmName',
      'label': 'Firm Name*',
      'hint': 'Enter your first name',
      'controller': firstNameController,
      'icon': Icons.person_outline,
    },
    {
      'key': 'lastName',
      'label': 'Last Name*',
      'hint': 'Enter your last name',
      'controller': lastNameController,
      'icon': Icons.person_outline,
    },
    {
      'key': 'mobile',
      'label': 'Mobile*',
      'hint': 'Enter your mobile number',
      'controller': mobileController,
      'icon': Icons.phone_outlined,
    },
    {
      'key': 'email',
      'label': 'Email*',
      'hint': 'Enter your email address',
      'controller': emailController,
      'icon': Icons.email_outlined,
    },
    {
      'key': 'address',
      'label': 'Address*',
      'hint': 'Enter your address',
      'controller': addressController,
      'icon': Icons.home_outlined,
    },
    {
      'key': 'subject',
      'label': 'Subject*',
      'hint': 'Enter the subject',
      'controller': subjectController,
      'icon': Icons.subject,
    },
    {
      'key': 'requirement',
      'label': 'Requirement*',
      'hint': 'Enter your requirement',
      'controller': requirementController,
      'icon': Icons.note_outlined,
    },
  ];

  // Error messages
  final Map<String, String?> errors = {
    'firstName': null,
    'lastName': null,
    'mobile': null,
    'email': null,
    'address': null,
    'subject': null,
    'requirement': null,
  };

  // Loading state
  bool loading2 = false;

  // Validation rules
  void validateField(String key) {
    final controller = formFields.firstWhere((field) => field['key'] == key)['controller'] as TextEditingController;
    final value = controller.text.trim();

    if (value.isEmpty) {
      errors[key] = "$key cannot be empty";
    } else if (key == 'mobile' && value.length < 10) {
      errors[key] = "Enter a valid mobile number";
    } else if (key == 'email' && !RegExp(r"^[^@]+@[^@]+\.[^@]+").hasMatch(value)) {
      errors[key] = "Enter a valid email address";
    } else {
      errors[key] = null;
    }
    notifyListeners();
  }

  // Submit form
  Future<void> submitEnquiry(BuildContext context) async {
    for (final field in formFields) {
      validateField(field['key']);
    }

    if (errors.values.every((error) => error == null)) {
      loading2 = true;
      notifyListeners();

      final sessionId = await PreferencesHelper.getString("session_id");

      var body =
      {
        "params":
        {
          "firm_name": firstNameController.text.toString(),
          "name": lastNameController.text.toString(),
          "email": emailController.text.toString(),
          "mobile": mobileController.text.toString(),
          "address": addressController.text.toString(),
          "subject": subjectController.text.toString(),
          "requirement": requirementController.text.toString()
        }
      };
      var jsonBody = jsonEncode(body);
      await enquireyPostApi(jsonBody, context,sessionId!);

    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    mobileController.dispose();
    emailController.dispose();
    addressController.dispose();
    subjectController.dispose();
    requirementController.dispose();
    super.dispose();
  }
}
