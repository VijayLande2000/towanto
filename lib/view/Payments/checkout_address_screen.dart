// lib/screens/checkout_address_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:towanto/view/ManageAddress/add_address_screen.dart';
import 'package:towanto/view/ManageAddress/edit_address_screen.dart';
import 'package:towanto/view/Payments/payment_edit_address_screen.dart';
import 'package:towanto/view/Payments/select_address_screen.dart';
import 'package:towanto/viewModel/CartViewModels/cart_list_view_model.dart';

import '../../model/Address_Models/payment_address_model.dart';
import '../../utils/common_widgets/PreferencesHelper.dart';
import '../../utils/common_widgets/Utils.dart';
import '../../utils/resources/colors.dart';
import '../../utils/resources/fonts.dart';
import '../../viewModel/Address_ViewModels/get_Address_list_view_model.dart';

class CheckoutAddressScreen extends StatefulWidget {
  const CheckoutAddressScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutAddressScreen> createState() => CheckoutAddressScreenState();
}

class CheckoutAddressScreenState extends State<CheckoutAddressScreen>with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    billingAddress.clear();
    shippingAddress.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<GetAddressViewModel>(context, listen: false);
      await provider.getAddressList(context);
      if (provider.addresses.isNotEmpty) {
        // Iterate through the addresses
        for (var element in provider.addresses) {
          // Check for invoice address and add only the first one
          if (element.type == "billing" && billingAddress.isEmpty) {
            billingAddress = {
              'title': 'Billing Address',
              'city': element.city ?? '',
              'firm_name': element.proprietorName ?? '',
              'street': element.street ?? '',
              'state': element.stateName ?? '',
              'country': element.countryName ?? '',
              'zipcode': element.zipcode ?? '',
              'phone': element.phone?.toString() ?? '',
              'addressId': element.id?.toString() ?? '',
              'name': element.firmName?.toString() ?? '',
              'email': element.email?.toString() ?? '',
              // 'vat': element.vat?.toString() ?? '',
              'type': element.type?.toString() ?? '',
            };
          }
          // Check for delivery address and add only the first one
          else if (element.type == "shipping" && shippingAddress.isEmpty) {
            shippingAddress = {
              'title': 'Shipping Address',
              'city': element.city ?? '',
              'firm_name': element.proprietorName ?? '',
              'street': element.street ?? '',
              'state': element.stateName ?? '',
              'country': element.countryName ?? '',
              'zipcode': element.zipcode ?? '',
              'phone': element.phone?.toString() ?? '',
              'addressId': element.id?.toString() ?? '',
              'name': element.firmName?.toString() ?? '',
              'email': element.email?.toString() ?? '',
              // 'vat': element.vat?.toString() ?? '',
              'type': element.type?.toString() ?? '',
            };
          }

          // Break out of the loop after setting both addresses
          if (billingAddress.isNotEmpty && shippingAddress.isNotEmpty) {
            break;
          }
        }

        // Update the state after processing the addresses
        setState(() {});

        // Save the address IDs to preferences
        if (billingAddress.isNotEmpty) {
          await PreferencesHelper.saveString("billing_id", billingAddress['addressId'] ?? '');
        }
        if (shippingAddress.isNotEmpty) {
          await PreferencesHelper.saveString("shipping_id", shippingAddress['addressId'] ?? '');
        }
      }
    });
    // TODO: implement initState
    print("billingAddress length"+ billingAddress.length.toString() );
    print("shippingAddress length"+ shippingAddress.length.toString() );
    super.initState();

  }

  int currentStep = 1;

  static Map<String, dynamic> billingAddress = {};

  static Map<String, dynamic> shippingAddress = {};

  void navigateToStep(int step) {
    setState(() {
      currentStep = step;
    });
  }

  void updateAddress(String type, Map<String, dynamic> newAddress) {
    setState(() {
      if (type == 'Billing Address') {
        billingAddress = {...billingAddress, ...newAddress};
      } else {
        shippingAddress = {...shippingAddress, ...newAddress};
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundcolormenu,
      body: Consumer<GetAddressViewModel>(builder:
          (BuildContext context, GetAddressViewModel value, Widget? child) {
        if (value.loading) {
          return Center(
            child: Utils.loadingIndicator(context),
          );
        } else {
          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // buildStepper(),
                          // const SizedBox(height: 24),
                          billingAddress.isEmpty?_addNewAddressButton("Add Billing Address"):
                          AddressCard(
                            title: 'Billing Address',
                            icon: Icons.credit_card,
                            borderColor: Colors.green,
                            address: "${billingAddress['street']}, ${billingAddress['city']}, ${billingAddress['state']}, ${billingAddress['country']}, ${billingAddress['zipcode']}",
                            contact: billingAddress['phone'].toString(),
                            email: billingAddress['email'].toString(),
                            onEdit: () => _handleEdit(context, billingAddress,"Billing Address"),
                            onChangeAddress: () => ({_handleChangeAddress(context, billingAddress, 'Billing Address',)
                            }) /* _handleChangeAddress(
                                context, billingAddress, 'Billing Address')*/
                            ,
                          ),
                          const SizedBox(height: 16),
                          shippingAddress.isEmpty?_addNewAddressButton("Add Shipping Address"):
                          AddressCard(
                            title: 'Shipping Address',
                            icon: Icons.local_shipping,
                            borderColor: Colors.blue,
                            address:
                                "${shippingAddress['street']}, ${shippingAddress['city']}, ${shippingAddress['state']}, ${shippingAddress['country']}, ${shippingAddress['zipcode']}",
                            contact: shippingAddress['phone'].toString(),
                            email: shippingAddress['email'].toString(),
                            onEdit: () => _handleEdit(context, shippingAddress,"Shipping Address"),
                            // Fix the syntax here
                            onChangeAddress: () => _handleChangeAddress(
                                context, shippingAddress, 'Shipping Address'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // const SizedBox(height: 16),
                // buildBottomSection(),
              ],
            ),
          );
        }
      }),
    );

  }

  Widget _addNewAddressButton(String label) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => AddAddressInfoScreen(from: "CheckOutAddressScreen",),));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.brightBlue,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add, color:AppColors.whiteColor,),
          SizedBox(width: 8),
          Text(
            label.toString(),
            style: TextStyle(
                fontSize: 16,
                color:  AppColors.whiteColor,
                fontWeight: FontWeight.bold,
                fontFamily: MyFonts.font_regular
            ),
          ),
        ],
      ),
    );
  }


  Future<void> _handleEdit(BuildContext context, Map<String, dynamic> address, String type) async {
    try {
      final PaymentAddressModel? result = await Navigator.push<PaymentAddressModel>(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentEditAddressScreen(addressData: address),
        ),
      );

      if (result != null) {
        // Log address details for debugging
        debugPrint('Address Details:');
        debugPrint('Address ID: ${result.addressId}');
        debugPrint('Name: ${result.name}');
        debugPrint('Proprietor Name: ${result.proprietorName}');
        debugPrint('Email: ${result.email}');
        debugPrint('Phone: ${result.phone}');
        debugPrint('Street: ${result.street}');
        debugPrint('City: ${result.city}');
        debugPrint('Zipcode: ${result.zipcode}');
        debugPrint('Type: ${result.type}');
        debugPrint('Country: ${result.country}');
        debugPrint('State: ${result.state}');
        // debugPrint('VAT: ${result.vat}');

        // Create formatted address map
        final formattedAddress = {
          'title': type,
          'street': result.street ?? '',
          'state': result.state ?? '',
          'country': result.country ?? '',
          'city': result.city ?? '',
          'zipcode': result.zipcode ?? '',
          'phone': result.phone ?? '',
          'addressId': result.addressId ?? '',
          'firm_name': result.name ?? '',
          'name': result.proprietorName ?? '',
          'email': result.email ?? '',
          'type': result.type ?? '',
          // 'vat': result.vat ?? '',
        };

        debugPrint('Formatted Address: $formattedAddress');
        debugPrint('Formatted Address type: $type');

        // Update address in state
        updateAddress(type, formattedAddress);

        // Save address ID to SharedPreferences
        if (type == "Billing Address") {
          await PreferencesHelper.saveString("billing_id", formattedAddress['addressId'].toString());
          debugPrint('Billing ID updated: ${formattedAddress['addressId']}');
        } else if (type == "Shipping Address") {
          await PreferencesHelper.saveString("shipping_id", formattedAddress['addressId'].toString());
          debugPrint('Shipping ID updated: ${formattedAddress['addressId']}');
        }
      } else {
        debugPrint('No address data returned');
      }
    } catch (e) {
      debugPrint('Error handling address edit: $e');
      // You might want to show an error message to the user here
    }
  }

// Update the _handleChangeAddress function to properly handle the address update:
  Future<void> _handleChangeAddress(
      BuildContext context,
      Map<String, dynamic> currentAddress,
      String type,
      ) async {
    try {
      final PaymentAddressModel? result = await Navigator.push<PaymentAddressModel>(
        context,
        MaterialPageRoute(
          builder: (context) => SelectAddressScreen(
            currentAddress: currentAddress,
            type: type,
          ),
        ),
      );

      debugPrint('Selected Address Result: ${result.toString()}');

      if (result != null) {
        // Create formatted address map using the model properties
        final formattedAddress = {
          'title': type,
          'street': result.street ?? '',
          'state': result.state ?? '',
          'country': result.country ?? '',
          'zipcode': result.zipcode ?? '',
          'phone': result.phone ?? '',  // Changed from result['contact']
          'addressId': result.addressId ?? '',
          'name': result.name ?? '',
          'email': result.email ?? '',
        };

        debugPrint('Formatted Address: $formattedAddress');

        // Update address in state
        updateAddress(type, formattedAddress);

        // Save address ID to SharedPreferences
        if (type == "Billing Address") {
          await PreferencesHelper.saveString("billing_id", formattedAddress['addressId'].toString());
          debugPrint('Billing ID updated: ${formattedAddress['addressId']}');
        } else if (type == "Shipping Address") {
          await PreferencesHelper.saveString("shipping_id", formattedAddress['addressId'].toString());
          debugPrint('Shipping ID updated: ${formattedAddress['addressId']}');
        }
      } else {
        debugPrint('No address selected');
      }
    } catch (e) {
      debugPrint('Error handling address change: $e');
      // You might want to show an error message to the user here
    }
  }
  Widget buildStepper() {
    return Row(
      children: [
        _buildStepperItem('Address', 1),
        _buildStepperLine(currentStep > 1),
        _buildStepperItem('Payment', 2),
        _buildStepperLine(currentStep > 2),
        _buildStepperItem('Review', 3),
      ],
    );
  }

  Widget _buildStepperItem(String label, int step) {
    bool isActive = currentStep >= step;
    return Expanded(
      child: GestureDetector(
        onTap: () => navigateToStep(step),
        child: Column(
          children: [
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: isActive ? AppColors.brightBlue : AppColors.grey,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  step.toString(),
                  style: TextStyle(
                      fontSize: 14,
                      color: isActive
                          ? AppColors.whiteColor
                          : AppColors.tabtxt_color,
                      fontWeight: FontWeight.bold,
                      fontFamily: MyFonts.font_regular),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                  fontSize: 14,
                  color:
                      isActive ? AppColors.brightBlue : AppColors.tabtxt_color,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  fontFamily: MyFonts.font_regular),
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
        color: isActive ? AppColors.brightBlue : AppColors.grey,
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
                    fontFamily: MyFonts.font_regular),
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
                      fontFamily: MyFonts.font_regular,
                    ),
                  );
                },
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () => navigateToStep(currentStep + 1),
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
                  fontFamily: MyFonts.font_regular),
            ),
          ),
        ],
      ),
    );
  }
}

class AddressCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color borderColor;
  final String address;
  final String contact;
  final String email;
  final VoidCallback onEdit;
  final VoidCallback onChangeAddress;

  const AddressCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.borderColor,
    required this.address,
    required this.contact,
    required this.onEdit,
    required this.onChangeAddress,
    required this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(color: borderColor, width: 4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.black),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: 16,
                        color: AppColors.black,
                        fontWeight: FontWeight.w600,
                        fontFamily: MyFonts.font_regular),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    address,
                    style: TextStyle(
                        fontSize: 14,
                        color: AppColors.grey,
                        fontWeight: FontWeight.w500,
                        fontFamily: MyFonts.font_regular),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        'Contact: ',
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.black,
                          fontWeight: FontWeight.w500,
                          fontFamily: MyFonts.font_regular,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          contact,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.grey,
                            fontWeight: FontWeight.w500,
                            fontFamily: MyFonts.font_regular,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1, // Ensures it stays within one line
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        'Email: ',
                        style: TextStyle(
                            fontSize: 15,
                            color: AppColors.black,
                            fontWeight: FontWeight.w500,
                            fontFamily: MyFonts.font_regular),
                      ),
                      Expanded(
                        child: Text(
                          '$email',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.grey,
                            fontWeight: FontWeight.w500,
                            fontFamily: MyFonts.font_regular,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),

                    ],
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              color: AppColors.backgroundcolormenu,
              icon: Icon(Icons.more_vert, color: AppColors.black),
              onSelected: (value) {
                switch (value) {
                  case 'edit':
                    onEdit();
                    break;
                  case 'change':
                    onChangeAddress();
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit,
                        size: 18,
                        color: AppColors.black,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Edit',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: MyFonts.font_regular),
                      ),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'change',
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 18,
                        color: AppColors.black,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Change Address',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: MyFonts.font_regular),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
