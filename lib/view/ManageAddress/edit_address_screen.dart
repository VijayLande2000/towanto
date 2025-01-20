import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:towanto/utils/resources/fonts.dart';
import 'package:towanto/utils/resources/colors.dart';
import 'package:towanto/utils/common_widgets/Utils.dart';
import 'package:towanto/viewModel/Address_ViewModels/edit_address_view_model.dart';

import '../../viewModel/Address_ViewModels/add_address_view_model.dart';
import '../../viewModel/profileViewModels/update_account_information_view_model.dart';
import '../Auth/login_screen.dart';


class EditAddressScreen extends StatefulWidget {
  final Map<String, dynamic> addressData;

  const EditAddressScreen({
    Key? key,
    required this.addressData,
  }) : super(key: key);

  @override
  State<EditAddressScreen> createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditAddressViewModel(),
      // Pass the addressData to EditAddressScreenContent
      child: EditAddressScreenContent(addressData: widget.addressData),
    );
  }
}
class EditAddressScreenContent extends StatefulWidget {
  final Map<String, dynamic>? addressData;

  const EditAddressScreenContent({
    Key? key,
    this.addressData,
  }) : super(key: key);

  @override
  State<EditAddressScreenContent> createState() => _EditAddressScreenContentState();
}

class _EditAddressScreenContentState extends State<EditAddressScreenContent> {
  String? selectedCountry;
  String? selectedState;
  String? selectedCity;

  @override
  void initState() {
    super.initState();

    // Use Future.microtask to avoid calling Provider during build
    Future.microtask(() {
      if (widget.addressData != null) {
        final provider = Provider.of<EditAddressViewModel>(context, listen: false);

        // Pre-fill form fields
        provider.formFields.forEach((field) {
          switch (field['key']) {
            case 'firmName':
              field['controller'].text = widget.addressData!['name'] ?? '';
              break;
            case 'proprietorName':
              field['controller'].text = widget.addressData!['company_name'] ?? '';
              break;
            case 'email':
              field['controller'].text = widget.addressData!['email'] ?? '';
              break;
            case 'address':
              field['controller'].text = widget.addressData!['street'] ?? '';
              break;
            case 'zipCode':
              field['controller'].text = widget.addressData!['zipcode'] ?? '';
              break;
            case 'phone':
              field['controller'].text = widget.addressData!['phone'] ?? '';
              break;
            case 'gstNumber':
              field['controller'].text = widget.addressData!['vat'] ?? '';
              break;
          }
        });
        // Pre-fill location fields
        setState(() {
          selectedCountry = widget.addressData!['country'];
          selectedState = widget.addressData!['state'];
          selectedCity = widget.addressData!['city'];
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EditAddressViewModel>(context);
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        backgroundColor: AppColors.brightBlue,
        title: Text(
          "Edit Address",
          style: TextStyle(
            fontSize: 20,
            color: AppColors.black,
            fontWeight: FontWeight.bold,
            fontFamily: MyFonts.LexendDeca_Bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.black, size: 20),
          onPressed: () => Navigator.pop(context),
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

                  // Form Fields
                  ...provider.formFields.map(
                        (field) => Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: CustomTextField(
                        controller: field['controller'],
                        label: field['label'],
                        hint: field['hint'],
                        onChanged: (_) => provider.validateField(field['key']),
                        errorText: provider.errors[field['key']],
                        prefixIcon: field['icon'],
                      ),
                    ),
                  ),

                  // Country State City Picker
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
                      height: 180,
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          textTheme: Theme.of(context).textTheme.copyWith(
                            titleMedium: const TextStyle(
                              fontFamily: MyFonts.LexendDeca_Bold,
                              color: AppColors.cardcolor,
                              fontSize: 14,
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

                  Utils.createButton(
                    text: "update Address",
                    onClick: () => provider.submitAccountInfo(context, selectedCountry, selectedState, selectedCity,widget.addressData!['addressId'].toString()),
                  ),

                ],
              ),
            ),
          ),

          if (provider.loading) Utils.loadingIndicator(context),
        ],
      ),
    );
  }
}
