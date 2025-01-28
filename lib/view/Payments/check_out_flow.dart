// lib/screens/checkout/checkout_flow_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:towanto/view/Cart/cart_screen.dart';
import 'package:towanto/view/Payments/order_confirmation_screen.dart';
import '../../utils/common_widgets/PreferencesHelper.dart';
import '../../utils/common_widgets/Utils.dart';
import '../../utils/resources/colors.dart';
import '../../utils/resources/fonts.dart';
import '../../viewModel/CartViewModels/cart_list_view_model.dart';
import 'check_out_review_screen.dart';
import 'checkout_address_screen.dart';
import 'checkout_payment_screen.dart';

class CheckoutFlowScreen extends StatefulWidget {
  const CheckoutFlowScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutFlowScreen> createState() => _CheckoutFlowScreenState();
}

class _CheckoutFlowScreenState extends State<CheckoutFlowScreen> with AutomaticKeepAliveClientMixin {
  late Razorpay _razorpay;
  late dynamic selectedPayment;
  
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,_handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    // TODO: implement initState
    super.initState();
  }

  dynamic amount;
  dynamic name;
  dynamic phone;
  Future<void> getPaymentInformation() async {
    amount=(await PreferencesHelper.getString("Amount"))!;
    name=(await PreferencesHelper.getString("name"))!;
    phone= (await PreferencesHelper.getString("phone"))!;
    print("dwdwcec"+amount.toString());
  }
  Future<void> _openCheckout() async {
    // Retrieve and print the saved values
    var savedAmount = await PreferencesHelper.getString("Amount");
    final savedName = await PreferencesHelper.getString("name");
    final savedPhone = await PreferencesHelper.getString("phone");
    print("wex"+savedPhone.toString());
    print("wex"+savedAmount.toString());
    print("wex"+savedAmount.toString());
    print("before"+savedAmount.toString());
      savedAmount=savedAmount!*100;
    print("after$savedAmount");

    var options = {
      'key': 'rzp_test_2lEuQlBezOWwMq', // Replace with your Test/Live API Key
      'amount': savedAmount, // Amount in smallest currency unit (e.g., 50000 = 500 INR)
      'name': savedName.toString(),
      'description': 'Test Payment',
      'prefill': {
        'contact': savedPhone.toString(),
        'email': 'test@example.com',
      },
      'theme': {'color': '#59A8EB'},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    // Do something when payment succeeds
    debugPrint('Payment Successful: ${response.paymentId}');
    await PreferencesHelper.saveString("selectedPaymentMethod","");

    Navigator.push(context, MaterialPageRoute(builder: (context) => OrderConfirmationScreen(),));
  }

  Future<void> _handlePaymentError(PaymentFailureResponse response) async {
    // Do something when payment fails
    debugPrint('Payment Failed: ${response.code} | ${response.message}');
    await PreferencesHelper.saveString("selectedPaymentMethod","");

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Payment Failed: ${response.message}"),
    ));
  }

  Future<void> _handleExternalWallet(ExternalWalletResponse response) async {
    // Handle external wallet options
    debugPrint('External Wallet: ${response.walletName}');
    await PreferencesHelper.saveString("selectedPaymentMethod","");

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("External Wallet: ${response.walletName}"),
    ));
  }


  @override
  void dispose() {
    _razorpay.clear();
    _pageController.dispose();
// Dispose Razorpay when not in use
    super.dispose();
  }

  int _currentStep = 1;
  final PageController _pageController = PageController(initialPage: 0);

  String? selectedPaymentMethod;

  void _handleStepChange(int step) {
    print("Step Change: " + step.toString());

    if (step == 2) {
      if (CheckoutAddressScreenState.billingAddress.isEmpty && CheckoutAddressScreenState.shippingAddress.isEmpty) {
       Utils.flushBarErrorMessages("Please provide both billing and shipping addresses before proceeding.", context);
        return;
      }
      else if (CheckoutAddressScreenState.billingAddress.isEmpty) {
        Utils.flushBarErrorMessages("Please provide billing addresses before proceeding", context);
        return;
      }
      else if (CheckoutAddressScreenState.shippingAddress.isEmpty) {
        Utils.flushBarErrorMessages("Please provide shipping addresses before proceeding", context);
        return;
      }
    }
    if (step == 3) {
      if (CheckoutPaymentScreenState.selectedPaymentMethod == null || CheckoutPaymentScreenState.selectedPaymentMethod!.isEmpty) {
        Utils.flushBarErrorMessages("Please select a payment method before proceeding.", context);
        return;
      }
    }

    // If validation passes, proceed with step change
    if (step >= 1 && step <= 3) {
      setState(() {
        _currentStep = step;
      });
      _pageController.animateToPage(
        step - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }



  Future<void> _handlePlaceOrder() async {

    selectedPayment= await PreferencesHelper.getString("selectedPaymentMethod");
    print("ewcdsdd"+selectedPaymentMethod.toString());
    if(selectedPayment=="Online Payment"){
      await getPaymentInformation();
      _openCheckout();
    }
    else if(selectedPayment==""){
      Utils.flushBarErrorMessages("please select payment method", context);
    }
    else{
      Navigator.push(context, MaterialPageRoute(builder: (context) => OrderConfirmationScreen(),));
    }
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
                  CheckOutReviewScreen(),
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