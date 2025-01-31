import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:towanto/view/Home/home_screen.dart';
import 'package:towanto/viewModel/OrdersViewModels/orders_list_view_model.dart';

import '../../utils/common_widgets/PreferencesHelper.dart';
import '../../utils/common_widgets/Utils.dart';
import '../../utils/resources/colors.dart';
import '../../utils/resources/fonts.dart';
import 'order_details_screen.dart';

class Order {
  final String id;
  final double amount;
  final DateTime date;
  final String? imageUrl;

  Order({
    required this.id,
    required this.amount,
    required this.date,
    this.imageUrl,
  });
}

class OrdersListScreen extends StatefulWidget {
  OrdersListScreen({super.key});

  @override
  State<OrdersListScreen> createState() => _OrdersListScreenState();
}

class _OrdersListScreenState extends State<OrdersListScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getOrdersListApiCall();
    });
    // TODO: implement initState
    super.initState();
  }

  Future<void> getOrdersListApiCall() async {
    final provider = Provider.of<OrdersListViewModel>(context, listen: false);
    final sessionId = await PreferencesHelper.getString("session_id");
    final partner_id = await PreferencesHelper.getString("partnerId");
    provider.ordersListViewModelApi(partner_id!, sessionId!, context);
  }

  final List<Order> orders = [
    Order(
      id: '286',
      amount: 250.00,
      date: DateTime.parse('2025-01-10 11:48:27'),
      imageUrl: null,
    ),
    Order(
      id: '284',
      amount: 285750.00,
      date: DateTime.parse('2025-01-09 12:55:32'),
      imageUrl: 'assets/padora.png',
    ),
    // Add more orders here
  ];

  String formattedDate(String dateString) {
    try {
      // Parse the date string into DateTime
      DateTime parsedDate = DateTime.parse(dateString);  // Use DateFormat if the string format is custom
      return DateFormat('dd MMM yyyy, hh:mm a').format(parsedDate);
    } catch (e) {
      return 'Invalid Date';  // Fallback in case the string is not a valid date
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundcolormenu,
      appBar: AppBar(
        // backgroundColor: AppColors.brightBlue,
        title: Text("Orders List",
          style: TextStyle(
            fontSize: 20,
            // color:  AppColors.black,
            fontWeight: FontWeight.bold,
            fontFamily: MyFonts.LexendDeca_Bold
        ),
        ),

        leading: IconButton(
          icon: Icon(Icons.arrow_back,size: 20),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HomeGrid(),))
        ),
      ),

      body: Consumer<OrdersListViewModel>(builder: (context, viewModel, child) {
        if (viewModel.loading) {
          return Center(child: Utils.loadingIndicator(context));
        }
        if (viewModel.ordersItemsList.isEmpty) {
          return Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.height * 0.6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LottieBuilder.asset(
                    "assets/lottie/empty_order_items.json",
                  ),
                  Text(
                      "No orders",
                      style: TextStyle(
                        color: AppColors.black,
                        fontFamily: MyFonts.LexendDeca_Bold,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      )
                  ),
                ],

              ),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: viewModel.ordersItemsList.length,
          itemBuilder: (context, index) {
            final order = viewModel.ordersItemsList[index];
            return InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetailsScreen(orderId: order.id),));
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Card(
                  color: AppColors.whiteColor,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: AppColors.brightBlue,
                            width: 5,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: order.id != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        "https://towanto-ecommerce-mainbranch-16118324.dev.odoo.com/web/image?model=product.product&id=${order.id}&field=image_1920",
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Icon(
                                      Icons.image_not_supported_outlined,
                                      size: 40,
                                      color: Colors.grey[400],
                                    ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            '${order.name}',
                                            style: TextStyle(
                                                fontSize: 18,
                                                color:  AppColors.tabtxt_color,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: MyFonts.LexendDeca_SemiBold
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color:AppColors.lightBlue,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          order.state.toString(),
                                          style: TextStyle(
                                              fontSize: 14,
                                              color:  AppColors.whiteColor,
                                              fontWeight: FontWeight.normal,
                                              fontFamily: MyFonts.Lexenddeca_regular
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '₹${NumberFormat('#,##,##0.00').format(order.amountTotal)}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color:  AppColors.tabtxt_color,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: MyFonts.LexendDeca_Light
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    formattedDate(order.dateOrder),
                                    style: TextStyle(
                                        fontSize: 14,
                                        color:  AppColors.tabtxt_color,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: MyFonts.Lexenddeca_regular
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
