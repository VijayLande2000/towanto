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


class AddAddressInfoScreen extends StatelessWidget {
  final String? from; // Optional String parameter

   AddAddressInfoScreen({Key? key, this.from,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddAddressViewModel(),
      child:  AddAddressInfoScreenContent(from:from),
    );
  }
}

class AddAddressInfoScreenContent extends StatefulWidget {
  final String? from; // Optional String parameter

  const AddAddressInfoScreenContent({Key? key, this.from,}) : super(key: key);

  @override
  State<AddAddressInfoScreenContent> createState() => _AddAddressInfoScreenContentState();
}

class _AddAddressInfoScreenContentState extends State<AddAddressInfoScreenContent> {
  String? selectedCountry;
  String? selectedState;
  String? selectedCity;
  String? selectedOption;


  dynamic selectedCountryId;
  dynamic selectedStateId;



  Future<void> getCountries() async {
    final provider = Provider.of<EditAddressViewModel>(context, listen: false);
    provider.stateMap.clear();
    provider.countryMap.clear();
    await provider.getCountries(context);
  }
  @override
  void initState() {

    getCountries();
    // TODO: implement initState
    super.initState();
  }

  String? errorText; // Add this variable to track the error

  final List<String> options = ['billing', 'shipping'];

  void validateDropDown() {
    if (selectedOption == null) {
      setState(() {
        errorText = 'Please select an option'; // Show error
      });
    } else {
      setState(() {
        errorText = null; // Clear error

      });
      print("Selected option: $selectedOption");
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AddAddressViewModel>(context);
    final editViewModel = Provider.of<EditAddressViewModel>(context);
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        // backgroundColor: AppColors.brightBlue,
        title: Text(
          "Add Address",
          style: TextStyle(
            fontSize: 20,
            // color: AppColors.black,
            fontWeight: FontWeight.bold,
            fontFamily: MyFonts.font_regular,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 20),
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
                  const SizedBox(height: 20),
                  Utils.buildDropdownButtonFormField(
                      value: selectedCountryId,
                      items: editViewModel.countryMap,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCountryId = newValue;
                          // Since we're selecting a new country, clear dependent fields
                          editViewModel.stateMap.clear();
                          selectedState = null;
                          selectedCountry=editViewModel.countryMap[newValue];

                          print("Selected Country Name: ${editViewModel.countryMap[newValue]}"); // Print the country name
                          print("Selected Country Name: $selectedCountry"); // Print the country name
                        });

                        // Get states using the country ID (key)
                        if (newValue != null) {
                          // newValue is already the key/ID since we set it as the value in DropdownMenuItem
                          editViewModel.getStates(context, newValue);
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
                      items: editViewModel.stateMap,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedStateId = newValue;
                          selectedState=editViewModel.stateMap[newValue];
                          print("Selected state Name: ${editViewModel.stateMap[newValue]}"); // Print the country name
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
                  // // Country State City Picker
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
                  //           titleMedium: const TextStyle(
                  //             fontFamily: MyFonts.font_Bold,
                  //             color: AppColors.cardcolor,
                  //             fontSize: 14,
                  //           ),
                  //         ),
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
                  CustomDropdownField(
                    label: 'Type',
                    items: options,
                    selectedValue: selectedOption,
                    hint: 'Choose one',
                    errorText: errorText,
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),

                  Utils.createButton(
                    text: "Add Address",
                    onClick: () => {
                      validateDropDown(),
                      if(selectedOption!=null){
                        provider.submitAccountInfo(context, selectedCountry, selectedState, selectedCity,selectedOption!,widget.from),
                      }
                    }
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



class CustomDropdownField extends StatelessWidget {
  final String label;
  final String? selectedValue;
  final String? errorText;
  final List<String> items;
  final Function(String?) onChanged;
  final String? hint;

  const CustomDropdownField({
    Key? key,
    required this.label,
    required this.items,
    this.selectedValue,
    this.errorText,
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
              color: errorText != null
                  ? AppColors.errorRed
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
        // Error Text
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              errorText!,
              style: const TextStyle(
                color: AppColors.errorRed,
                fontSize: 12,
                fontFamily: MyFonts.font_regular,
              ),
            ),
          ),
      ],
    );
  }
}
