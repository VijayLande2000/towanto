import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:towanto/viewModel/CartViewModels/delete_Cartitem_viewModel.dart';

import '../../model/CartModels/cart_items_list_model.dart';
import '../../utils/common_widgets/PreferencesHelper.dart';
import '../../utils/common_widgets/Utils.dart';
import '../../utils/resources/colors.dart';
import '../../utils/resources/fonts.dart';
import '../../viewModel/CartViewModels/cart_list_view_model.dart';
import '../../viewModel/CartViewModels/updateCart_viewModel.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String? partnerId = ""; // Example category ID
  String? sessionId = ""; // Example session ID

  @override
  void initState() {
    super.initState();
    // Call the API to fetch cart items when the screen is loaded
    _fetchCartItems();
  }

  // Method to call the API to fetch cart items
  Future<void> _fetchCartItems() async {
    partnerId = await PreferencesHelper.getString("partnerId");
    sessionId = await PreferencesHelper.getString("session_id");
    final cartListViewModel = Provider.of<CartListViewModel>(context, listen: false);
    cartListViewModel.cartListViewModelApi(partnerId!, sessionId!, context);
  }
  // Method to update the quantity of an item
  bool increment =false;
  Map<String, bool> _loadingMap = {};  // Map to store the loading state for each item
  bool decrement =false;

Future<void> deleteCartItem(String id) async {
  setState(() {
    _loadingMap[id] = true; // Set the loading state of this item to true
  });
  final deletecartitemViewModel = Provider.of<DeleteCartItemViewModel>(context,listen: false);
   final cartListViewModel = Provider.of<CartListViewModel>(context, listen: false);
    await deletecartitemViewModel.deleteCartItemViewModelApi(partnerId!, id, context, sessionId!);
    await cartListViewModel.updateCartListApi(partnerId!, sessionId!, context);
  setState(() {
    _loadingMap[id] = false; // Reset loading state after operation
  });
}

  void updateQuantity(int index, bool increase) async {
    final cartListViewModel = Provider.of<CartListViewModel>(context, listen: false);
    final updateCartViewModel = Provider.of<UpdateCartViewModel>(context, listen: false);
    final cartItems = cartListViewModel.cartItemsList
        .expand((cartItem) => cartItem.products)
        .toList();

    if (increase) {
      setState(() {
        increment = true; // Set increment loading state
        cartItems[index].productUomQty++;
      });

      // Perform async update
      await updateCartViewModel.updateCart(
        cartItems[index].id.toString(),
        cartItems[index].productUomQty.toString(),
        context,
      );

      // Reset loading state after async operation
      setState(() {
        increment = false;
      });
    } else {
      if (cartItems[index].productUomQty > 1) {
        setState(() {
          decrement = true; // Set decrement loading state
          cartItems[index].productUomQty--;
        });

        // Perform async update
        await updateCartViewModel.updateCart(
          cartItems[index].id.toString(),
          cartItems[index].productUomQty.toString(),
          context,
        );

        // Reset loading state after async operation
        setState(() {
          decrement = false;
        });
      }
    }
  }
  double _totalTax = 0.0;
  double _totalDiscount = 0.0;
  double _totalSubtotal = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundcolormenu,
      appBar: AppBar(
        backgroundColor: AppColors.brightBlue,
        title: Text("Cart", style: TextStyle(
          fontSize: 20,
          color:  AppColors.black,
          fontWeight: FontWeight.bold,
          fontFamily: MyFonts.LexendDeca_Bold
      ),),

        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: AppColors.black,size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<CartListViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.loading) {
            return Center(child: CircularProgressIndicator());
          }
          if (viewModel.cartItemsList.isEmpty) {
            return Center(child: Text("No items in your cart.",
                style: TextStyle(fontSize: 18, color: Colors.black54)));
          }
          // Get all products from the cart items
          final cartItems = viewModel.cartItemsList
              .expand((cartItem) => cartItem.products)
              .toList();

          // Display all products
          return  Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    // _totalTax += item.priceTax.toDouble();
                    // _totalDiscount += item.discount.toDouble();
                    // _totalSubtotal += (item.priceSubtotal.toDouble());
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
                          // Product Image
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              // color: Colors.orange[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Image.network(
                              "https://towanto-ecommerce-mainbranch-16118324.dev.odoo.com/web/image?model=product.product&id=${cartItems[index].id.toString()}&field=image_1920"
                            )
                          ),
                          const SizedBox(width: 16),
                          // Product Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cartItems[index].productId.toString(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      color:  AppColors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: MyFonts.LexendDeca_Bold
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '\$${cartItems[index].priceSubtotal}',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color:  AppColors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: MyFonts.LexendDeca_Bold
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Quantity Controls
                                Consumer<UpdateCartViewModel>(
                                  builder: (context, updateCartViewModel, child) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey.shade300),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: updateCartViewModel.loading && decrement
                                                ? SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(strokeWidth: 2),
                                            )
                                                : const Icon(Icons.remove, color: AppColors.black),
                                            onPressed: updateCartViewModel.loading ? null : () => updateQuantity(index, false),
                                            padding: const EdgeInsets.all(4),
                                            constraints: const BoxConstraints(),
                                            iconSize: 20,
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8),
                                            child: Text(
                                              '${cartItems[index].productUomQty.toInt()}',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: AppColors.black,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: MyFonts.LexendDeca_Bold,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            icon: updateCartViewModel.loading && increment
                                                ? SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(strokeWidth: 2),
                                            )
                                                : const Icon(Icons.add, color: AppColors.black),
                                            onPressed: updateCartViewModel.loading ? null : () => updateQuantity(index, true),
                                            padding: const EdgeInsets.all(4),
                                            constraints: const BoxConstraints(),
                                            iconSize: 20,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),

                              ],
                            ),
                          ),
                          // Price and Remove Button
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const SizedBox(height: 8),
                              _loadingMap[item.id.toString()] == true ?
                              SizedBox(
                                height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(color: AppColors.brightBlue)):IconButton(
                                icon: const Icon(Icons.delete_outline),
                                color:AppColors.red,
                                onPressed: () {
                                  deleteCartItem(item.id.toString());
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
               SizedBox(height: 12.0,),
              _buildPriceRow('SubTotal', viewModel.totalSubtotal),
              _buildPriceRow('Tax',viewModel.totalTax),
              _buildPriceRow('Discount', viewModel.totalDiscount),

              // Checkout button at bottom
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Utils.createButton(text: " Checkout  (\$${viewModel.totalAmount.toString()})", onClick: (){

                }),
              )
              // CheckoutButton(
              //   totalAmount: viewModel.totalAmount,
              //   onPressed: () {
              //     // Handle checkout
              //   },
              // ),

            ],
          );
        },
      ),
    );
  }
}
Widget _buildPriceRow(String label, double amount, {bool isTotal = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 18),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
              fontSize: 16,
              color:  AppColors.black,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
              fontFamily: MyFonts.LexendDeca_Bold
          ),

         /* style: TextStyle(
            fontSize: 16,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
            color: Colors.black87,
          ),*/
        ),
        Text(
          '${amount.toStringAsFixed(2)}',
          style: TextStyle(
              fontSize: 16,
              color:  AppColors.black,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
              fontFamily: MyFonts.LexendDeca_Bold
          ),
        ),
      ],
    ),
  );
}

class CheckoutButton extends StatelessWidget {
  final double totalAmount;
  final VoidCallback onPressed;

  const CheckoutButton({
    Key? key,
    required this.totalAmount,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF8464C8), // Purple color
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
            elevation: 0,
          ),
          child: Text(
            'Checkout (\$${totalAmount.toStringAsFixed(2)})',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: MyFonts.LexendDeca_Bold,
            ),
          ),
        ),
      ),
    );
  }
}