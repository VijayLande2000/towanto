import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:towanto/utils/resources/fonts.dart';
import 'package:towanto/utils/resources/colors.dart';
import 'package:towanto/utils/common_widgets/Utils.dart';
import 'package:towanto/viewModel/Address_ViewModels/edit_address_view_model.dart';

import '../../viewModel/Address_ViewModels/add_address_view_model.dart';
import '../../viewModel/Address_ViewModels/get_Address_list_view_model.dart';
import '../../viewModel/profileViewModels/update_account_information_view_model.dart';
import '../Auth/login_screen.dart';

class PaymentEditAddressScreen extends StatefulWidget {
  final Map<String, dynamic> addressData;

  const PaymentEditAddressScreen({
    Key? key,
    required this.addressData,
  }) : super(key: key);

  @override
  State<PaymentEditAddressScreen> createState() => _PaymentEditAddressScreenState();
}

class _PaymentEditAddressScreenState extends State<PaymentEditAddressScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditAddressViewModel(),
      // Pass the addressData to PaymentEditAddressScreenContent
      child: PaymentEditAddressScreenContent(
          addressData: widget.addressData),
    );
  }
}

class PaymentEditAddressScreenContent extends StatefulWidget {
  final Map<String, dynamic>? addressData;

  PaymentEditAddressScreenContent({
    super.key,
    this.addressData,
  });

  @override
  State<PaymentEditAddressScreenContent> createState() =>
      _PaymentEditAddressScreenContentState();
}

class _PaymentEditAddressScreenContentState extends State<PaymentEditAddressScreenContent> {
  String? selectedCountry;
  String? selectedState;
  String? selectedCity;
  dynamic selectedCountryId;
  dynamic selectedStateId;
  @override
  void initState() {
    super.initState();
    print("dbfhbvhv" + widget.addressData!['addressId'].toString());

    // Use Future.microtask to avoid calling Provider during build
    Future.microtask(() async {
      if (widget.addressData != null) {
        widget.addressData?.forEach((key, value) {
          print("key = "+key);
          print("value = "+value.toString());
        });
        final provider = Provider.of<EditAddressViewModel>(context, listen: false);
        provider.stateMap.clear();
        provider.countryMap.clear();
        await provider.getCountries(context);
        // Pre-fill form fields
        provider.formFields.forEach((field) {
          switch (field['key']) {
            case 'firmName':
              field['controller'].text = widget.addressData!['name'] ?? '';
              break;
            case 'name':
              field['controller'].text = widget.addressData!['firm_name'] ?? '';
              break;
            // case 'name':
            //   field['controller'].text =
            //       widget.addressData!['proprietor_name'] ?? '';
            //   break;
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
            // case 'vat':
            //   field['controller'].text = widget.addressData!['vat'] ?? '';
            //   break;
              case 'city':
              field['controller'].text = widget.addressData!['city'] ?? '';
              break;
          }
        });

        selectedCountry = widget.addressData!['country'];
        print("dsfdcds"+selectedCountry.toString());
        selectedCountryId = provider.countryMap.keys.firstWhere(
              (key) => provider.countryMap[key] == selectedCountry,
          orElse: () => "",
        );

        await provider.getStates(context, selectedCountryId);
        selectedState = widget.addressData!['state'];
        selectedStateId = provider.stateMap.keys.firstWhere(
              (key) => provider.stateMap[key] == selectedState,
          orElse: () => "",
        );

        print("the selected country :${selectedCountry}");
        print("the selected country :${selectedCountryId}");
        // Pre-fill location fields
        setState(() {
          // selectedCountry = widget.addressData!['country'];
          // selectedState = widget.addressData!['state'];
          // selectedCity = widget.addressData!['city'];
          selectedOption = widget.addressData!['type'];
        });
        print("erh"+selectedOption.toString());
      }
    });
  }
  String? selectedOption;

  final List<String> options = [
    'billing',
    'shipping',
  ];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EditAddressViewModel>(context);
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        // backgroundColor: AppColors.brightBlue,
        title: Text(
          "Edit Address",
          style: TextStyle(
            fontSize: 20,
            // color: AppColors.black,
            fontWeight: FontWeight.bold,
            fontFamily: MyFonts.font_regular,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,  size: 20),
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
                  SizedBox(
                    height: 12.0,
                  ),

                  // In your build method
                  Utils.buildDropdownButtonFormField(
                      value: selectedCountryId,
                      items: provider.countryMap,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCountryId = newValue;
                          // Since we're selecting a new country, clear dependent fields
                          provider.stateMap.clear();
                          selectedState = null;
                          selectedCountry=provider.countryMap[newValue];

                          print("Selected Country Name: ${provider.countryMap[newValue]}"); // Print the country name
                          print("Selected Country Name: $selectedCountry"); // Print the country name
                        });

                        // Get states using the country ID (key)
                        if (newValue != null) {
                          // newValue is already the key/ID since we set it as the value in DropdownMenuItem
                          provider.getStates(context, newValue);
                        }
                      },
                      backgroundcolor: AppColors.whiteColor,
                      hintText: 'Select Country',
                      label: 'Country'
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  Utils.buildDropdownButtonFormField(
                      value: selectedStateId,
                      items: provider.stateMap,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedStateId = newValue;
                          selectedState=provider.stateMap[newValue];
                          print("Selected state Name: ${provider.stateMap[newValue]}"); // Print the country name
                          print("Selected state Name: $selectedState"); // Print the country name
                        });

                        // Get states using the country ID (key)
                        if (newValue != null) {
                          // newValue is already the key/ID since we set it as the value in DropdownMenuItem
                          // value.getStates(context, newValue);
                        }
                      },
                      backgroundcolor: AppColors.whiteColor,
                      hintText: 'Select State',
                      label: 'State'
                  ),
                  SizedBox(
                    height: 12.0,
                  ),

                  CustomDropdownField(
                    label: 'Type',
                    items: options,
                    selectedValue: selectedOption,
                    hint: 'Choose one',
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value;
                      });
                    },
                  ),
                  SizedBox(height: 12.0,),
                  // Country State City Picker
                  // Container(
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     borderRadius: BorderRadius.circular(30),
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: Colors.grey.withOpacity(0.1),
                  //         spreadRadius: 1,
                  //         blurRadius: 10,
                  //         offset: const Offset(0, 4),
                  //       ),
                  //     ],
                  //   ),
                  //   padding: const EdgeInsets.symmetric(horizontal: 20),
                  //   child: SizedBox(
                  //     height: 180,
                  //     child: Theme(
                  //       data: Theme.of(context).copyWith(
                  //         textTheme: Theme.of(context).textTheme.copyWith(
                  //               titleMedium: const TextStyle(
                  //                 fontFamily: MyFonts.font_Bold,
                  //                 color: AppColors.cardcolor,
                  //                 fontSize: 14,
                  //               ),
                  //             ),
                  //       ),
                  //       child: SelectState(
                  //         onCountryChanged: (country) {
                  //           setState(() => selectedCountry = country);
                  //         },
                  //         onStateChanged: (state) {
                  //           setState(() => selectedState = state);
                  //         },
                  //         onCityChanged: (city) {
                  //           setState(() => selectedCity = city);
                  //         },
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  const SizedBox(height: 20),

                  Utils.createButton(
                      text: "update Address",
                      onClick: () async {
                        print("sdced"+widget.addressData!['addressId'].toString());
                        provider.submitAccountInfo(
                            context,
                            selectedCountry,
                            selectedState,
                            widget.addressData!['addressId'].toString(),
                            "back",
                            selectedOption??""
                        );
                      }),
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
class CustomDropdownField extends StatelessWidget {
  final String label;
  final String? selectedValue;
  final List<String> items;
  final Function(String?) onChanged;
  final String? hint;

  const CustomDropdownField({
    Key? key,
    required this.label,
    required this.items,
    this.selectedValue,
    required this.onChanged,
    this.hint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
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
        // Dropdown Container
        Container(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
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
              color
                  : AppColors.grey.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedValue,
              hint: Text(
                hint ?? "Select",
                style: TextStyle(
                  color: AppColors.grey.withOpacity(0.7),
                  fontSize: 14,
                  fontFamily: MyFonts.font_regular,
                ),
              ),
              isExpanded: true,
              icon: const Icon(
                Icons.arrow_drop_down,
                color: AppColors.grey,
              ),
              onChanged: onChanged,
              items: items.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: MyFonts.font_regular,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
