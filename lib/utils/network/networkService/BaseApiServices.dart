
import 'package:flutter/material.dart';

import '../../../model/Address_Models/payment_address_model.dart';
abstract class BaseApiServices {
  Future<dynamic> postApiResponse(String url, dynamic data, BuildContext context);
  Future<dynamic> postSignUpApiResponse(String url, dynamic data, BuildContext context);
  Future<dynamic> getCategoriesListApiResponse(String url, String categoryId, BuildContext context,dynamic sessionId);
  Future<dynamic> getHomePageDataApiResponse(String url, String categoryIds,BuildContext context);
  Future<dynamic> getProductDetailsApiResponse(String url, String categoryId, BuildContext context);
  Future<dynamic> getAllCountriesApiResponse(String url,BuildContext context,String SessionId);
  Future<dynamic> getAllStatesDetailsApiResponse(String url, dynamic countryId, BuildContext context,String SessionId);
  Future<dynamic> postAddToCartApiResponse(String url, dynamic data, BuildContext context,String SessionId);
  Future<dynamic> getCartListApiResponse(String url, String categoryId, BuildContext context,String SessionId);
  Future<dynamic> getFiltersListApiResponse(String url,BuildContext context,String sessionId);
  Future<dynamic> getAllBrandsListApiResponse(String url,BuildContext context,String sessionId);

  Future<dynamic> getOrdersListApiResponse(String url, String partnerId, BuildContext context,String sessionId);





  Future<dynamic> updateCartApiResponse(String url, dynamic data, BuildContext context,String SessionId);
  Future<dynamic> deleteCartApiResponse(String url, String partnerId,String id, BuildContext context,String sessionId);


  Future<dynamic> postAddToWhishListApiResponse(String url, dynamic data, BuildContext context,String sessionId);
  Future<dynamic> postforgotApiResponse(String url, dynamic data, BuildContext context,String sessionId);



  Future<dynamic> getWhishListApiResponse(String url, String categoryId, BuildContext context,String sessionId);
  Future<dynamic> deleteWhishListApiResponse(String url, String partnerId,String id, BuildContext context,String sessionId);

  Future<dynamic> postEnquireyApiResponse(String url, dynamic data, BuildContext context,String sessionId);
  Future<dynamic> postUpdateAccountInformationApiResponse(String url, dynamic data, BuildContext context,String sessionId);
  Future<dynamic> postGetLoggedInUserInformationApiResponse(String url, dynamic data, BuildContext context,String sessionId);
  Future<dynamic> postAddressListApiResponse(String url, dynamic data, BuildContext context,String sessionId);
  Future<dynamic> postCheckOutReviewApiResponse(String url, dynamic data, BuildContext context,String sessionId);
  Future<dynamic> postProductSearchListApiResponse(String url, dynamic data, BuildContext context,String sessionId);



  Future<dynamic> removeAddressListApiResponse(String url, dynamic data, BuildContext context,String sessionId);
  Future<dynamic> addAddressListApiResponse(String url, dynamic data, BuildContext context,String sessionId,dynamic from);
  Future<dynamic> editAddressListApiResponse(String url, dynamic data, BuildContext context,String sessionId,String navigateTo,PaymentAddressModel formData);
  Future<dynamic> postOrderDetailsApiResponse(String url, dynamic data, BuildContext context,String sessionId);
  Future<dynamic> postCancelOrderApiResponse(String url, dynamic data, BuildContext context,String sessionId);
  Future<dynamic> postCreateOrderApiResponse(String url, dynamic data, BuildContext context,String sessionId);

  Future<dynamic> postDeactivateAccountApiResponse(String url, dynamic data, BuildContext context,String sessionId);


  Future<dynamic> paymentConfirmationApiResponse(dynamic body,String url, dynamic partnerId, BuildContext context,String sessionId);
  Future<dynamic> postFilterProductsApiResponse(String url, dynamic data, BuildContext context,String SessionId);
  Future<dynamic> getBrandsByIDApiResponse(String url, int id, BuildContext context,String sessionId);

// Future<dynamic> getGetApiResponse(String url);


  // Future<dynamic> putApiResponse(String url, String vid, dynamic data, String token);

}
