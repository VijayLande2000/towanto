import 'package:flutter/material.dart';
import 'package:towanto/view/Home/home_screen.dart';
import 'package:towanto/view/Orders/orders_screen.dart';

import '../../utils/resources/colors.dart';
import '../../utils/resources/fonts.dart';

class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundcolormenu,
      appBar: AppBar(
        title: const Text(
          'Order Confirmation',
          style: TextStyle(
            fontFamily: MyFonts.LexendDeca_Bold,
            color: AppColors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        elevation: 0,
        backgroundColor: AppColors.brightBlue,
          automaticallyImplyLeading: false,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.grey.shade50],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Image
                  Container(
                    margin: EdgeInsets.only(right: 24,bottom: 24),
                    width: MediaQuery.sizeOf(context).width*0.6, // Adjust size as needed
                    // height: MediaQuery.sizeOf(context).height*0.4,// Adjust size as needed
                    child:Image.asset("assets/images/orderplaced.jpg"),

                  ),
                  Text(
                    'Your Order has been accepted',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: AppColors.appBarTitleTextColor,
                      fontFamily: MyFonts.LexendDeca_SemiBold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your items has been placed and is on its way to being processed',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.grey,
                      fontFamily: MyFonts.Lexenddeca_regular,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
Navigator.push(context, MaterialPageRoute(builder: (context) => OrdersListScreen(),));                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.brightBlue,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Track Order',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColors.whiteColor,
                          fontFamily: MyFonts.LexendDeca_SemiBold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeGrid(),));
                    },
                    child: Text(
                      'Back to home',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: AppColors.grey,
                        fontFamily: MyFonts.LexendDeca_Bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}