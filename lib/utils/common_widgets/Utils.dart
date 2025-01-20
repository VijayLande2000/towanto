import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';

import '../resources/colors.dart';

class Utils {

  // static Widget customTextField({
  //   required String hint,
  //   required TextEditingController controller,
  //   bool isPassword = false,
  //   String? Function(String?)? validator,
  //   TextInputType keyboardType = TextInputType.text,
  // }) {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(vertical: 8),
  //     child: TextFormField(
  //       controller: controller,
  //       obscureText: isPassword,
  //       keyboardType: keyboardType,
  //       validator: validator,
  //       decoration: InputDecoration(
  //         hintText: hint,
  //         filled: true,
  //         fillColor: AppColors.whiteColor,
  //         border: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(12),
  //           borderSide: BorderSide(color: Colors.grey.shade300),
  //         ),
  //         enabledBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(12),
  //           borderSide: BorderSide(color: Colors.grey.shade300),
  //         ),
  //         focusedBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(12),
  //           borderSide: const BorderSide(color: Colors.green),
  //         ),
  //         suffixIcon: isPassword
  //             ? IconButton(
  //           icon: const Icon(Icons.visibility),
  //           onPressed: () {
  //             // Implement password visibility toggle
  //           },
  //         )
  //             : null,
  //       ),
  //     ),
  //   );
  // }


  // static String? validateEmail(String? email) {
  //   if (email == null || email.isEmpty) {
  //     return 'Please enter an email address';
  //   }
  //   final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  //   return emailRegex.hasMatch(email) ? null : 'Please enter a valid email';
  // }
  //
  // static String? validatePassword(String? password) {
  //   if (password == null || password.isEmpty) {
  //     return 'Please enter a password';
  //   }
  //   if (password.length < 6) {
  //     return 'Password must be at least 6 characters';
  //   }
  //   return null;
  // }
  //
  // static String? validateConfirmPassword(String? confirmPassword, String password) {
  //   if (confirmPassword == null || confirmPassword.isEmpty) {
  //     return 'Please confirm your password';
  //   }
  //   return confirmPassword == password ? null : 'Passwords do not match';
  // }
  //
  // static String? validateName(String? name, String fieldName) {
  //   if (name == null || name.isEmpty) {
  //     return 'Please enter your $fieldName';
  //   }
  //   return null;
  // }


  static Widget createButton({
    required String text,
    required VoidCallback onClick,
  }) {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [
            AppColors.brightBlue,
            AppColors.lightBlue,
            // Color(0xFF00875A),
            // Color(0xFF36B37E),
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


  static void flushBarErrorMessages(String? message, BuildContext context,{bool?isgreen}) {
    showFlushbar(
      context: context,
      flushbar: Flushbar(
        forwardAnimationCurve: Curves.decelerate,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(15),
        message: message,
        borderRadius: BorderRadius.circular(5),
        flushbarPosition: FlushbarPosition.TOP,
        duration: const Duration(seconds: 3),
        backgroundColor: isgreen!=null?Color(0xff50BFA8):Colors.red,
        reverseAnimationCurve: Curves.easeInOut,
        positionOffset: 20,
        icon: const Icon(
          Icons.error_outline,
          size: 28,
          color: Colors.white,
        ),
      )..show(context),
    );
  }

  static void flushBarSuccessMessages(String? message, BuildContext context,{bool?isgreen}) {
    showFlushbar(
      context: context,
      flushbar: Flushbar(
        forwardAnimationCurve: Curves.decelerate,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(15),
        message: message,
        borderRadius: BorderRadius.circular(5),
        flushbarPosition: FlushbarPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        backgroundColor: isgreen!=null?AppColors.lightBlue:AppColors.lightBlue,
        reverseAnimationCurve: Curves.easeInOut,
        positionOffset: 20,
        icon: const Icon(
          Icons.error_outline,
          size: 28,
          color: Colors.white,
        ),
      )..show(context),
    );
  }

  static Widget loadingIndicator(BuildContext context,{Color color =AppColors.brightBlue, double size = 50.0}) {
    return Center(
      child: SizedBox(
        height: size,
        width: size,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ),
    );
  }


// Add utility methods here

}



