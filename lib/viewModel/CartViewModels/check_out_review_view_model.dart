import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:towanto/utils/repositories/CartRepositories/check_out_review_repository.dart';
import 'dart:developer' as developer;
import '../../model/CartModels/check_out_review_model.dart';
import '../../utils/common_widgets/PreferencesHelper.dart';
import '../../utils/common_widgets/Utils.dart';

class CheckOutReviewViewModel extends ChangeNotifier {
  final _myRepo = CheckOutReviewRepository();
  late BuildContext context;
  bool _loading = false;
  bool get loading => _loading;

  // Data holders
  CheckOutReviewModel? _checkOutReview;
  CheckOutReviewModel? get checkOutReview => _checkOutReview;

  // Getters for commonly accessed data
  OrderDetails? get orderDetails => _checkOutReview?.result?.reviewSummary?.orderDetails;
  List<OrderLine>? get orderLines => orderDetails?.orderLine;
  PartnerId? get partnerInfo => orderDetails?.partnerId;
  PartnerInvoiceId? get billingAddress => orderDetails?.partnerInvoiceId;
  PartnerInvoiceId? get shippingAddress => orderDetails?.partnerShippingId;
  dynamic totalAmount=0.0;

  Future<void> savePaymentInformation(String amount,String name,String phone) async {
    await PreferencesHelper.saveString("Amount",amount);
    await PreferencesHelper.saveString("name",name);
    await PreferencesHelper.saveString("phone",phone);
    print("wedxew"+amount.toString());
    print("wedxew"+name.toString());
    print("wedxew"+phone.toString());
  }
  void setLoading(bool value) {
    _loading = value;
    developer.log('Loading state changed to: $_loading', name: 'CheckOutReviewViewModel');
    notifyListeners();
  }

  // Get checkout review details
  Future<void> getCheckoutReview(BuildContext context) async {
    try {
      this.context = context;
      setLoading(true);
      clearCheckoutData();
      final sessionId = await PreferencesHelper.getString("session_id");
      final orderId = await PreferencesHelper.getString("order_id");
      final shipping_address_id = await PreferencesHelper.getString("shipping_id");
      final invoice_address_id = await PreferencesHelper.getString("billing_id");

      var body = {
        "params":
        {
          "order_id":int.tryParse(orderId.toString()),
          "invoice_address_id": int.tryParse(invoice_address_id.toString()),
          "shipping_address_id": int.tryParse(shipping_address_id.toString()),
        }
      };

      developer.log('Starting checkout review process with data: ${jsonEncode(body)}',
          name: 'CheckOutReviewViewModel');

      final response = await _myRepo.getcheckOutReviewDetailsApiResponse(
          jsonEncode(body),
          context,
          sessionId ?? ""
      );

      if (response != null) {
        _checkOutReview = response;
        developer.log('Amount: ${response.result!.reviewSummary!.orderDetails!.totalAmount}');
        developer.log('Name: ${response.result!.reviewSummary!.orderDetails!.partnerId!.name}');
        developer.log('Phone: ${response.result!.reviewSummary!.orderDetails!.partnerId!.phone}');

         totalAmount = response.result!.reviewSummary!.orderDetails!.totalAmount;
        print("total amount"+totalAmount.toString());
        print("total amount"+response.result!.reviewSummary!.orderDetails!.totalAmount.toString());

// Multiply the value by 100 and store it as a string
        final adjustedAmount = (totalAmount ?? 0) * 100*100;

        await PreferencesHelper.saveString("Amount", adjustedAmount.toString());
        await PreferencesHelper.saveString("name", '${response.result!.reviewSummary!.orderDetails!.partnerId!.name}');
        await PreferencesHelper.saveString("phone", '${response.result!.reviewSummary!.orderDetails!.partnerId!.phone}');

        // Retrieve and print the saved values
        final savedAmount = await PreferencesHelper.getString("Amount");
        final savedName = await PreferencesHelper.getString("name");
        final savedPhone = await PreferencesHelper.getString("phone");

        developer.log("Saved Amount: $savedAmount", name: 'CheckOutReviewViewModel');
        developer.log("Saved Name: $savedName", name: 'CheckOutReviewViewModel');
        developer.log("Saved Phone: $savedPhone", name: 'CheckOutReviewViewModel');

        developer.log('Checkout review data received successfully',
            name: 'CheckOutReviewViewModel');
      }

    } catch (e, stackTrace) {
      developer.log(
        'Error during checkout review process',
        name: 'CheckOutReviewViewModel',
        error: e.toString(),
        stackTrace: stackTrace,
      );
      // You might want to handle the error appropriately here
    } finally {
      setLoading(false);
    }
  }

  // // Helper methods for common calculations
  // double getTotalAmount() {
  //   return double.tryParse(orderDetails?.totalAmount?.toString() ?? "0") ?? 0.0;
  // }
  //
  // double getTotalTax() {
  //   return double.tryParse(orderDetails?.totalTaxAmount?.toString() ?? "0") ?? 0.0;
  // }
  //
  // double getDeliveryCharges() {
  //   return double.tryParse(orderDetails?.deliveryCharges?.toString() ?? "0") ?? 0.0;
  // }
  //
  // double getTotalDiscount() {
  //   return double.tryParse(orderDetails?.totalDiscountAmount?.toString() ?? "0") ?? 0.0;
  // }
  //
  // String getOrderStatus() {
  //   return orderDetails?.state?.toString() ?? "unknown";
  // }
  //
  // bool isDeliveryStatus() {
  //   return orderDetails?.deliveryStatus ?? false;
  // }

  // Method to get formatted address string

  String getFormattedAddress(PartnerInvoiceId? address) {
    if (address == null) return "";

    List<String> addressParts = [];

    if (address.name?.isNotEmpty ?? false) addressParts.add(address.name!);
    if (address.street?.isNotEmpty ?? false) addressParts.add(address.street!);
    if (address.street2 != null && address.street2 != false) addressParts.add(address.street2.toString());
    if (address.city?.isNotEmpty ?? false) addressParts.add(address.city!);
    if (address.zip?.isNotEmpty ?? false) addressParts.add(address.zip!);

    return addressParts.join(", ");
  }

  // // Method to check if order has items
  // bool hasOrderItems() {
  //   return (orderLines?.isNotEmpty ?? false);
  // }
  //
  // // Method to get total number of items
  // int getTotalItems() {
  //   if (orderLines == null) return 0;
  //
  //   return orderLines!.fold(0, (sum, item) {
  //     return sum + (int.tryParse(item.productUomQty?.toString() ?? "0") ?? 0);
  //   });
  // }
  //
  // Clear checkout data
  void clearCheckoutData() {
    _checkOutReview = null;
    notifyListeners();
  }
}