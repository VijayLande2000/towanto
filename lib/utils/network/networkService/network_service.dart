import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:towanto/utils/routes/route_names.dart';
import 'package:towanto/view/Orders/orders_screen.dart';
import 'package:towanto/view/Payments/check_out_flow.dart';
import 'package:towanto/view/Payments/checkout_address_screen.dart';

import '../../../view/Payments/order_confirmation_screen.dart';
import '../../../viewModel/Address_ViewModels/get_Address_list_view_model.dart';
import '../../common_widgets/PreferencesHelper.dart';
import '../../common_widgets/Utils.dart';
import 'BaseApiServices.dart';
import 'app_exceptions.dart';

class NetworkApiService extends BaseApiServices {
  dynamic responseJson;

  // @override
  // Future postApiResponse(String url, dynamic data, BuildContext context) async {
  //   try {
  //     var headers = {
  //       'Content-Type': 'application/json',
  //       'Accept': "application/json",
  //     };
  //
  //     Response response = await post(
  //       Uri.parse(url),
  //       body: data,
  //       headers: headers,
  //     ).timeout(const Duration(seconds: 60));
  //     print("Login response ="+response.body);
  //     responseJson = returnResponse(response);
  //   } on SocketException {
  //     Utils.flushBarErrorMessages("No Internet Connection",context);
  //   }
  //   return responseJson;
  // }

  @override
  Future postApiResponse(String url, dynamic data, BuildContext context) async {
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Accept': "application/json",
      };
      Response response = await post(
        Uri.parse(url),
        body: data,
        headers: headers,
      ).timeout(const Duration(seconds: 60));
      print("Login response =" + response.body);
      print("Login statusCode =" + response.statusCode.toString());
      if (response.statusCode == 200) {
        Future.delayed(Duration(seconds: 0), () =>
            Utils.flushBarSuccessMessages("Login successfully", context));
        Navigator.pushReplacementNamed(context, RoutesName.home);

        String? setCookieHeader = response.headers['set-cookie'];
        String? sessionId = extractSessionId(setCookieHeader!);
        await PreferencesHelper.saveString("session_id", sessionId!);
        print("bgnsdfghvbjk" + sessionId);

        // Navigator.pushNamed(context, RoutesName.login);
        // Navigator.pop(context);
      }
      if (response.statusCode == 404) {
        Future.delayed(Duration(seconds: 0), () =>
            Utils.flushBarSuccessMessages("User does not exist", context));
      }
     else if (response.statusCode == 500) {
        Future.delayed(Duration(seconds: 0), () =>
            Utils.flushBarSuccessMessages("Incorrect Credientials", context));
      }
      responseJson = returnResponse(response);
    } on SocketException {
      Utils.flushBarErrorMessages("No Internet Connection", context);
    }
    return responseJson;
  }

  // Function to extract session_id from set-cookie header
  String? extractSessionId(String setCookieHeader) {
    List<String> cookies = setCookieHeader.split(';');
    for (String cookie in cookies) {
      if (cookie.trim().startsWith("session_id=")) {
        return cookie.trim().substring("session_id=".length);
      }
    }
    return null;
  }

  @override
  Future getCategoriesListApiResponse(String url, String categoryId,
      BuildContext context) async {
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Accept': "application/json",
      };

      String finalUrl = '$url&category_ids=$categoryId';
      print("finalUrl response =" + finalUrl);

      Response response = await http.get(
        Uri.parse(finalUrl), headers: headers,
      ).timeout(const Duration(seconds: 60));
      print("category response =" + response.body);
      print("category statusCode =" + response.statusCode
          .toString()); // final response = await http.get(Uri.parse(url));
      responseJson = returnResponse(response);
    } on SocketException {
      Utils.flushBarErrorMessages("No Internet Connection", context);
    }
    return responseJson;
  }


  dynamic returnResponse(http.Response response) async {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;

      case 400:
        throw Exception(response.body.toString());

    // case 401:
      case 404:
        throw Exception(response.body.toString());

      case 500:
        throw ServerNotRespondingException();

      case 503:
        throw ServerDownException();

      default:
        throw Exception(

            response.body.toString());
    }
  }

  @override
  Future postSignUpApiResponse(String url, data, BuildContext context) async {
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Accept': "application/json",
      };
      Response response = await post(
        Uri.parse(url),
        body: data,
        headers: headers,
      ).timeout(const Duration(seconds: 60));
      print("SignUp response =" + response.body);
      print("SignUp statusCode =" + response.statusCode.toString());
      if (response.statusCode == 200) {
        Future.delayed(Duration(seconds: 0), () =>
            Utils.flushBarSuccessMessages(
                "User created successfully", context));
        Navigator.pushReplacementNamed(context, RoutesName.login);

        // Navigator.pushNamed(context, RoutesName.login);
        // Navigator.pop(context);
      }
      else if (response.statusCode == 400) {
        Utils.flushBarErrorMessages("Email already exists", context);
      };

      responseJson = returnResponse(response);
    } on SocketException {
      Utils.flushBarErrorMessages("No Internet Connection", context);
    }
    return responseJson;
  }

  @override
  Future getProductDetailsApiResponse(String url, String categoryId,
      BuildContext context) async {
    try {
      String? sessionId = await PreferencesHelper.getString("session_id");

      var headers = {
        'Content-Type': 'application/json',
        'Accept': "application/json",
        'Cookie': 'session_id=$sessionId'

      };
print("bhjug"+headers.toString());
      String finalUrl = '$url?id=$categoryId';
      print("finalUrl response =" + finalUrl);

      Response response = await http.get(
        Uri.parse(finalUrl), headers: headers,
      ).timeout(const Duration(seconds: 60));
      print("ProductDetails response =" + response.body);
      print("ProductDetails statusCode =" + response.statusCode.toString());
      var decodedJson = jsonDecode(response.body);
      print("Is in in_cart: ${decodedJson[0]['in_cart']}");

      // final response = await http.get(Uri.parse(url));
      responseJson = returnResponse(response);
    } on SocketException {
      Utils.flushBarErrorMessages("No Internet Connection", context);
    }
    return responseJson;
  }

  @override
  Future postAddToCartApiResponse(String url, data, BuildContext context,
      String SessionId) async {
    try {
      print("fvb " + SessionId);
      var headers = {
        'Content-Type': 'application/json',
        'Accept': "application/json",
        'Cookie': 'session_id=$SessionId'
      };
      print("url :" + url);
      print("url :" + headers.toString());
      Response response = await post(
          Uri.parse(url), body: data, headers: headers).timeout(
          const Duration(seconds: 60));
      print("data :" + data.toString());

      print("AddToCart response =" + response.body);
      print("AddToCart statusCode =" + response.statusCode.toString());
      if (response.statusCode == 200) {
        Future.delayed(Duration(seconds: 0), () =>
            Utils.flushBarSuccessMessages(
                "Product added to cart successfully", context));
        // Navigator.pushReplacementNamed(context, RoutesName.cart);
      }
      responseJson = returnResponse(response);
    } on SocketException {
      Utils.flushBarErrorMessages("No Internet Connection", context);
    }
    return responseJson;
  }

  @override
  Future getCartListApiResponse(String url, String partnerId,
      BuildContext context, String sessionId) async {
    try {
      print("fvb " + sessionId);
      var headers = {
        'Content-Type': 'application/json',
        'Accept': "application/json",
        'Cookie': 'session_id=$sessionId'
      };
      // Append categoryId to the URL
      Uri updatedUrl = Uri.parse(url).replace(queryParameters: {
        'partner_id': partnerId, // Append categoryId as query parameter
      });

      print("url :" + updatedUrl.toString());
      print("header :" + headers.toString());

      Response response = await http.get(
        updatedUrl, headers: headers,
      ).timeout(const Duration(seconds: 60));

      print("cart list response =" + response.body);
      print("cart List statusCode =" + response.statusCode.toString());
      if (response.statusCode == 200) {
        // Future.delayed(Duration(seconds:0),() =>Utils.flushBarSuccessMessages("Product added to cart successfully",context));
        // Navigator.pushReplacementNamed(context, RoutesName.cart);
      }
      responseJson = returnResponse(response);
    } on SocketException {
      Utils.flushBarErrorMessages("No Internet Connection", context);
    }
    return responseJson;
  }

  @override
  Future updateCartApiResponse(String url, data, BuildContext context,
      String sessionId) async {
    try {
      print("fvb " + sessionId);
      var headers = {
        'Content-Type': 'application/json',
        'Accept': "application/json",
        'Cookie': 'session_id=$sessionId'
      };

      final response = await http.patch(
        Uri.parse(url),
        headers: headers,
        body: data,
      ).timeout(const Duration(seconds: 60));

      print("cart update response =" + response.body);
      print("cart update statusCode =" + response.statusCode.toString());
      if (response.statusCode == 200) {
        // Future.delayed(Duration(seconds:0),() =>Utils.flushBarSuccessMessages("Product added to cart successfully",context));
        // Navigator.pushReplacementNamed(context, RoutesName.cart);
      }
      responseJson = returnResponse(response);
    } on SocketException {
      Utils.flushBarErrorMessages("No Internet Connection", context);
    }
    return responseJson;
  }

  @override
  Future deleteCartApiResponse(String url, String partnerId, String id,
      BuildContext context, String sessionId) async {
    try {
      print("fvb " + sessionId);
      var headers = {
        'Content-Type': 'application/json',
        'Accept': "application/json",
        'Cookie': 'session_id=$sessionId'
      };
      // Append categoryId to the URL
      Uri updatedUrl = Uri.parse(url).replace(queryParameters: {
        'partner_id': partnerId, // Append categoryId as query parameter
        "id": id,
      });

      print("url :" + updatedUrl.toString());
      print("header :" + headers.toString());

      Response response = await http.delete(
        updatedUrl, headers: headers,
      ).timeout(const Duration(seconds: 60));

      print("cart delete response =" + response.body);
      print("cart delete statusCode =" + response.statusCode.toString());
      if (response.statusCode == 200) {
        Future.delayed(Duration(seconds: 0), () =>
            Utils.flushBarSuccessMessages(
                "Product deleted successfully", context));
        // Navigator.pushReplacementNamed(context, RoutesName.cart);
      }
      responseJson = returnResponse(response);
    } on SocketException {
      Utils.flushBarErrorMessages("No Internet Connection", context);
    }
    return responseJson;
  }

  @override
  Future deleteWhishListApiResponse(String url, String partnerId,
      String whishListId, BuildContext context, String sessionId) async {
    try {
      print("fvb " + sessionId);
      var headers = {
        'Content-Type': 'application/json',
        'Accept': "application/json",
        'Cookie': 'session_id=$sessionId'
      };
      // Append categoryId to the URL
      Uri updatedUrl = Uri.parse(url).replace(queryParameters: {
        'partner_id': partnerId, // Append categoryId as query parameter
        "wishlist_item_id": whishListId,
      });

      print("url :" + updatedUrl.toString());
      print("header :" + headers.toString());

      Response response = await http.delete(
        updatedUrl, headers: headers,
      ).timeout(const Duration(seconds: 60));

      print("whishlist delete response =" + response.body);
      print("whishlist delete statusCode =" + response.statusCode.toString());
      if (response.statusCode == 200) {
        Future.delayed(Duration(seconds: 0), () =>
            Utils.flushBarSuccessMessages(
                "Product deleted successfully", context));
        // Navigator.pushReplacementNamed(context, RoutesName.cart);
      }
      responseJson = returnResponse(response);
    } on SocketException {
      Utils.flushBarErrorMessages("No Internet Connection", context);
    }
    return responseJson;
  }

  @override
  Future getWhishListApiResponse(String url, String partnerId,
      BuildContext context, String sessionId) async {
    try {
      print("fvb " + sessionId);
      var headers = {
        'Content-Type': 'application/json',
        'Accept': "application/json",
        'Cookie': 'session_id=$sessionId'
      };
      // Append categoryId to the URL
      Uri updatedUrl = Uri.parse(url).replace(queryParameters: {
        'partner_id': partnerId, // Append categoryId as query parameter
      });

      print("url :" + updatedUrl.toString());
      print("header :" + headers.toString());

      Response response = await http.get(
        updatedUrl, headers: headers,
      ).timeout(const Duration(seconds: 60));

      print("whish list response =" + response.body);
      print("whishlist List statusCode =" + response.statusCode.toString());
      if (response.statusCode == 200) {
        // Future.delayed(Duration(seconds:0),() =>Utils.flushBarSuccessMessages("Product added to cart successfully",context));
        // Navigator.pushReplacementNamed(context, RoutesName.cart);
      }
      responseJson = returnResponse(response);
    } on SocketException {
      Utils.flushBarErrorMessages("No Internet Connection", context);
    }
    return responseJson;
  }

  @override
  Future postAddToWhishListApiResponse(String url, data, BuildContext context,
      String sessionId) async {
    try {
      print("fvb " + sessionId);
      var headers = {
        'Content-Type': 'application/json',
        'Accept': "application/json",
        'Cookie': 'session_id=$sessionId'
      };
      print(" post whishlist url :" + url);
      print(" post whishlist url :" + headers.toString());
      Response response = await post(
          Uri.parse(url), body: data, headers: headers).timeout(
          const Duration(seconds: 60));
      print("post whishlist data :" + data.toString());

      print("post whishlist response =" + response.body);
      print("post whishlist statusCode =" + response.statusCode.toString());
      if (response.statusCode == 200) {
        Future.delayed(Duration(seconds: 0), () =>
            Utils.flushBarSuccessMessages(
                "Product added to wishList successfully", context));
        // Navigator.pushReplacementNamed(context, RoutesName.cart);
      }
      responseJson = returnResponse(response);
    } on SocketException {
      Utils.flushBarErrorMessages("No Internet Connection", context);
    }
    return responseJson;
  }

  @override
  Future postEnquireyApiResponse(String url, data, BuildContext context,
      String sessionId) async {
    try {
      print("fvb " + sessionId);
      var headers = {
        'Content-Type': 'application/json',
        'Accept': "application/json",
        'Cookie': 'session_id=$sessionId'
      };
      print(" post enquirey url :" + url);
      print(" post enquirey url :" + headers.toString());
      Response response = await post(
          Uri.parse(url), body: data, headers: headers).timeout(
          const Duration(seconds: 60));
      print("post enquirey data :" + data.toString());

      print("post enquirey response =" + response.body);
      print("post emquirey statusCode =" + response.statusCode.toString());
      if (response.statusCode == 200) {
        Future.delayed(Duration(seconds: 0), () =>
            Utils.flushBarSuccessMessages(
                "Enquiry submitted successfully!", context));

        Navigator.pushReplacementNamed(context, RoutesName.home);
      }
      responseJson = returnResponse(response);
    } on SocketException {
      Utils.flushBarErrorMessages("No Internet Connection", context);
    }
    return responseJson;
  }

  @override
  Future postUpdateAccountInformationApiResponse(String url, data,
      BuildContext context, String sessionId) async {
    try {
      print("fvb " + sessionId);
      var headers = {
        'Content-Type': 'application/json',
        'Accept': "application/json",
        'Cookie': 'session_id=$sessionId'
      };
      print(" post Account info url :" + url);
      print(" post Account info url :" + headers.toString());
      Response response = await post(
          Uri.parse(url), body: data, headers: headers).timeout(
          const Duration(seconds: 60));
      print("post Account info data :" + data.toString());

      print("post Account info response =" + response.body);
      print("post Account info statusCode =" + response.statusCode.toString());
      if (response.statusCode == 200) {
        Future.delayed(Duration(seconds: 0), () =>
            Utils.flushBarSuccessMessages(
                "Account Updated successfully!", context));
        Navigator.pushReplacementNamed(context, RoutesName.home);
      }
      responseJson = returnResponse(response);
    } on SocketException {
      Utils.flushBarErrorMessages("No Internet Connection", context);
    }
    return responseJson;
  }

  @override
  Future postAddressListApiResponse(String url, data, BuildContext context,
      String sessionId) async {
    try {
      print("fvb " + sessionId);
      var headers = {
        'Content-Type': 'application/json',
        'Accept': "application/json",
        'Cookie': 'session_id=$sessionId'
      };

      Response response = await post(
          Uri.parse(url), body: data, headers: headers).timeout(
          const Duration(seconds: 60));
      print("post address info data :" + data.toString());
      print("post address info data :" + url.toString());

      print("post address info response =" + response.body);
      print("post address info statusCode =" + response.statusCode.toString());
      if (response.statusCode == 200) {
        // Future.delayed(Duration(seconds:0),() =>Utils.flushBarSuccessMessages("Account Updated successfully!",context));
        // Navigator.pushReplacementNamed(context, RoutesName.home);
      }
      responseJson = returnResponse(response);
    } on SocketException {
      Utils.flushBarErrorMessages("No Internet Connection", context);
    }
    return responseJson;
  }

  @override
  Future removeAddressListApiResponse(String url, data, BuildContext context,
      String sessionId) async {
    try {
      print("fvb " + sessionId);
      var headers = {
        'Content-Type': 'application/json',
        'Accept': "application/json",
        'Cookie': 'session_id=$sessionId'
      };

      Response response = await post(
          Uri.parse(url), body: data, headers: headers).timeout(
          const Duration(seconds: 60));
      print("remove address info data :" + data.toString());
      print("remove address info data :" + url.toString());

      print("remove address info response =" + response.body);
      print(
          "remove address info statusCode =" + response.statusCode.toString());
      if (response.statusCode == 200) {
        final provider = Provider.of<GetAddressViewModel>(
            context, listen: false);
        await provider.getupdateAddressList(context);
        // Future.delayed(Duration(seconds:0),() =>Utils.flushBarSuccessMessages("Account Updated successfully!",context));
        // Navigator.pushReplacementNamed(context, RoutesName.home);
      }
      responseJson = returnResponse(response);
    } on SocketException {
      Utils.flushBarErrorMessages("No Internet Connection", context);
    }
    return responseJson;
  }

  @override
  Future addAddressListApiResponse(String url, data, BuildContext context,
      String sessionId,dynamic from) async {
    try {
      print("fvb " + sessionId);
      var headers = {
        'Content-Type': 'application/json',
        'Accept': "application/json",
        'Cookie': 'session_id=$sessionId'
      };

      Response response = await post(
          Uri.parse(url), body: data, headers: headers).timeout(
          const Duration(seconds: 60));
      print("add address info data :" + data.toString());
      print("add address info data :" + url.toString());

      print("add address info response =" + response.body);
      print("add address info statusCode =" + response.statusCode.toString());
      if (response.statusCode == 200) {
        Future.delayed(Duration(seconds: 0), () => Utils.flushBarSuccessMessages("Address Added successfully!", context));

       if(from=="CheckOutAddressScreen"){
         Navigator.push(context, MaterialPageRoute(builder: (context) => CheckoutFlowScreen(),));

       }
       else{
         Navigator.pushReplacementNamed(context, RoutesName.addressList);
       }
      }
      responseJson = returnResponse(response);
    } on SocketException {
      Utils.flushBarErrorMessages("No Internet Connection", context);
    }
    return responseJson;
  }

  @override
  Future editAddressListApiResponse(String url, data, BuildContext context,
      String sessionId,String navigateTo,dynamic formData) async {
    try {
      print("fvb " + sessionId);
      var headers = {
        'Content-Type': 'application/json',
        'Accept': "application/json",
        'Cookie': 'session_id=$sessionId'
      };

      Response response = await post(
          Uri.parse(url), body: data, headers: headers).timeout(
          const Duration(seconds: 60));
      print("edit address info data :" + data.toString());
      print("edit address info data :" + url.toString());

      print("edit address info response =" + response.body);
      print("edit address info statusCode =" + response.statusCode.toString());
      if (response.statusCode == 200) {
        Future.delayed(Duration(seconds: 0), () =>
            Utils.flushBarSuccessMessages(
                "Address Updated successfully!", context));

      print("dfhjv"+navigateTo);
      if(navigateTo=="checkoutScreen"){
          Navigator.push(context, MaterialPageRoute(builder: (context) => CheckoutFlowScreen(),));
        }
      else if(navigateTo=="back"){
        Navigator.pop(context, formData);
      }
        else{
          Navigator.pushReplacementNamed(context, RoutesName.addressList);
        }
      }
      responseJson = returnResponse(response);
    } on SocketException {
      Utils.flushBarErrorMessages("No Internet Connection", context);
    }
    return responseJson;
  }

  @override
  Future getHomePageDataApiResponse(String url, String categoryIds,
      BuildContext context) async {
    try {
      String? sessionId = await PreferencesHelper.getString("session_id");

      var headers = {
        'Content-Type': 'application/json',
        'Accept': "application/json",
        'Cookie': 'session_id=$sessionId',
      };
      // var headers = {
      //   'Content-Type': 'application/json',
      //   'Accept': "application/json",
      // };
      String finalUrl = '$url?category_ids=$categoryIds';
      print("finalUrl response =" + finalUrl);

      Response response = await http.get(
        Uri.parse(finalUrl), headers: headers,
      ).timeout(const Duration(seconds: 60));
      print("category response =" + response.body);
      print("category statusCode =" + response.statusCode
          .toString()); // final response = await http.get(Uri.parse(url));
      responseJson = returnResponse(response);
    } on SocketException {
      Utils.flushBarErrorMessages("No Internet Connection", context);
    }
    return responseJson;
  }

  @override
  Future getOrdersListApiResponse(String url, String partnerId,
      BuildContext context, String sessionId) async {
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Accept': "application/json",
        'Cookie': 'session_id=$sessionId'
      };
      // Append categoryId to the URL
      Uri updatedUrl = Uri.parse(url).replace(queryParameters: {
        'partner_id': partnerId, // Append categoryId as query parameter
      });

      print("url :" + updatedUrl.toString());
      print("header :" + headers.toString());

      Response response = await http.get(
        updatedUrl, headers: headers,
      ).timeout(const Duration(seconds: 60));

      print("orders list response =" + response.body);
      print("orders List statusCode =" + response.statusCode.toString());
      if (response.statusCode == 200) {
        // Future.delayed(Duration(seconds:0),() =>Utils.flushBarSuccessMessages("Product added to cart successfully",context));
        // Navigator.pushReplacementNamed(context, RoutesName.cart);
      }
      responseJson = returnResponse(response);
    } on SocketException {
      Utils.flushBarErrorMessages("No Internet Connection", context);
    }
    return responseJson;
  }

  @override
  Future postOrderDetailsApiResponse(String url, data, BuildContext context, String sessionId) async {
    try {
      print("fvb " + sessionId);
      var headers = {
        'Content-Type': 'application/json',
        'Accept': "application/json",
        'Cookie': 'session_id=$sessionId'
      };
      Response response = await post(
          Uri.parse(url), body: data, headers: headers).timeout(
          const Duration(seconds: 60));
      print("orders info data :" + data.toString());
      print("orders url :" + url.toString());

      print("orders response =" + response.body);
      print("ordersstatusCode =" + response.statusCode.toString());
      if (response.statusCode == 200) {
        // Future.delayed(Duration(seconds: 0), () =>
        //     Utils.flushBarSuccessMessages(
        //         "Address Updated successfully!", context));
        // Navigator.pushReplacementNamed(context, RoutesName.addressList);
      }
      responseJson = returnResponse(response);
    } on SocketException {
      Utils.flushBarErrorMessages("No Internet Connection", context);
    }
    return responseJson;
  }

  @override
  Future postProductSearchListApiResponse(String url, data, BuildContext context, String sessionId) async {
    try {
      print("fvb " + sessionId);
      var headers = {
        'Content-Type': 'application/json',
        'Accept': "application/json",
        'Cookie': 'session_id=$sessionId'
      };

      Response response = await post(
          Uri.parse(url), body: data, headers: headers).timeout(
          const Duration(seconds: 60));
      print("product search info data :" + data.toString());
      print("product search info data :" + url.toString());

      print("product search response =" + response.body);
      print("product search statusCode =" + response.statusCode.toString());
      if (response.statusCode == 200) {
        // Future.delayed(Duration(seconds:0),() =>Utils.flushBarSuccessMessages("Account Updated successfully!",context));
        // Navigator.pushReplacementNamed(context, RoutesName.home);
      }
      responseJson = returnResponse(response);
    } on SocketException {
      Utils.flushBarErrorMessages("No Internet Connection", context);
    }
    return responseJson;
  }

  @override
  Future postCheckOutReviewApiResponse(String url, data, BuildContext context, String sessionId) async {
    try {
      print("fvb " + sessionId);
      var headers = {
        'Content-Type': 'application/json',
        'Accept': "application/json",
        'Cookie': 'session_id=$sessionId'
      };

      Response response = await post(
          Uri.parse(url), body: data, headers: headers).timeout(
          const Duration(seconds: 60));
      print("getcheckOutReviewDetails info data :" + data.toString());
      print("check out info data :" + url.toString());

      print("check out info response =" + response.body);
      print("check out info statusCode =" + response.statusCode.toString());
      if (response.statusCode == 200) {
        // Future.delayed(Duration(seconds:0),() =>Utils.flushBarSuccessMessages("Account Updated successfully!",context));
        // Navigator.pushReplacementNamed(context, RoutesName.home);
      }
      responseJson = returnResponse(response);
    } on SocketException {
      Utils.flushBarErrorMessages("No Internet Connection", context);
    }
    return responseJson;
  }

  @override
  Future postforgotApiResponse(String url, data, BuildContext context, String sessionId) async {
    try {
      print("fvb " + sessionId);
      var headers = {
        'Content-Type': 'application/json',
        'Accept': "application/json",
        'Cookie': 'session_id=$sessionId'
      };
      print(" post forgot url :" + url);
      print(" post forgot url :" + headers.toString());
      Response response = await post(
          Uri.parse(url), body: data, headers: headers).timeout(
          const Duration(seconds: 60));
      print("post forgot data :" + data.toString());

      print("post forgot response =" + response.body);
      print("post forgot statusCode =" + response.statusCode.toString());
      if (response.statusCode == 200) {
        Future.delayed(Duration(seconds: 0), () =>
            Utils.flushBarSuccessMessages("Email Sent Successfully", context));
        Navigator.pushReplacementNamed(context, RoutesName.login);
      }
      responseJson = returnResponse(response);
    } on SocketException {
      Utils.flushBarErrorMessages("No Internet Connection", context);
    }
    return responseJson;
  }

  @override
  Future postGetLoggedInUserInformationApiResponse(String url, data, BuildContext context, String sessionId) async {
    try {
      print("fvb " + sessionId);
      var headers = {
        'Content-Type': 'application/json',
        'Accept': "application/json",
        'Cookie': 'session_id=$sessionId'
      };
      print(" login Account info url :" + url);
      print(" login Account info url :" + headers.toString());
      Response response = await post(
          Uri.parse(url), body: data, headers: headers).timeout(
          const Duration(seconds: 60));
      print("login Account info data :" + data.toString());

      print("login  Account info response =" + response.body);
      print("login Account info statusCode =" + response.statusCode.toString());
      if (response.statusCode == 200) {
        // Future.delayed(Duration(seconds: 0), () =>
        //     Utils.flushBarSuccessMessages(
        //         "Account Updated successfully!", context));
        // Navigator.pushReplacementNamed(context, RoutesName.home);
      }
      responseJson = returnResponse(response);
    } on SocketException {
      Utils.flushBarErrorMessages("No Internet Connection", context);
    }
    return responseJson;
  }

  @override
  Future postCancelOrderApiResponse(String url, data, BuildContext context, String sessionId) async {
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Accept': "application/json",
        'Cookie': 'session_id=$sessionId'
      };
      Response response = await post(Uri.parse(url), body: data, headers: headers).timeout( const Duration(seconds: 60));
      print("orders cancel data :" + data.toString());
      print("orders cancel url :" + url.toString());

      print("orders cancel response =" + response.body);
      print("order cancel sstatusCode =" + response.statusCode.toString());
      if (response.statusCode == 200) {
        Future.delayed(Duration(seconds: 0), () =>
            Utils.flushBarSuccessMessages(
                "Order Cancelled successfully!", context));
        Navigator.push(context, MaterialPageRoute(builder: (context) => OrdersListScreen(),));
      }
      responseJson = returnResponse(response);
    } on SocketException {
      Utils.flushBarErrorMessages("No Internet Connection", context);
    }
    return responseJson;
  }

  @override
  Future postCreateOrderApiResponse(String url, data, BuildContext context, String sessionId) async {
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Accept': "application/json",
        'Cookie': 'session_id=$sessionId'
      };
      Response response = await post(Uri.parse(url), body: data, headers: headers).timeout( const Duration(seconds: 60));
      print("orders create data :" + data.toString());
      print("orders create url :" + url.toString());

      print("orders create response =" + response.body);
      print("order create sstatusCode =" + response.statusCode.toString());
      if (response.statusCode == 200) {
        // Future.delayed(Duration(seconds: 0), () =>
        //     Utils.flushBarSuccessMessages(
        //         "Order Cancelled successfully!", context));
        // Navigator.push(context, MaterialPageRoute(builder: (context) => OrdersListScreen(),));
      }
      responseJson = returnResponse(response);
    } on SocketException {
      Utils.flushBarErrorMessages("No Internet Connection", context);
    }
    return responseJson;
  }

  @override
  Future paymentConfirmationApiResponse(String url, partnerId, BuildContext context, String sessionId) async {
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Accept': "application/json",
        'Cookie': 'session_id=$sessionId'
      };
      String finalUrl = '$url?partner_id=$partnerId';
      print("finalUrl response =" + finalUrl);

      Response response = await http.get(
        Uri.parse(finalUrl), headers: headers,
      ).timeout(const Duration(seconds: 60));
      print("payment Confirmation response =" + response.body);
      print("payment Confirmation statusCode =" + response.statusCode
          .toString()); // final response = await http.get(Uri.parse(url));


      if (response.statusCode == 200) {
        Future.delayed(Duration(seconds: 0), () =>
            Utils.flushBarSuccessMessages(
                "Order Confirmed", context));
        Navigator.push(context, MaterialPageRoute(builder: (context) => OrderConfirmationScreen(),));
      }
      responseJson = returnResponse(response);
    } on SocketException {
      Utils.flushBarErrorMessages("No Internet Connection", context);
    }
    return responseJson;
  }

  @override
  Future postDeactivateAccountApiResponse(String url, data, BuildContext context, String sessionId) async {
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Accept': "application/json",
        'Cookie': 'session_id=$sessionId'
      };
      Response response = await post(Uri.parse(url), body: data, headers: headers).timeout( const Duration(seconds: 60));
      print("DeactivateAccount data :" + data.toString());
      print("DeactivateAccount url :" + url.toString());

      print("DeactivateAccount response =" + response.body);
      print("DeactivateAccount sstatusCode =" + response.statusCode.toString());
      if (response.statusCode == 200) {
        Future.delayed(Duration(seconds: 0), () =>
            Utils.flushBarSuccessMessages("Account DeActivated successfully!", context));
        PreferencesHelper.clearSharedPreferences();
        Navigator.pushNamed(context, RoutesName.login);
      }
     else if (response.statusCode == 400) {
        Future.delayed(Duration(seconds: 0), () =>
            Utils.flushBarErrorMessages("Invalid Credentials please Try Again", context));
      }
      responseJson = returnResponse(response);
    } on SocketException {
      Utils.flushBarErrorMessages("No Internet Connection", context);
    }
    return responseJson;
  }

}