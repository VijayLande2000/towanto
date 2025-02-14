
// screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:towanto/utils/resources/fonts.dart';
import 'package:towanto/utils/routes/route_names.dart';
import '../../../../../../viewModel/AuthViewModels/login_viewModel.dart';
import '../../utils/common_widgets/Utils.dart';
import '../../utils/resources/colors.dart';
import 'forgot_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: const LoginScreenContent(),
    );
  }
}

class LoginScreenContent extends StatelessWidget {
  const LoginScreenContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        // backgroundColor: AppColors.brightBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pushNamed(context, RoutesName.onBoardScreen)
        ),
        title: const Text(
          'Sign In',
          style: TextStyle(
            // color: AppColors.white,
            fontSize: 20,
            fontFamily: MyFonts.font_regular,
            fontWeight: FontWeight.w500
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Logo
                  Center(
                    child: SizedBox(
                      height: 100,
                      child: Image.asset(
                        "assets/images/ic_launcher_foreground.png", // Add your T-shaped logo here
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const LoginForm(),
                ],
              ),
            ),
          ),
            if(Provider.of<LoginViewModel>(context).loading)
            Utils.loadingIndicator(context),
        ],
      ),
      );

  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoginViewModel>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [

        // Email Field
        CustomTextField(
          controller: provider.emailController,
          label: 'Email Address*',
          hint: 'Enter your email address',
          onChanged: provider.validateEmail,
          errorText: provider.emailError,
          prefixIcon: Icons.email_outlined,

        ),
        const SizedBox(height: 24),
        // Password Field
        CustomTextField(
          controller: provider.passwordController,
          label: 'Password*',
          hint: 'Enter Your Password here',
          isPassword: true,
          onChanged: provider.validatePassword,
          errorText: provider.passwordError,
          isPasswordVisible: provider.isPasswordVisible,
          onVisibilityToggle: provider.togglePasswordVisibility,
          prefixIcon: Icons.lock_outline,
        ),
        const SizedBox(height: 16),
        // Forget Password
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordScreen(),));
            // Handle forgot password
          },
          child: const Text(
            'Forget Password ?',
            style: TextStyle(
              color: AppColors.red,
              fontFamily: MyFonts.font_regular,
              fontWeight: FontWeight.w500,
              fontSize: 14,

            ),
          ),
        ),
        const SizedBox(height: 32),
        // Login Button
        Utils.createButton(text: "Sign In", onClick: () {
          Utils.loadingIndicator(context);
          provider.handleLogin(context);
        })
       , const SizedBox(height: 24),
        // Sign Up Link
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Don't have an account? ",
                style: TextStyle(
                  color: AppColors.black,
                  fontFamily: MyFonts.font_regular,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, RoutesName.signup);
                  // Navigate to sign up screen
                },
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                    color: AppColors.red,
                    fontSize: 14,
                    fontFamily: MyFonts.font_regular,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),


            ],
          ),
        ),
      ],
    );
  }
}


class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool isPassword;
  final Function(String) onChanged;
  final String? errorText;
  final bool? isPasswordVisible;
  final VoidCallback? onVisibilityToggle;
  final IconData prefixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int maxLines;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.label,
    required this.hint,
    this.isPassword = false,
    required this.onChanged,
    this.errorText,
    this.isPasswordVisible,
    this.onVisibilityToggle,
    required this.prefixIcon,
    this.keyboardType,
    this.validator,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isPhoneField = _isPhoneNumberField(label, hint);
    final actualKeyboardType = keyboardType ?? _determineKeyboardType(label, hint);

    // Phone number specific input formatters
    final List<TextInputFormatter> phoneFormatters = [
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(15),  // Maximum 15 digits
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: MyFonts.font_regular,
            fontWeight: FontWeight.w500,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 8),
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
          child: TextFormField(
            controller: controller,
            obscureText: isPassword && !(isPasswordVisible ?? false),
            keyboardType: actualKeyboardType,
            maxLines: maxLines,
            inputFormatters: isPhoneField ? phoneFormatters : null,
            onChanged: (value) {
              if (isPhoneField) {
                // Additional phone number validation
                if (value.length <= 15) {
                  onChanged(value);
                }
              } else {
                onChanged(value);
              }
            },
            validator: (value) {
              if (validator != null) {
                return validator!(value);
              }
              if (isPhoneField) {
                if (value == null || value.isEmpty) {
                  return 'Phone number is required';
                }
                if (value.length < 10) {
                  return 'Phone number must be at least 10 digits';
                }
                if (value.length > 15) {
                  return 'Phone number cannot exceed 15 digits';
                }
              }
              return null;
            },
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontFamily: MyFonts.font_regular,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: AppColors.grey.withOpacity(0.7),
                fontSize: 14,
                fontFamily: MyFonts.font_regular,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: InputBorder.none,
              prefixIcon: Icon(
                prefixIcon,
                color: AppColors.cardcolor,
                size: 22,
              ),
              suffixIcon: isPassword
                  ? IconButton(
                icon: Icon(
                  isPasswordVisible ?? false
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: AppColors.grey,
                  size: 22,
                ),
                onPressed: onVisibilityToggle,
              )
                  : null,
              errorStyle: const TextStyle(
                height: 1.5,
                color: Colors.red,
                fontSize: 12,
                fontFamily: MyFonts.font_regular,
              ),
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              _capitalizeEachWord(errorText!),
              style: const TextStyle(
                color: AppColors.errorRed,
                fontSize: 12,
                fontFamily: MyFonts.font_regular,
              ),
            ),
          ),
      ],
    );
  }

  bool _isPhoneNumberField(String label, String hint) {
    List<String> phoneKeywords = ["phone", "mobile", "contact", "number", "Mobile*"];
    return phoneKeywords.any((word) =>
    label.toLowerCase().contains(word.toLowerCase()) ||
        hint.toLowerCase().contains(word.toLowerCase())
    );
  }

  TextInputType _determineKeyboardType(String label, String hint) {
    if (_isPhoneNumberField(label, hint)) {
      return TextInputType.phone;
    }
    return TextInputType.text;
  }

  String _capitalizeEachWord(String text) {
    return text
        .split(' ')
        .map((word) =>
    word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1)}' : '')
        .join(' ');
  }
}