import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shop_app/users/model/order.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shop_app/users/order/history_screen.dart';
import 'package:shop_app/users/order/order_details.dart';

import '../../api_connection/api_connection.dart';
import '../../constants/my_colors.dart';
import '../userPreferences/current_user.dart';

class OrderFragmentScreen extends StatelessWidget {
  OrderFragmentScreen({Key? key}) : super(key: key);
  final currentOnlineUser = Get.put(CurrentUser());

  Future<List<Order>> getCurrentUserOrdersList() async {
    List<Order> orderListOfCurrentUser = [];

    try {
      var res = await http.post(Uri.parse(Api.readOrder), body: {
        "currentOnlineUserID": currentOnlineUser.user.userId.toString(),
      });

      if (res.statusCode == 200) {
        var responseBody = jsonDecode(res.body);
        if (responseBody['success']) {
          for (var element in (responseBody['currentUserOrderData'] as List)) {
            orderListOfCurrentUser.add(Order.fromJson(element));
          }
        }
      } else {
        Fluttertoast.showToast(msg: "something wrong");
      }
    } catch (e) {
      throw(e.toString());
    }

    return orderListOfCurrentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColors.lightGray,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:const EdgeInsets.fromLTRB(16, 23, 8, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Image.asset(
                        "assets/orders_icon.png",
                        width: 140,
                      ),
                      const Text(
                        "My Orders",
                        style: TextStyle(
                          color: MyColors.darkBlue,
                          fontSize: 24,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),

                  GestureDetector(
                    onTap: (){

                      Get.to(HistoryScreen());

                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Image.asset(
                            "assets/history_icon.png",
                            width: 40,
                          ),
                          const Text(
                            "History",
                            style: TextStyle(
                                color: MyColors.darkBlue,
                                fontSize: 12,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),
            Expanded(child: displayOrderList(context)),
          ],
        ));
  }

  Widget displayOrderList(context) {
    return FutureBuilder(
      future: getCurrentUserOrdersList(),
      builder: (context, AsyncSnapshot<List<Order>> dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return Column(
            children: const [
              Center(
                child: Text(
                  "Waiting",
                  style: TextStyle(color: MyColors.darkGray),
                ),
              ),
              Center(
                child: CircularProgressIndicator(),
              )
            ],
          );
        }
        if (dataSnapshot.data == null) {
          return Column(
            children: const [
              Center(
                child: Text(
                  "No Order Found",
                  style: TextStyle(color: MyColors.darkGray),
                ),
              ),
            ],
          );
        }
        if (dataSnapshot.data!.isNotEmpty) {
          List<Order> orderList = dataSnapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: orderList.length,
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 25,
              );
            },
            itemBuilder: (context, index) {
              Order eachOrderData = orderList[index];
              return Container(
                decoration:const BoxDecoration(
                    color: MyColors.white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        color: MyColors.gray,
                        offset: Offset(0, 0),
                      ),
                    ]
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: ListTile(
                    onTap: () {
                         Get.to(OrderDetailsScreen(
                           clickedOrderInfo:eachOrderData
                         ));
                    },
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Order ID #${eachOrderData.orderId}",
                          style: const TextStyle(
                              fontSize: 16,
                              color: MyColors.gray,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4,),
                        Text(
                          "Total Amount:\$${eachOrderData.totalAmount}",
                          style: const TextStyle(
                              fontSize: 16,
                              color: MyColors.darkBlue,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                             DateFormat(
                               "dd MMMM, yyyy"
                             ).format(eachOrderData.dateTime!),
                              style: const TextStyle(
                                color: MyColors.mediumGray
                              ),
                            ),
                            const SizedBox(height: 4,),
                            Text(
                              DateFormat(
                                  "hh:mm a"
                              ).format(eachOrderData.dateTime!),
                              style: const TextStyle(
                                  color:MyColors.mediumGray
                              ),
                            ),

                          ],
                        ),
                        const SizedBox(width: 6,),
                        const Icon(
                          Icons.navigate_next,
                          color: MyColors.darkBlue,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return Column(
            children: const [
              Center(
                child: Text(
                  "No Order Found",
                  style: TextStyle(color: MyColors.darkGray),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
