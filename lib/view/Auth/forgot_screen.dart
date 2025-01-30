import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:towanto/utils/resources/colors.dart';
import 'package:towanto/utils/resources/fonts.dart';

import '../../utils/common_widgets/Utils.dart';
import '../../viewModel/AuthViewModels/forgot_view_model.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ForgotPasswordViewModel(),
      child: const ForgotPasswordScreenContent(),
    );
  }
}

class ForgotPasswordScreenContent extends StatelessWidget {
  const ForgotPasswordScreenContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ForgotPasswordViewModel>(context);

    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        // backgroundColor: AppColors.brightBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Forgot Password',
          style: TextStyle(
            // color: AppColors.white,
            fontSize: 20,
            fontFamily: MyFonts.LexendDeca_Bold,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Enter your email address to receive a password reset link',
              style: TextStyle(
                fontSize: 16,
                fontFamily: MyFonts.LexendDeca_Bold,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: provider.emailController,
              label: 'Email Address*',
              hint: 'Enter your email address',
              onChanged: provider.validateEmail,
              errorText: provider.emailError,
              prefixIcon: Icons.email_outlined,

            ),
            const SizedBox(height: 32),
            Utils.  createButton(text: "Send Email Reset Password", onClick: (){
              provider.sendPasswordResetEmail(context);

            })
        ],
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final Function(String) onChanged;
  final String? errorText;
  final IconData prefixIcon;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.onChanged,
    this.errorText,
    required this.prefixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: MyFonts.LexendDeca_Bold,
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
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: AppColors.grey.withOpacity(0.7),
                fontSize: 14,
                fontFamily: MyFonts.LexendDeca_Bold,
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
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              errorText!,
              style: const TextStyle(
                color: AppColors.errorRed,
                fontSize: 12,
                fontFamily: MyFonts.Lexenddeca_regular,
              ),
            ),
          ),
      ],
    );
  }
}