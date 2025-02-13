import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:towanto/view/Home/home_screen.dart';
import 'package:towanto/viewModel/CartViewModels/delete_Cartitem_viewModel.dart';

import '../../model/CartModels/cart_items_list_model.dart';
import '../../utils/common_widgets/PreferencesHelper.dart';
import '../../utils/common_widgets/Utils.dart';
import '../../utils/network/networkService/app_url.dart';
import '../../utils/resources/colors.dart';
import '../../utils/resources/fonts.dart';
import '../../viewModel/CartViewModels/cart_list_view_model.dart';
import '../../viewModel/CartViewModels/updateCart_viewModel.dart';
import '../Payments/check_out_flow.dart';
import '../Payments/checkout_address_screen.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String? partnerId = "";
  String? sessionId = "";
  // Maps to store loading states for different operations
  Map<String, bool> _deleteLoadingMap = {};
  Map<String, bool> _incrementLoadingMap = {};
  Map<String, bool> _decrementLoadingMap = {};

  @override
  void initState() {
    super.initState();
    _fetchCartItems();
  }

  Future<void> _fetchCartItems() async {
    partnerId = await PreferencesHelper.getString("partnerId");
    sessionId = await PreferencesHelper.getString("session_id");
    final cartListViewModel = Provider.of<CartListViewModel>(context, listen: false);
    cartListViewModel.cartListViewModelApi(partnerId!, sessionId!, context);
  }

  Future<void> deleteCartItem(String id,String prodcutId) async {
    setState(() {
      _deleteLoadingMap[id] = true;
    });
    final deletecartitemViewModel = Provider.of<DeleteCartItemViewModel>(context, listen: false);
    final cartListViewModel = Provider.of<CartListViewModel>(context, listen: false);
    await deletecartitemViewModel.deleteCartItemViewModelApi(partnerId!, id, context, sessionId!,prodcutId);
    await cartListViewModel.updateCartListApi(partnerId!, sessionId!, context);
    setState(() {
      _deleteLoadingMap[id] = false;
    });
  }

  Future<void> updateQuantity(int index, bool increase, String itemId) async {
    final cartListViewModel = Provider.of<CartListViewModel>(context, listen: false);
    final updateCartViewModel = Provider.of<UpdateCartViewModel>(context, listen: false);
    final cartItems = cartListViewModel.cartItemsList
        .expand((cartItem) => cartItem.products)
        .toList();

    if (increase) {
      setState(() {
        _incrementLoadingMap[itemId] = true;
        cartItems[index].productUomQty++;
      });

      await updateCartViewModel.updateCart(
        itemId,
        cartItems[index].productUomQty.toString(),
        context,
      );
      await cartListViewModel.updateCartListApi(partnerId!, sessionId!, context);
      setState(() {
        _incrementLoadingMap[itemId] = false;
      });
    } else {
      if (cartItems[index].productUomQty > 1) {
        setState(() {
          _decrementLoadingMap[itemId] = true;
          cartItems[index].productUomQty--;
        });

        await updateCartViewModel.updateCart(
          itemId,
          cartItems[index].productUomQty.toString(),
          context,
        );
        await cartListViewModel.updateCartListApi(partnerId!, sessionId!, context);

        setState(() {
          _decrementLoadingMap[itemId] = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundcolormenu,
      appBar: AppBar(
        // backgroundColor: AppColors.brightBlue,
        title: Text(
          "Cart",
          style: TextStyle(
              fontSize: 20,
              // color: AppColors.black,
              fontWeight: FontWeight.bold,
              fontFamily: MyFonts.font_regular
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 20),
          onPressed: () => {
            Navigator.pop(context)
            // Navigator.push(context, MaterialPageRoute(builder: (context) => HomeGrid(),))
          }
        ),
      ),
      body: Consumer<CartListViewModel>(
        builder: (context, viewModel, child) {
          final cartItems = viewModel.cartItemsList
              .expand((cartItem) => cartItem.products)
              .toList();
          if (viewModel.loading) {
            return Utils.loadingIndicator(context);
          }
          if (cartItems.isEmpty) {
            return Center(

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     LottieBuilder.asset(
                      "assets/lottie/empty_box_cart.json",
                       width: 200,
                       height: 200,
                    ),
                    Text(
                        "No items in your cart.",
                        style: TextStyle(
                          color: AppColors.black,
                          fontFamily: MyFonts.font_regular,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        )
                    ),
                  ],
                )
            );
          }



          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    final itemId = item.id.toString();
                    final productId = item.productId[0];


                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Image.network(
                                  "${AppUrl.baseurlauth}web/image?model=product.product&id=$productId&field=image_1920"
                              )
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.productId.toString(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: MyFonts.font_regular
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '\$${item.priceSubtotal}',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: MyFonts.font_regular
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: _decrementLoadingMap[itemId] == true
                                            ? SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(strokeWidth: 2),
                                        )
                                            : const Icon(Icons.remove, color: AppColors.black),
                                        onPressed: (_decrementLoadingMap[itemId] == true || _incrementLoadingMap[itemId] == true)
                                            ? null
                                            : () => updateQuantity(index, false, itemId),
                                        padding: const EdgeInsets.all(4),
                                        constraints: const BoxConstraints(),
                                        iconSize: 20,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                        child: Text(
                                          '${item.productUomQty.toInt()}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: AppColors.black,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: MyFonts.font_regular,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: _incrementLoadingMap[itemId] == true
                                            ? SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(strokeWidth: 2),
                                        )
                                            : const Icon(Icons.add, color: AppColors.black),
                                        onPressed: (_decrementLoadingMap[itemId] == true || _incrementLoadingMap[itemId] == true)
                                            ? null
                                            : () => updateQuantity(index, true, itemId),
                                        padding: const EdgeInsets.all(4),
                                        constraints: const BoxConstraints(),
                                        iconSize: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const SizedBox(height: 8),
                              _deleteLoadingMap[itemId] == true
                                  ? SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(color: AppColors.brightBlue)
                              )
                                  : IconButton(
                                icon: const Icon(Icons.delete_outline),
                                color: AppColors.red,
                                onPressed: () => deleteCartItem(itemId,productId.toString()),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 12.0),
              _buildPriceRow('SubTotal', viewModel.totalAmount),
              _buildPriceRow('Tax', viewModel.totalTax),
              _buildPriceRow('Discount', viewModel.totalDiscount),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Utils.createButton(
                  text: " Checkout  (\₹ ${viewModel.totalAmount.toString()})",
                  onClick: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CheckoutFlowScreen(),));

                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

Widget _buildPriceRow(String label, double amount, {bool isTotal = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 18),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
              fontSize: 16,
              color: AppColors.black,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
              fontFamily: MyFonts.font_regular
          ),
        ),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: TextStyle(
              fontSize: 16,
              color: AppColors.black,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
              fontFamily: MyFonts.font_regular
          ),
        ),
      ],
    ),
  );
}