import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:towanto/utils/common_widgets/Utils.dart';
import 'package:towanto/viewModel/AuthViewModels/de_activate_account_view_model.dart';

import '../../utils/resources/colors.dart';
import '../../utils/resources/fonts.dart';

class CustomPopupDialog extends StatefulWidget {
  final Function(String email, String password) onConfirm;

  const CustomPopupDialog({Key? key, required this.onConfirm})
      : super(key: key);

  @override
  _CustomPopupDialogState createState() => _CustomPopupDialogState();
}

class _CustomPopupDialogState extends State<CustomPopupDialog> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void deActivateAccountApiCall() {
    final provider =
        Provider.of<DeactivateAccountViewModel>(context, listen: false);
    provider.deactivateAccountApiCall(
        context, _emailController.text, _passwordController.text);
  }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
        deActivateAccountApiCall();
      }
    }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.red,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.backgroundcolormenu,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Details',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: MyFonts.font_regular,
              ),
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
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
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Email',
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
                          Icons.email,
                          color: AppColors.cardcolor,
                          size: 22,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
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
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Password',
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
                          Icons.lock,
                          color: AppColors.cardcolor,
                          size: 22,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: AppColors.grey,
                      fontSize: 16,
                      fontFamily: MyFonts.font_regular,
                    ),
                  ),
                ),
                Consumer<DeactivateAccountViewModel>(
                  builder: (context, viewModel, child) {
                    return ElevatedButton(
                      onPressed: viewModel.loading
                          ? null
                          : () {
                        _handleSubmit();
                      },
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        backgroundColor: AppColors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: viewModel.loading
                          ? SizedBox(
                        height: 20,
                          child: Center(child: Utils.loadingIndicator(context))) // Wrap in Center
                      : Text(
                              'Confirm',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: MyFonts.font_regular,
                                color: AppColors.whiteColor,
                              ),
                            ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Usage example:
void showLoginPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => CustomPopupDialog(
      onConfirm: (email, password) async {
        // Make your API call here
        await Future.delayed(Duration(seconds: 2)); // Simulated API call
        print('Email: $email, Password: $password');
      },
    ),
  );
}

// Your gradient button implementation
class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onClick;

  const GradientButton({
    Key? key,
    required this.text,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [
            AppColors.brightBlue,
            AppColors.lightBlue,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB24592).withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onClick,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: MyFonts.font_regular,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
