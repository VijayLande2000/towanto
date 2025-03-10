import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:towanto/utils/resources/fonts.dart';
import 'package:towanto/utils/resources/colors.dart';
import 'package:towanto/utils/common_widgets/Utils.dart';

import '../../utils/repositories/ProfileRepositories/logged_in_user_info_repository.dart';
import '../../utils/repositories/ProfileRepositories/update_account_repository.dart';
import '../../viewModel/Address_ViewModels/edit_address_view_model.dart';
import '../../viewModel/profileViewModels/update_account_information_view_model.dart';
import '../Auth/login_screen.dart';
import 'de_activate_account_pop_up.dart';


class AccountInfoScreen extends StatelessWidget {
  const AccountInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AccountInfoViewModel(
      ),
      child: const AccountInfoScreenContent(),
    );
  }
}

class AccountInfoScreenContent extends StatefulWidget {
  const AccountInfoScreenContent({Key? key}) : super(key: key);

  @override
  State<AccountInfoScreenContent> createState() => _AccountInfoScreenContentState();
}

class _AccountInfoScreenContentState extends State<AccountInfoScreenContent> {
  String? selectedCountry;
  String? selectedState;
  String? selectedCity;


  dynamic selectedCountryId;
  dynamic selectedStateId;
  Future<void> getCountries() async {
    final provider = Provider.of<EditAddressViewModel>(context, listen: false);
    provider.stateMap.clear();
    provider.countryMap.clear();
    await provider.getCountries(context);
    setState(() {
    });
  }

  Future<void> fetchCountryState() async {
    final provider= Provider.of<AccountInfoViewModel>(context, listen: false);

    final editAddressViewModel= Provider.of<EditAddressViewModel>(context, listen: false);
    // Pre-fill location fields
    selectedCountry =   provider.selectedCountry;
    print("dsfdcds"+selectedCountry.toString());
    selectedCountryId =await editAddressViewModel.countryMap.keys.firstWhere(

          (key) => editAddressViewModel.countryMap[key] == selectedCountry,
      orElse: () => "",
    );
    print("dsfdcscds"+selectedCountryId.toString());

    await editAddressViewModel.getStates(context, selectedCountryId);
    selectedState = provider.selectedState;
    selectedStateId = await editAddressViewModel.stateMap.keys.firstWhere(
          (key) => editAddressViewModel.stateMap[key] == selectedState,
      orElse: () => "",
    );
    print("dsfdcds"+selectedState.toString());
    print("dsfdscdcds"+selectedStateId.toString());
setState(() {

});
  }
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
    await  Provider.of<AccountInfoViewModel>(context, listen: false).fetchAndAssignAccountInfo(context);
      await getCountries();
      await fetchCountryState();
    });


    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AccountInfoViewModel>(context);
    final editAddressViewModel = Provider.of<EditAddressViewModel>(context, listen: false);

    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        // backgroundColor: AppColors.brightBlue,
        title: Text(
          "Account Information",
          style: TextStyle(
            fontSize: 20,
            // color: AppColors.black,
            fontWeight: FontWeight.bold,
            fontFamily: MyFonts.font_regular,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, /*color: AppColors.black*/ size: 20),
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
                  //
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
                  const SizedBox(height: 12),
                  Utils.buildDropdownButtonFormField(
                      value: selectedCountryId,
                      items: editAddressViewModel.countryMap,
                      onChanged: (String? newValue) async {
                        setState(() {
                          selectedCountryId = newValue;
                          // Since we're selecting a new country, clear dependent fields
                          editAddressViewModel.stateMap.clear();
                          selectedState = null;
                          selectedCountry=editAddressViewModel.countryMap[newValue];

                          print("Selected Country Name: ${editAddressViewModel.countryMap[newValue]}"); // Print the country name
                          print("Selected Country Name: $selectedCountry"); // Print the country name
                        });

                        // Get states using the country ID (key)
                        if (newValue != null) {
                          // newValue is already the key/ID since we set it as the value in DropdownMenuItem
                          await editAddressViewModel.getStates(context, newValue);
                          setState(() {});
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
                      items: editAddressViewModel.stateMap,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedStateId = newValue;
                          selectedState=editAddressViewModel.stateMap[newValue];
                          print("Selected state Name: ${editAddressViewModel.stateMap[newValue]}"); // Print the country name
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
                  // Country State Picker
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
                  //     height: 180, // Increase or adjust height as needed
                  //     child: Theme(
                  //       data: Theme.of(context).copyWith(
                  //         textTheme: Theme.of(context).textTheme.copyWith(
                  //           titleMedium: const TextStyle(
                  //             fontFamily: MyFonts.font_Bold,
                  //             color: AppColors.cardcolor,
                  //             fontSize: 14, // Adjusted font color
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

                  Utils.createButton(
                    text: "Update Account",
                    onClick: () => provider.submitAccountInfo(context, selectedCountry, selectedState, selectedCity),
                  ),
                  const SizedBox(height: 20,),
                  GradientButton(text: 'Delete Account', onClick: () {
                    showLoginPopup(context);
                  },),
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
