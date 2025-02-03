import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:towanto/viewModel/OrdersViewModels/cancel_order_view_model.dart';
import 'package:towanto/viewModel/OrdersViewModels/order_details_view_model.dart';

import '../../utils/common_widgets/Utils.dart';
import '../../utils/resources/colors.dart';
import '../../utils/resources/fonts.dart';

class OrderDetailsScreen extends StatefulWidget {
  final orderId;
  const OrderDetailsScreen({super.key, this.orderId});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  // Initialize all panels as expanded false
  List<bool> _isExpanded = [false, false, false];

  final List<Map<String, dynamic>> orderItems = List.generate(
    9,
    (index) => {
      'name': 'AN-UR 40',
      'quantity': 2.0,
      'price': 6800.0,
      'status': 'Ordered',
    },
  );

  // Method to toggle expansion state
  void _toggleExpansion(int index) {
    setState(() {
      _isExpanded[index] = !_isExpanded[index];
    });
  }



  Widget deleteButton({
    required String text,
    required VoidCallback onClick,
    required bool isLoading,
  }) {
    return Container(
      margin: const EdgeInsets.all(16),
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [Colors.red, Colors.red],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB24592).withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onClick,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: isLoading
            ? SizedBox(
          height: 22,
          width: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.red,
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.delete_outline_rounded,
              color: Colors.white,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }




  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getOrdersDetailsApiCall();
    });
    // TODO: implement initState
    super.initState();
  }

  // Future<void> _createorder() async {
  //   partnerId = await PreferencesHelper.getString("partnerId");
  //   sessionId = await PreferencesHelper.getString("session_id");
  //   final cartListViewModel = Provider.of<CartListViewModel>(context, listen: false);
  //   cartListViewModel.cartListViewModelApi(partnerId!, sessionId!, context);
  // }

  void getOrdersDetailsApiCall() {
    final provider = Provider.of<OrderDetailsViewModel>(context, listen: false);
    provider.getOrderInfo(context, widget.orderId.toString());
  }

  void cancelOrderApiCall() {
    final provider = Provider.of<CancelOrderViewModel>(context, listen: false);
    provider.cancelOrder(context, widget.orderId.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundcolormenu,
      appBar: AppBar(
        // backgroundColor: AppColors.brightBlue,
        title: Text(
          "Order Details",
          style: TextStyle(
              fontSize: 20,
              // color: AppColors.black,
              fontWeight: FontWeight.bold,
              fontFamily: MyFonts.font_Bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,  size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<OrderDetailsViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.loading) {
            return Utils.loadingIndicator(context);
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOrderHeader(viewModel),
                _buildHorizontalOrderList(viewModel),
                _buildExpandableSections(viewModel),
                Consumer<CancelOrderViewModel>(
                  builder: (context, value, child) {
                  return deleteButton(text: "Cancel Order",onClick: (){
                      cancelOrderApiCall();
                    },
                    isLoading: value.loading,
                   );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderHeader(OrderDetailsViewModel orderDetailsViewModel) {
    return Card(
      color: AppColors.whiteColor,
      margin: const EdgeInsets.all(16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${orderDetailsViewModel.orderDetails.id.toString()}',
                  style: TextStyle(
                      fontSize: 20,
                      color: AppColors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: MyFonts.font_Bold),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.brightBlue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    orderDetailsViewModel.orderDetails.state.toString(),
                    style: TextStyle(
                        fontSize: 14,
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.w600,
                        fontFamily: MyFonts.font_SemiBold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              orderDetailsViewModel.orderDetails.dateOrder.toString(),
              style: TextStyle(
                  fontSize: 14,
                  color: AppColors.tabtxt_color,
                  fontWeight: FontWeight.normal,
                  fontFamily: MyFonts.font_regular),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontalOrderList(
      OrderDetailsViewModel orderDetailsViewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '${orderDetailsViewModel.orderDetails.orderLine?.length ?? 0} ITEM${orderDetailsViewModel.orderDetails.orderLine?.length == 1 ? "" : "S"} ORDERED',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.black,
              fontWeight: FontWeight.bold,
              fontFamily: MyFonts.font_Bold,
            ),
          ),
        ),
        SizedBox(height: 8),
        Container(
          height: 180,
          child: orderDetailsViewModel.orderDetails.orderLine?.isNotEmpty ==
                  true
              ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount:
                      orderDetailsViewModel.orderDetails.orderLine!.length,
                  itemBuilder: (context, index) {
                    final orderLine =
                        orderDetailsViewModel.orderDetails.orderLine![index];
                    return Card(
                      margin: EdgeInsets.only(right: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        width: 160,
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 80,
                              decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Image.network("https://towanto-ecommerce-mainbranch-16118324.dev.odoo.com/web/image?model=product.product&id=${orderDetailsViewModel.orderDetails.orderLine?[index].productId}&field=image_1920"),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              orderLine.productName ?? '',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: MyFonts.font_Bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Qty: ${orderLine.productUomQty ?? 0}',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.tabtxt_color,
                                fontWeight: FontWeight.w500,
                                fontFamily: MyFonts.font_regular,
                              ),
                            ),
                            Text(
                              '₹${orderLine.priceTotal ?? 0.0}',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.tabtxt_color,
                                fontWeight: FontWeight.w700,
                                fontFamily: MyFonts.font_Bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : Center(
                  child: Text(
                    'No items to display',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildExpandableSections(OrderDetailsViewModel orderDetailsViewModel) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Price Details Card
          _buildExpandableCard(
            title: 'PRICE DETAILS',
            index: 0,
            child: _buildPriceDetails(orderDetailsViewModel),
          ),
          SizedBox(height: 16),
          // Billing Details Card
          _buildExpandableCard(
            title: 'BILLING DETAILS',
            index: 1,
            child: _buildBillingDetails(orderDetailsViewModel),
          ),
          SizedBox(height: 16),
          // Shipping Details Card
          _buildExpandableCard(
            title: 'SHIPPING DETAILS',
            index: 2,
            child: _buildShippingDetails(orderDetailsViewModel),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableCard({
    required String title,
    required int index,
    required Widget child,
  }) {
    return Card(
      color: AppColors.whiteColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: () => _toggleExpansion(index),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: MyFonts.font_Bold,
                    ),
                  ),
                  Icon(
                    _isExpanded[index]
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.black,
                  ),
                ],
              ),
            ),
          ),
          // Expandable Content
          AnimatedCrossFade(
            firstChild: Container(height: 0),
            secondChild: child,
            crossFadeState: _isExpanded[index]
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceDetails(OrderDetailsViewModel orderDetailsViewModel) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Column(
        children: [
          _buildPriceRow('Subtotal',
              '₹${orderDetailsViewModel.orderDetails.totalUntaxedAmount.toString()}'),
          SizedBox(height: 8),
          _buildPriceRow('Shipping & Handling',
              '₹${orderDetailsViewModel.orderDetails.deliveryCharges.toString()}'),
          SizedBox(height: 8),
          _buildPriceRow('Tax',
              '₹${orderDetailsViewModel.orderDetails.totalTaxAmount.toString()}'),
          SizedBox(height: 8),
          _buildPriceRow('Discount',
              '₹${orderDetailsViewModel.orderDetails.totalDiscountAmount.toString()}'),
          Divider(height: 24),
          _buildPriceRow('Grand Total',
              '₹${orderDetailsViewModel.orderDetails.totalAmount.toString()}',
              isTotal: true),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            color: isTotal ? AppColors.black : AppColors.tabtxt_color,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            fontFamily: MyFonts.font_Bold,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              color: isTotal ? AppColors.black : AppColors.tabtxt_color,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontFamily: MyFonts.font_Bold),
        ),
      ],
    );
  }

  // ... (previous imports and initial code remains the same until billing and shipping methods)

  Widget _buildBillingDetails(OrderDetailsViewModel orderDetailsViewModel) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Contact Information Section
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.brightBlue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'CONTACT INFORMATION',
              style: TextStyle(
                  fontSize: 12,
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w500,
                  fontFamily: MyFonts.font_regular
              ),
            ),
          ),
          SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(16)),
            child: _buildContactInfo(
              name: orderDetailsViewModel.orderDetails.partnerId!.name.toString(),
              email: orderDetailsViewModel.orderDetails.partnerId!.countryId.toString(),
              phone: orderDetailsViewModel.orderDetails.partnerId!.phone.toString(),
            ),
          ),
          SizedBox(height: 24),

          // Address Section
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.brightBlue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'BILLING ADDRESS',
              style: TextStyle(
                  fontSize: 12,
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w500,
                  fontFamily: MyFonts.font_regular
              ),
            ),
          ),
          SizedBox(height: 16),
          _buildAddressCard(
            address: orderDetailsViewModel.orderDetails.partnerId!.street.toString(),
            unit: orderDetailsViewModel.orderDetails.partnerId!.street2.toString(),
            city: orderDetailsViewModel.orderDetails.partnerId!.city.toString(),
            state: orderDetailsViewModel.orderDetails.partnerId!.stateId.toString(),
            zipCode: orderDetailsViewModel.orderDetails.partnerId!.countryId.toString(),
            isDefault: true,
          ),
        ],
      ),
    );
  }

  Widget _buildShippingDetails(OrderDetailsViewModel orderDetailsViewModel) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Delivery Method Section
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.brightBlue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'DELIVERY METHOD',
              style: TextStyle(
                  fontSize: 12,
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w500,
                  fontFamily: MyFonts.font_regular
              ),
            ),
          ),
          SizedBox(height: 16),
          _buildDeliveryMethod(
            method: 'Standard Delivery',
            estimate: 'Estimated delivery: 3-5 business days',
            status: orderDetailsViewModel.orderDetails.state,
          ),
          SizedBox(height: 24),

          // Shipping Address Section
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.brightBlue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'SHIPPING ADDRESS',
              style: TextStyle(
                  fontSize: 12,
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w500,
                  fontFamily: MyFonts.font_regular
              ),
            ),
          ),
          SizedBox(height: 16),
          _buildAddressCard(
            address: orderDetailsViewModel.orderDetails.partnerShippingId!.street.toString(),
            unit: orderDetailsViewModel.orderDetails.partnerShippingId!.street2.toString(),
            city: orderDetailsViewModel.orderDetails.partnerShippingId!.city.toString(),
            state:orderDetailsViewModel.orderDetails.partnerShippingId!.stateId.toString(),
            zipCode: orderDetailsViewModel.orderDetails.partnerShippingId!.zip.toString(),
            isDefault: false,
          ),
          SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: AppColors.whiteColor,
            ),
            child: _buildContactInfo(
              name: orderDetailsViewModel.orderDetails.partnerId!.name.toString(),
              email: orderDetailsViewModel.orderDetails.partnerId!.countryId.toString(),
              phone: orderDetailsViewModel.orderDetails.partnerId!.phone.toString(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo({
    required String name,
    required String email,
    required String phone,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person_outline, size: 20, color: Colors.grey[600]),
              SizedBox(width: 8),
              Text(
                name,
                style: TextStyle(
                    fontSize: 16,
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                    fontFamily: MyFonts.font_SemiBold
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.email_outlined, size: 20, color: Colors.grey[600]),
              SizedBox(width: 8),
              Text(
                email,
                style: TextStyle(
                    fontSize: 12,
                    color: AppColors.tabtxt_color,
                    fontWeight: FontWeight.w500,
                    fontFamily: MyFonts.font_regular
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.phone_outlined, size: 20, color: Colors.grey[600]),
              SizedBox(width: 8),
              Text(
                phone,
                style: TextStyle(
                    fontSize: 12,
                    color: AppColors.tabtxt_color,
                    fontWeight: FontWeight.w500,
                    fontFamily: MyFonts.font_regular
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard({
    required String address,
    required String unit,
    required String city,
    required String state,
    required String zipCode,
    required bool isDefault,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(12),
        color: isDefault ? Colors.grey[50] : Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_on_outlined,
                  size: 20, color: Colors.grey[600]),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      address,
                      style: TextStyle(
                          fontSize: 16,
                          color: AppColors.black,
                          fontWeight: FontWeight.w600,
                          fontFamily: MyFonts.font_regular
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      unit,
                      style: TextStyle(
                          fontSize: 12,
                          color: AppColors.tabtxt_color,
                          fontWeight: FontWeight.w500,
                          fontFamily: MyFonts.font_regular
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '$city, $state $zipCode',
                      style: TextStyle(
                          fontSize: 12,
                          color: AppColors.tabtxt_color,
                          fontWeight: FontWeight.w500,
                          fontFamily: MyFonts.font_regular
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (isDefault) ...[
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.lightBlue,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Default Address',
                style: TextStyle(
                    fontSize: 12,
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w500,
                    fontFamily: MyFonts.font_regular
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDeliveryMethod({
    required String method,
    required String estimate,
    required String status,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.local_shipping_outlined,
                      size: 20, color: Colors.grey[600]),
                  SizedBox(width: 8),
                  Text(
                    method,
                    style: TextStyle(
                        fontSize: 15,
                        color: AppColors.tabtxt_color,
                        fontWeight: FontWeight.w600,
                        fontFamily: MyFonts.font_SemiBold
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.orange[800],
                    fontWeight: FontWeight.w500,
                    fontFamily: MyFonts.font_SemiBold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.only(left: 28),
            child: Text(
              estimate,
              style: TextStyle(
                  fontSize: 12,
                  color: AppColors.tabtxt_color,
                  fontWeight: FontWeight.w500,
                  fontFamily: MyFonts.font_regular
              ),
            ),
          ),
        ],
      ),
    );
  }

// ... (rest of the code remains the same)
}
