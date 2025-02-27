 import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:towanto/view/Payments/order_confirmation_screen.dart';
import 'package:towanto/viewModel/CartViewModels/check_out_review_view_model.dart';
import '../../utils/common_widgets/PreferencesHelper.dart';
import '../../utils/common_widgets/Utils.dart';
import '../../utils/network/networkService/app_url.dart';
import '../../utils/resources/colors.dart';
import '../../utils/resources/fonts.dart';
import '../../viewModel/OrdersViewModels/create_order_view_model.dart';

class CheckOutReviewScreen extends StatefulWidget {

  const CheckOutReviewScreen({super.key});

  @override
  State<CheckOutReviewScreen> createState() => _CheckOutReviewScreenState();
}

class _CheckOutReviewScreenState extends State<CheckOutReviewScreen>  {
  List<bool> _isExpanded = [false, false, false];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getCheckOutDetailsApiCall();
    });
  }

  void getCheckOutDetailsApiCall() {
    final provider = Provider.of<CheckOutReviewViewModel>(context, listen: false);
    provider.getCheckoutReview(context);
  }

  void _toggleExpansion(int index) {
    setState(() {
      _isExpanded[index] = !_isExpanded[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    final createOrderViewModel = Provider.of<CreateOrderViewModel>(context, listen: false);
    return Scaffold(
      backgroundColor: AppColors.backgroundcolormenu,
      body: Consumer<CheckOutReviewViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.loading) {
            return Center(child: Utils.loadingIndicator(context));
          }
          if (viewModel.orderDetails == null) {
            return Center(child: Text('No order details available'));
          }
          return Stack(
            children:[
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (viewModel.checkOutReview?.result?.reviewSummary?.message != null)
                      Container(
                        margin: EdgeInsets.fromLTRB(16, 16, 16, 8),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.brightBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.brightBlue.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: AppColors.brightBlue,
                              size: 20,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                viewModel.checkOutReview?.result?.reviewSummary?.message ?? "",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: MyFonts.font_regular,
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    _buildHorizontalOrderList(viewModel),
                    _buildExpandableSections(viewModel),
                  ],

                ),

              ),
              // Loader overlay
              // Loader overlay
              Consumer<CreateOrderViewModel>(
                builder: (context, viewModel, child) {
                  if (!viewModel.loading) return SizedBox.shrink(); // Hide if not loading
                  return Container(
                    child: Center(
                      child: Utils.loadingIndicator(context),
                    ),
                  );
                },
              ),
            ]
          );

        },
      ),
    );
  }

  Widget _buildHorizontalOrderList(CheckOutReviewViewModel viewModel) {
    final orderLines = viewModel.orderLines;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '${orderLines?.length ?? 0} ITEM${(orderLines?.length ?? 0) == 1 ? "" : "S"} ORDERED',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.black,
              fontWeight: FontWeight.bold,
              fontFamily: MyFonts.font_regular,
            ),
          ),
        ),
        SizedBox(height: 8),
        Container(
          // height: MediaQuery.of(context).size.height * 0.25,
          child: orderLines?.isNotEmpty == true
              ? SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                for (var orderLine in orderLines!)
                  Card(
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
                              child: Image.network(
                                "${AppUrl.baseurlauth}web/image?model=product.product&id=${orderLine.productId}&field=image_1920",
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) => Icon(
                                  Icons.error,
                                  size: 32,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            orderLine.productName ?? '',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: MyFonts.font_regular,
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
                              fontFamily: MyFonts.font_regular,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          )
              : Center(
            child: Text(
              'No items to display',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildExpandableSections(CheckOutReviewViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [

          _buildExpandableCard(
            title: 'BILLING DETAILS',
            index: 1,
            child: _buildBillingDetails(viewModel),
          ),
          SizedBox(height: 16),
          _buildExpandableCard(
            title: 'SHIPPING DETAILS',
            index: 2,
            child: _buildShippingDetails(viewModel),
          ),
          SizedBox(height: 16),
          _buildExpandableCard(
            title: 'PRICE DETAILS',
            index: 0,
            child: _buildPriceDetails(viewModel),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceDetails(CheckOutReviewViewModel viewModel) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Column(
        children: [
          _buildPriceRow('Subtotal', '₹${viewModel.orderDetails?.totalUntaxedAmount ?? 0}'),
          SizedBox(height: 8),
          _buildPriceRow('Shipping & Handling', '₹${viewModel.orderDetails?.deliveryCharges ?? 0}'),
          SizedBox(height: 8),
          _buildPriceRow('Tax', '₹${viewModel.orderDetails?.totalTaxAmount ?? 0}'),
          SizedBox(height: 8),
          _buildPriceRow('Discount', '₹${viewModel.orderDetails?.totalDiscountAmount ?? 0}'),
          Divider(height: 24),
          _buildPriceRow('Grand Total', '₹${viewModel.orderDetails?.totalAmount ?? 0}',
              isTotal: true),
        ],
      ),
    );
  }

  Widget _buildBillingDetails(CheckOutReviewViewModel viewModel) {
    final partnerId = viewModel.billingAddress;
    if (partnerId == null) return Container();

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
          _buildSectionHeader('CONTACT INFORMATION'),
          SizedBox(height: 16),
          _buildContactInfo(
            name: partnerId.name ?? '',
            email: partnerId.email ?? '',
            phone: partnerId.phone.toString() ?? '',
          ),
          SizedBox(height: 24),
          _buildSectionHeader('BILLING ADDRESS'),
          SizedBox(height: 16),
          _buildAddressCard(
            address: partnerId.street ?? '',
            unit:partnerId.street2!=false? partnerId.street2?.toString() ?? '':"",
            city: partnerId.city ?? '',
            state: partnerId.stateId ?? '',
            zipCode: partnerId.zip ?? '',
            isDefault: false,
          ),
        ],
      ),
    );
  }

  Widget _buildShippingDetails(CheckOutReviewViewModel viewModel) {
    final shippingAddress = viewModel.shippingAddress;
    if (shippingAddress == null) return Container();

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
          _buildSectionHeader('CONTACT INFORMATION'),
          SizedBox(height: 16),
          _buildContactInfo(
            name: shippingAddress.name ?? '',
            email: shippingAddress.email ?? '',
            phone: shippingAddress.phone ?? '',
          ),
          SizedBox(height: 24),
          _buildSectionHeader('DELIVERY METHOD'),
          SizedBox(height: 16),
          _buildDeliveryMethod(
            method: 'Standard Delivery',
            estimate: 'Estimated delivery: 3-5 business days',
            status: viewModel.orderDetails?.state ?? '',
          ),
          SizedBox(height: 24),
          _buildSectionHeader('SHIPPING ADDRESS'),
          SizedBox(height: 16),
          _buildAddressCard(
            address: shippingAddress.street ?? '',
            unit: shippingAddress.street2!=false?shippingAddress.street2?.toString() ?? '':"",
            city: shippingAddress.city ?? '',
            state: shippingAddress.stateId ?? '',
            zipCode: shippingAddress.zip.toString()?? '',
            isDefault: false,
          ),
        ],
      ),
    );
  }

  // Helper Widgets
  Widget _buildSectionHeader(String title) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.brightBlue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          color: AppColors.whiteColor,
          fontWeight: FontWeight.w500,
          fontFamily: MyFonts.font_regular,
        ),
      ),
    );
  }

  Widget _buildExpandableCard({
    required String title,
    required int index,
    required Widget child,
  })   {
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
                      fontFamily: MyFonts.font_regular,
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
            fontFamily: MyFonts.font_regular,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              color: isTotal ? AppColors.black : AppColors.tabtxt_color,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontFamily: MyFonts.font_regular),
        ),
      ],
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
                    fontFamily: MyFonts.font_regular
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          email.isEmpty ? SizedBox.shrink() : Row(
            children: [
              Icon(Icons.email_outlined, size: 20, color: Colors.grey[600]),
              SizedBox(width: 8),
              Expanded( // Prevents overflow
                child: Text(
                  email,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.tabtxt_color,
                    fontWeight: FontWeight.w500,
                    fontFamily: MyFonts.font_regular,
                  ),
                  overflow: TextOverflow.ellipsis, // Shows "..." when text is too long
                  maxLines: 1, // Keeps text in a single line
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
                    unit.isNotEmpty?Text(
                      unit,
                      style: TextStyle(
                          fontSize: 12,
                          color: AppColors.tabtxt_color,
                          fontWeight: FontWeight.w500,
                          fontFamily: MyFonts.font_regular
                      ),
                    ):SizedBox.shrink(),
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
              Expanded( // Wrap this Row inside Expanded to prevent overflow
                child: Row(
                  children: [
                    Icon(Icons.local_shipping_outlined,
                        size: 20, color: Colors.grey[600]),
                    SizedBox(width: 8),
                    Expanded( // Prevents text from overflowing
                      child: Text(
                        method,
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.tabtxt_color,
                          fontWeight: FontWeight.w600,
                          fontFamily: MyFonts.font_regular,
                        ),
                        overflow: TextOverflow.ellipsis, // Adds "..." if text is too long
                        maxLines: 1,
                        softWrap: false,
                      ),
                    ),
                  ],
                ),
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
                    fontFamily: MyFonts.font_regular,
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

}
