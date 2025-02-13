import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import '../resources/colors.dart';
import '../resources/fonts.dart';

class Utils {
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

  static void flushBarErrorMessages(String? message, BuildContext context,
      {bool? isgreen}) {
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
        backgroundColor: isgreen != null ? Color(0xff50BFA8) : Colors.red,
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

  static void flushBarSuccessMessages(String? message, BuildContext context,
      {bool? isgreen}) {
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
        backgroundColor:
            isgreen != null ? AppColors.lightBlue : AppColors.lightBlue,
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

  static Widget loadingIndicator(BuildContext context,
      {double size = 50.0, double spacing = 2.0}) {
    return Center(
      child: SizedBox(
        height: size,
        width: size,
        child: SpinKitWave(
          size: size,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.brightBlue,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  static Widget buildDropdownButtonFormField({
    required String? value,
    required String? label,
    required Map<String, String> items,
    required Function(String?) onChanged,
    required Color backgroundcolor,
    String hintText = '',
  }) {
    bool isEmpty = items.isEmpty;

    // Ensure value is null if it doesn't exist in the items map
    String? selectedValue = items.containsKey(value) ? value : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toString(),
          style: const TextStyle(
            fontSize: 14,
            fontFamily: MyFonts.font_regular,
            fontWeight: FontWeight.w500,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
            border: Border.all(
              color: AppColors.grey.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: DropdownButtonFormField<String>(
            value: isEmpty ? null : selectedValue, // Ensure valid selection
            items: isEmpty
                ? null // No items, show only the hint
                : items.entries.map((MapEntry<String, String> entry) {
              return DropdownMenuItem<String>(
                value: entry.key,
                child: Text(
                  entry.value,
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 14,
                    fontFamily: MyFonts.font_regular,
                    fontWeight: FontWeight.w400,
                    height: 13.93 / 14.0,
                  ),
                ),
              );
            }).toList(),
            onChanged: isEmpty ? null : onChanged, // Disable dropdown if empty
            style: TextStyle(
              color: AppColors.black,
              fontSize: 14,
              fontFamily: MyFonts.font_regular,
              fontWeight: FontWeight.w400,
              height: 13.93 / 14.0,
            ),
            icon: Padding(
              padding: EdgeInsets.only(bottom: 24.0),
              child: const Icon(
                Icons.arrow_drop_down,
                color: AppColors.grey,
              ),
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: isEmpty ? "No options available" : hintText,
              hintStyle: TextStyle(
                color: AppColors.grey,
                fontSize: 14,
                fontFamily: MyFonts.font_regular,
                fontWeight: FontWeight.w400,
              ),
            ),
            isExpanded: true,
          ),
        ),
      ],
    );
  }





// Add other utility methods here
}
