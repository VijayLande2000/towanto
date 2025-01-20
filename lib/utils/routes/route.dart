import 'package:flutter/material.dart';
import 'package:towanto/utils/routes/route_names.dart';
import 'package:towanto/view/ManageAddress/address_list_screen.dart';

import '../../view/Auth/login_screen.dart';
import '../../view/Auth/onboard_screen.dart';
import '../../view/Auth/sign_up_screen.dart';
import '../../view/Auth/splash_screen.dart';
import '../../view/Home/home_screen.dart';


class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splash:
        return MaterialPageRoute(
            builder: (BuildContext context) => SplashScreen());

      case RoutesName.login:
        return MaterialPageRoute(
            builder: (BuildContext context) => LoginScreen());
      case RoutesName.signup:
        return MaterialPageRoute(
            builder: (BuildContext context) => SignUpScreen());
      case RoutesName.onBoardScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => OnBoardScreen());
      case RoutesName.home:
        return MaterialPageRoute(
            builder: (BuildContext context) => HomeGrid());
        case RoutesName.addressList:
        return MaterialPageRoute(
            builder: (BuildContext context) => AddressManager());
    /*

      case RoutesName.home_menu:
        return MaterialPageRoute(
            builder: (BuildContext context) => HomeMenu());
      case RoutesName.home_menu_list:
        return MaterialPageRoute(
            builder: (BuildContext context) => HomeMenuListView());

      case RoutesName.language_selection_screen:
        return MaterialPageRoute(
            builder: (BuildContext context) => LanguageSelectionScreen());

      case RoutesName.student_dash_board_screen:
        return MaterialPageRoute(
            builder: (BuildContext context) => StudentDashBoard());
      case RoutesName.enlistment_screen:
        return MaterialPageRoute(
            builder: (BuildContext context) => EnlistmentScreen());

      case RoutesName.student_dashboard_bottom_sheet:
        return MaterialPageRoute(
            builder: (BuildContext context) => StudentDashboardBottomSheet());

      case RoutesName.payment_preview_screen:
        return MaterialPageRoute(
            builder: (BuildContext context) => PaymentPreviewScreen ());

      case RoutesName.schedule_screen:
        return MaterialPageRoute(
            builder: (BuildContext context) => ScheduleScreen ());*/
      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(
              child: Text('No route defined'),
            ),
          );
        });
    }
  }
}
