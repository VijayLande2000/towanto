import 'dart:convert';

import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:towanto/viewModel/AuthViewModels/sign_up_viewModel.dart';

import '../../utils/common_widgets/Utils.dart';
import '../../utils/resources/colors.dart';
import '../../utils/resources/fonts.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _proprietorNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _phoneController = TextEditingController();
  final _gstNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  // Field touch tracking
  bool _firstNameTouched = false;
  bool _lastNameTouched = false;
  bool _proprietorNameTouched = false;
  bool _emailTouched = false;
  bool _addressTouched = false;
  bool _phoneTouched = false;
  bool _gstNumberTouched = false;
  bool _passwordTouched = false;
  bool _confirmPasswordTouched = false;
  bool _submitAttempted = false;

  // Location data
  String? selectedCountry;
  String? selectedState;
  String? selectedCity;

  // File picking
  String? gstFileName;
  bool termsAccepted = false;

  // Email validation regex
  final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  // Password validation regex patterns
  final RegExp hasUppercase = RegExp(r'[A-Z]');
  final RegExp hasLowercase = RegExp(r'[a-z]');
  final RegExp hasNumber = RegExp(r'[0-9]');
  final RegExp hasSpecialChar = RegExp(r'[!@#\$&*~]');

  // Validate email
  String? validateEmail(String? value) {
    if ((_emailTouched || _submitAttempted) &&
        (value == null || value.isEmpty)) {
      return 'Please enter an email address';
    }
    if ((_emailTouched || _submitAttempted) && !emailRegex.hasMatch(value!)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  // Validate password
  String? validatePassword(String? value) {
    if ((_passwordTouched || _submitAttempted) &&
        (value == null || value.isEmpty)) {
      return 'Please enter a password';
    }

    if ((_passwordTouched || _submitAttempted) && value!.length < 8) {
      return 'Password must be at least 8 characters long';
    }

    if ((_passwordTouched || _submitAttempted)) {
      List<String> requirements = [];

      if (!hasUppercase.hasMatch(value!)) {
        requirements.add('uppercase letter');
      }
      if (!hasLowercase.hasMatch(value)) {
        requirements.add('lowercase letter');
      }
      if (!hasNumber.hasMatch(value)) {
        requirements.add('number');
      }
      if (!hasSpecialChar.hasMatch(value)) {
        requirements.add('special character');
      }

      if (requirements.isNotEmpty) {
        return 'Password must contain ${requirements.join(", ")}';
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        // backgroundColor: AppColors.brightBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Sign Up',
          style: TextStyle(
            // color: AppColors.white,
            fontSize: 20,
            fontFamily: MyFonts.font_Bold,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInputField(
                      controller: _firstNameController,
                      hint: 'First Name',
                      prefixIcon: Icons.person_outline,
                      validator: (value) =>
                      (_firstNameTouched || _submitAttempted) &&
                          (value == null || value.isEmpty)
                          ? 'Please enter first name'
                          : null,
                      onChanged: (value) =>
                          setState(() => _firstNameTouched = true),
                    ),
                    const SizedBox(height: 20),

                    _buildInputField(
                      controller: _lastNameController,
                      hint: 'Last Name',
                      prefixIcon: Icons.person_outline,
                      validator: (value) =>
                      (_lastNameTouched || _submitAttempted) &&
                          (value == null || value.isEmpty)
                          ? 'Please enter last name'
                          : null,
                      onChanged: (value) => setState(() => _lastNameTouched = true),
                    ),
                    const SizedBox(height: 20),

                    _buildInputField(
                      controller: _proprietorNameController,
                      hint: 'Proprietor Name',
                      prefixIcon: Icons.business_center_outlined,
                      validator: (value) =>
                      (_proprietorNameTouched || _submitAttempted) &&
                          (value == null || value.isEmpty)
                          ? 'Please enter proprietor name'
                          : null,
                      onChanged: (value) =>
                          setState(() => _proprietorNameTouched = true),
                    ),
                    const SizedBox(height: 20),
// Update the email field validation in _buildInputField calls:
                    _buildInputField(
                      controller: _emailController,
                      hint: 'Email Address',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: validateEmail,
                      onChanged: (value) => setState(() => _emailTouched = true),
                    ),
                    const SizedBox(height: 20),
                    // Update the password field validation:
                    _buildInputField(
                      controller: _passwordController,
                      hint: 'Password',
                      prefixIcon: Icons.lock_outline,
                      isPassword: true,
                      validator: validatePassword,
                      onChanged: (value) => setState(() => _passwordTouched = true),
                    ),
                    const SizedBox(height: 20),
                    // Update confirm password validation to match the new password requirements:
                    _buildInputField(
                      controller: _confirmPasswordController,
                      hint: 'Confirm Password',
                      prefixIcon: Icons.lock_outline,
                      isPassword: true,
                      validator: (value) =>
                      (_confirmPasswordTouched || _submitAttempted) &&
                          (value != _passwordController.text)
                          ? 'Passwords do not match'
                          : null,
                      onChanged: (value) =>
                          setState(() => _confirmPasswordTouched = true),
                    ),
                    const SizedBox(height: 20),

                    _buildInputField(
                      controller: _phoneController,
                      hint: 'Phone Number',
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validator: (value) => (_phoneTouched || _submitAttempted) &&
                          (value == null || value.length < 10)
                          ? 'Please enter valid phone number'
                          : null,
                      onChanged: (value) => setState(() => _phoneTouched = true),
                    ),
                    const SizedBox(height: 20),
                    _buildInputField(
                      controller: _addressController,
                      hint: 'Street Address',
                      prefixIcon: Icons.location_on_outlined,
                      maxLines: 1,
                      validator: (value) => (_addressTouched || _submitAttempted) &&
                          (value == null || value.isEmpty)
                          ? 'Please enter address'
                          : null,
                      onChanged: (value) => setState(() => _addressTouched = true),
                    ),
                    const SizedBox(height: 20),

                    // Country State Picker
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        height: 180, // Increase or adjust height as needed
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            textTheme: Theme.of(context).textTheme.copyWith(
                              titleMedium: const TextStyle(
                                fontFamily: MyFonts.font_Bold,
                                color: AppColors.cardcolor,
                                fontSize: 14, // Adjusted font color
                              ),
                            ),
                          ),
                          child: SelectState(
                            onCountryChanged: (country) {
                              setState(() => selectedCountry = country);
                            },
                            onStateChanged: (state) {
                              setState(() => selectedState = state);
                            },
                            onCityChanged: (city) {
                              setState(() => selectedCity = city);
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    _buildInputField(
                      controller: _gstNumberController,
                      hint: 'GST Number',
                      prefixIcon: Icons.receipt_outlined,
                      validator: (value) =>
                      (_gstNumberTouched || _submitAttempted) &&
                          (value == null || value.length < 15)
                          ? 'Please enter valid GST number'
                          : null,
                      onChanged: (value) =>
                          setState(() => _gstNumberTouched = true),
                    ),
                    const SizedBox(height: 20),

                    // GST File Upload
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextButton.icon(
                        icon: const Icon(Icons.upload_file,
                            color: AppColors.cardcolor),
                        label: Text(
                          gstFileName ?? 'Upload GST Document',
                          style: TextStyle(
                              fontFamily: MyFonts.font_Bold,
                              color: AppColors.cardcolor),
                        ),
                        onPressed: _pickGSTFile,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Terms and Conditions
                    CheckboxListTile(
                      value: termsAccepted,
                      onChanged: (value) {
                        setState(() => termsAccepted = value ?? false);
                      },
                      title: const Text(
                        'I accept the terms and conditions',
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: MyFonts.font_Bold,
                            color: AppColors.cardcolor),
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                      activeColor: AppColors.primaryGreen,
                    ),
                    const SizedBox(height: 30),

                    Utils.createButton(
                      text: 'Sign Up',
                      onClick: _handleSubmit,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          if(Provider.of<SignUpViewModel>(context).loading)
            Utils.loadingIndicator(context),
        ],
      )
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData prefixIcon,
    bool isPassword = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    Function(String)? onChanged,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: maxLines == 1
              ? 56
              : 88, // Fixed height for single/multi line fields
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextFormField(
              controller: controller,
              obscureText: isPassword
                  ? (hint == 'Password'
                      ? !_passwordVisible
                      : !_confirmPasswordVisible)
                  : false,
              keyboardType: keyboardType,
              maxLines: maxLines,
              validator: (_) => null,
              onChanged: onChanged,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                    color: AppColors.grey,
                    fontSize: 16,
                    fontFamily: MyFonts.font_Bold),
                prefixIcon: Icon(
                  prefixIcon,
                  color: AppColors.cardcolor,
                  size: 22,
                ),
                suffixIcon: isPassword
                    ? IconButton(
                        icon: Icon(
                          hint == 'Password'
                              ? (_passwordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility)
                              : (_confirmPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                          color: AppColors.cardcolor,
                        ),
                        onPressed: () {
                          setState(() {
                            if (hint == 'Password') {
                              _passwordVisible = !_passwordVisible;
                            } else {
                              _confirmPasswordVisible =
                                  !_confirmPasswordVisible;
                            }
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                errorStyle:
                    const TextStyle(height: 0, color: Colors.transparent),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                isDense: true, // Makes the field more compact
              ),
            ),
          ),
        ),
        if (validator != null)
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 4),
            child: Builder(
              builder: (context) {
                final String? error = validator(controller.text);
                return error != null &&
                        (_submitAttempted ||
                            controller == _firstNameController &&
                                _firstNameTouched ||
                            controller == _lastNameController &&
                                _lastNameTouched ||
                            controller == _proprietorNameController &&
                                _proprietorNameTouched ||
                            controller == _emailController && _emailTouched ||
                            controller == _passwordController &&
                                _passwordTouched ||
                            controller == _confirmPasswordController &&
                                _confirmPasswordTouched ||
                            controller == _phoneController && _phoneTouched ||
                            controller == _addressController &&
                                _addressTouched ||
                            controller == _gstNumberController &&
                                _gstNumberTouched)
                    ? Text(
                        error,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontFamily: MyFonts.font_Bold,
                        ),
                      )
                    : const SizedBox.shrink();
              },
            ),
          ),
        SizedBox(height: validator != null ? 12 : 20), // Adjusted spacing
      ],
    );
  }

  Future<void> _pickGSTFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      setState(() {
        gstFileName = result.files.first.name;
      });
    }
  }

  Future<void> _handleSubmit() async {
    setState(() => _submitAttempted = true);

    if (!termsAccepted) {
      Utils.flushBarErrorMessages('Please accept the terms and conditions', context);
      return;
    }

    if (selectedCountry == null || selectedState == null || selectedCity == null) {
      Utils.flushBarErrorMessages('Please select country,state and city', context);
      return;
    }

    if (gstFileName == null) {
        Utils.flushBarErrorMessages('Please upload GST document', context);
      return;
    }

    if (_formKey.currentState!.validate()) {
      final auth = Provider.of<SignUpViewModel>(context, listen: false);
      var body = {
        "jsonrpc": "2.0",
        "params": {
          "name": _firstNameController.text.toString() +
              " " +
              _lastNameController.text.toString(),
          "email": _emailController.text,
          "password": _passwordController.text,
          "phone": _phoneController.text,
          "company": _proprietorNameController.text,
          "gst": _gstNumberController.text,
          "address": _addressController.text,
          "city": selectedCity,
          "state": selectedState,
          "country": selectedCountry,
        }
      };
      if (_firstNameController.text.isNotEmpty &&
          _lastNameController.text.isNotEmpty &&
          _proprietorNameController.text.isNotEmpty &&
          _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _phoneController.text.isNotEmpty &&
          _addressController.text.isNotEmpty &&
          _gstNumberController.text.isNotEmpty &&
          selectedCity != null &&
          selectedState != null &&
          selectedCountry != null) {
        var jsonBody = jsonEncode(body);
        await auth.signUpApi(jsonBody, context);
      }

      // Handle form submission
      print('Form is valid - proceed with signup');
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _proprietorNameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _phoneController.dispose();
    _gstNumberController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
