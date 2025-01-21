// lib/screens/checkout/checkout_flow_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:towanto/view/Cart/cart_screen.dart';
import '../../utils/resources/colors.dart';
import '../../utils/resources/fonts.dart';
import '../../viewModel/CartViewModels/cart_list_view_model.dart';
import 'checkout_address_screen.dart';
import 'checkout_payment_screen.dart';

class CheckoutFlowScreen extends StatefulWidget {
  const CheckoutFlowScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutFlowScreen> createState() => _CheckoutFlowScreenState();
}

class _CheckoutFlowScreenState extends State<CheckoutFlowScreen> {
  int _currentStep = 1;
  final PageController _pageController = PageController(initialPage: 0);

  // Store data across screens
  Map<String, dynamic> billingAddress = {};
  Map<String, dynamic> shippingAddress = {};
  String? selectedPaymentMethod;

  void _handleStepChange(int step) {
    if (step >= 1 && step <= 3) {
      setState(() {
        _currentStep = step;
        print("dfcdbvc"+_currentStep.toString());
      });
      _pageController.animateToPage(
        step - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _handleAddressSelection(Map<String, dynamic> billing, Map<String, dynamic> shipping) {
    setState(() {
      billingAddress = billing;
      shippingAddress = shipping;
      _handleStepChange(2); // Move to payment step
    });

  }

  void _handlePaymentSelection(String method) {
    setState(() {
      selectedPaymentMethod = method;
      _handleStepChange(3); // Move to review step
    });
  }

  void _handlePlaceOrder() {
    // Handle order placement logic
    print('Placing order with:');
    print('Billing Address: $billingAddress');
    print('Shipping Address: $shippingAddress');
    print('Payment Method: $selectedPaymentMethod');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_currentStep > 1) {
          _handleStepChange(_currentStep - 1);
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundcolormenu,
        appBar: AppBar(
          backgroundColor: AppColors.brightBlue,
          title: Text(
            _getScreenTitle(),
            style: TextStyle(
              fontSize: 20,
              color: AppColors.black,
              fontWeight: FontWeight.bold,
              fontFamily: MyFonts.LexendDeca_Bold,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.black, size: 20),
            onPressed: () {
              if (_currentStep > 1) {
                _handleStepChange(_currentStep - 1);
              } else {
                Navigator.pop(context);
              }
            },
          ),
        ),
        body: Column(
          children: [
            _buildStepper(),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics:  NeverScrollableScrollPhysics(),
                children: [
                  CheckoutAddressScreen(),
                  CheckoutPaymentScreen(),
                  Container(child: Center(child: Text('Review Screen'))), // Placeholder
                ],
              ),
            ),
            buildBottomSection(),
          ],
        ),
      ),
    );
  }

  String _getScreenTitle() {
    switch (_currentStep) {
      case 1:
        return "Address";
      case 2:
        return "Payment Method";
      case 3:
        return "Order Review";
      default:
        return "Checkout";
    }
  }

  Widget _buildStepper() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildStepperItem('Address', 1, Icons.location_on),
          _buildStepperLine(_currentStep > 1),
          _buildStepperItem('Payment', 2, Icons.payment),
          _buildStepperLine(_currentStep > 2),
          _buildStepperItem('Review', 3, Icons.check_circle),
        ],
      ),
    );
  }

  void _moveToNextStep() {
    if (_currentStep < 3) {
      // If not at the last step, move to the next step
      _handleStepChange(_currentStep + 1);
    } else {
      // Final step action
      _handlePlaceOrder(); // Place the order or execute final action
    }
  }


  Widget _buildStepperItem(String label, int step, IconData icon) {
    bool isActive = _currentStep >= step;
    bool isCurrent = _currentStep == step;

    return Expanded(
      child: GestureDetector(
        onTap: () => _handleStepChange(step),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isActive ? AppColors.brightBlue : Colors.grey[200],
                shape: BoxShape.circle,
                border: isCurrent ? Border.all(color: AppColors.brightBlue, width: 2) : null,
                boxShadow: isCurrent ? [
                  BoxShadow(
                    color: AppColors.brightBlue.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  )
                ] : null,
              ),
              child: Icon(
                icon,
                color: isActive ? Colors.white : Colors.grey,
                size: 20,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: isActive ? AppColors.brightBlue : Colors.grey,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                fontFamily: MyFonts.LexendDeca_Bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepperLine(bool isActive) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isActive
                ? [AppColors.brightBlue, AppColors.brightBlue]
                : [Colors.grey[300]!, Colors.grey[300]!],
          ),
        ),
      ),
    );
  }
  Widget buildBottomSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey[300]!),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Amount to be paid',
                style: TextStyle(
                    fontSize: 16,
                    color: AppColors.grey,
                    fontWeight: FontWeight.w500,
                    fontFamily: MyFonts.Lexenddeca_regular),
              ),
              const SizedBox(height: 4),
              Consumer<CartListViewModel>(
                builder: (context, viewModel, child) {
                  return Text(
                    '₹ ${viewModel.totalAmount.toStringAsFixed(2)}', // Formats the amount to two decimal places
                    style: TextStyle(
                      fontSize: 24,
                      color: AppColors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: MyFonts.LexendDeca_Bold,
                    ),
                  );
                },
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {

              _moveToNextStep();
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: AppColors.brightBlue,
              shadowColor: Colors.green.withOpacity(0.3),
              elevation: 5,
            ),
            child: const Text(
              'Proceed',
              style: TextStyle(
                  fontSize: 16,
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: MyFonts.LexendDeca_Bold),
            ),
          ),
        ],
      ),
    );
  }

}