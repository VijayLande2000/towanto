import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:towanto/model/ProfileDetails/update_account_information_model.dart';
import 'package:towanto/utils/network/networkService/app_url.dart';
import 'package:towanto/utils/repositories/ProfileRepositories/logged_in_user_info_repository.dart';
import 'package:towanto/utils/repositories/ProfileRepositories/update_account_repository.dart';
import 'package:towanto/utils/resources/colors.dart';
import 'package:towanto/utils/routes/route.dart';
import 'package:towanto/utils/routes/route_names.dart';
import 'package:towanto/viewModel/Address_ViewModels/add_address_view_model.dart';
import 'package:towanto/viewModel/Address_ViewModels/edit_address_view_model.dart';
import 'package:towanto/viewModel/Address_ViewModels/get_Address_list_view_model.dart';
import 'package:towanto/viewModel/Address_ViewModels/remove_Address_view_model.dart';
import 'package:towanto/viewModel/AuthViewModels/de_activate_account_view_model.dart';
import 'package:towanto/viewModel/AuthViewModels/login_viewModel.dart';
import 'package:towanto/viewModel/AuthViewModels/sign_up_viewModel.dart';
import 'package:towanto/viewModel/CartViewModels/add_to_cart_viewModel.dart';
import 'package:towanto/viewModel/CartViewModels/cart_list_view_model.dart';
import 'package:towanto/viewModel/CartViewModels/check_out_review_view_model.dart';
import 'package:towanto/viewModel/CartViewModels/delete_Cartitem_viewModel.dart';
import 'package:towanto/viewModel/CartViewModels/updateCart_viewModel.dart';
import 'package:towanto/viewModel/EnquireyViewModel/enquirey_view_model.dart';
import 'package:towanto/viewModel/HomeViewModels/categories_list_viewModel.dart';
import 'package:towanto/viewModel/HomeViewModels/get_search_product_list_view_model.dart';
import 'package:towanto/viewModel/HomeViewModels/home_page_data_viewModel.dart';
import 'package:towanto/viewModel/HomeViewModels/product_details_viewModel.dart';
import 'package:towanto/viewModel/OrdersViewModels/cancel_order_view_model.dart';
import 'package:towanto/viewModel/OrdersViewModels/create_order_view_model.dart';
import 'package:towanto/viewModel/OrdersViewModels/order_details_view_model.dart';
import 'package:towanto/viewModel/OrdersViewModels/orders_list_view_model.dart';
import 'package:towanto/viewModel/OrdersViewModels/payment_confirmation_view_model.dart';
import 'package:towanto/viewModel/WhishListViewModels/add_to_whishList_viewModel.dart';
import 'package:towanto/viewModel/WhishListViewModels/delete_whishList_viewModel.dart';
import 'package:towanto/viewModel/WhishListViewModels/whishList_list_view_model.dart';
import 'package:towanto/viewModel/profileViewModels/update_account_information_view_model.dart';


Future<void> main() async {
  // AppUrl.setEnvironment('Prod');    //for Prod
  AppUrl.setEnvironment('Dev');    //for Dev
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase messaging

  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // FirebaseMessagingService().setupFirebase(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => SignUpViewModel()),
        ChangeNotifierProvider(create: (_) => CategoriesListViewModel()),
        ChangeNotifierProvider(create: (_) => ProductdetailsViewModel()),
        ChangeNotifierProvider(create: (_) => AddToCartViewModel()),
        ChangeNotifierProvider(create: (_) => CartListViewModel()),
        ChangeNotifierProvider(create: (_) => UpdateCartViewModel()),
        ChangeNotifierProvider(create: (_) => DeleteCartItemViewModel()),
        ChangeNotifierProvider(create: (_) => AddToWhishListViewModel()),
        ChangeNotifierProvider(create: (_) => WhishListViewModel()),
        ChangeNotifierProvider(create: (_) => DeleteWhishlistItemViewModel()),
        ChangeNotifierProvider(create: (_) => EnquiryViewModel()),
        ChangeNotifierProvider(create: (_) => AccountInfoViewModel(
        )),
        ChangeNotifierProvider(create: (_) => GetAddressViewModel()),
        ChangeNotifierProvider(create: (_) => RemoveAddressViewModel()),
        ChangeNotifierProvider(create: (_) => AddAddressViewModel()),
        ChangeNotifierProvider(create: (_) => EditAddressViewModel()),
        ChangeNotifierProvider(create: (_) => HomePageDataViewModel()),
        ChangeNotifierProvider(create: (_) => OrdersListViewModel()),
        ChangeNotifierProvider(create: (_) => OrderDetailsViewModel()),
        ChangeNotifierProvider(create: (_) => SearchProductViewModel()),
        ChangeNotifierProvider(create: (_) => CheckOutReviewViewModel()),
        ChangeNotifierProvider(create: (_) => CancelOrderViewModel()),
        ChangeNotifierProvider(create: (_) => CreateOrderViewModel()),
        ChangeNotifierProvider(create: (_) => PaymentConfirmationViewModel()),
        ChangeNotifierProvider(create: (_) => DeactivateAccountViewModel()),
      ],
      child: MaterialApp(
        title: 'Towanto',
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme: AppBarTheme(backgroundColor: AppColors.brightBlue , titleTextStyle: TextStyle(color: AppColors.white),iconTheme: IconThemeData(color: AppColors.white))
        ),
        initialRoute: RoutesName.splash,
        onGenerateRoute: Routes.generateRoute,

      ),
    );
  }

}
