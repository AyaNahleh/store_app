import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shop_app/users/controllers/order_now_controller.dart';
import 'package:shop_app/users/order/order_confirm_screen.dart';

import '../../constants/my_colors.dart';

class OrderNowScreen extends StatelessWidget {
  OrderNowScreen(
      {Key? key,
      required this.selectedCartListItem,
      required this.totalAmount,
      required this.cartIdList})
      : super(key: key);
  final List<Map<String, dynamic>> selectedCartListItem;
  final double totalAmount;
  final List<int> cartIdList;

  final List<String> deliverySystemNameList = [
    "FedEx",
    "DHL",
    "United Parcel Service"
  ];
 final List<String> paymentSystemNameList = [
    "Apple Pay",
    "Wire Transfer",
    "Google Pay"
  ];
  final TextEditingController phoneNumber = TextEditingController();
  final TextEditingController shipmentAddress = TextEditingController();
  final TextEditingController noteToSeller = TextEditingController();

  displaySelectedItem() {
    return Column(
      children: List.generate(selectedCartListItem.length, (index) {
        Map<String, dynamic> eachSelectedItem = selectedCartListItem[index];
        return Container(
          margin: EdgeInsets.fromLTRB(16, index == 0 ? 16 : 8, 16,
              index == selectedCartListItem.length - 1 ? 16 : 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: MyColors.white,
            boxShadow: const [
              BoxShadow(
                  offset: Offset(0, 0), blurRadius: 6, color: MyColors.mediumGray)
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    topLeft: Radius.circular(20)),
                child: FadeInImage(
                    height: 150,
                    width: 130,
                    fit: BoxFit.cover,
                    placeholder: const AssetImage("assets/place_holder.png"),
                    image: NetworkImage(eachSelectedItem["image"]),
                    imageErrorBuilder: (context, error, stackTrackError) {
                      return const Center(
                        child: Icon(Icons.broken_image_outlined),
                      );
                    }),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Details:",
                        style:  TextStyle(
                            fontSize: 18,
                            color: MyColors.darkBlue,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Text(
                            "Name :",
                            style:  TextStyle(
                                fontSize: 12,
                                color: MyColors.darkGray,
                                fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            eachSelectedItem["name"],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: 12,
                              color: MyColors.darkGray,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Row(
                        children: [
                          const Text(
                            "Size :",
                            style:  TextStyle(
                                fontSize: 12,
                                color: MyColors.darkGray,
                                fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            eachSelectedItem["size"]
                                .replaceAll("[", "")
                                .replaceAll("]", "") ,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: 12,
                              color: MyColors.darkGray,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Row(
                        children: [
                          const Text(
                            "Color :",
                            style:  TextStyle(
                                fontSize: 12,
                                color: MyColors.darkGray,
                                fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            eachSelectedItem["color"]
                                .replaceAll("[", "")
                                .replaceAll("]", "") ,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: 12,
                              color: MyColors.darkGray,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 6,
                      ),
                      Row(
                        children: [
                          const Text(
                            "Price :",
                            style:  TextStyle(
                                fontSize: 12,
                                color: MyColors.darkGray,
                                fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "\$${eachSelectedItem["totalAmount"]}",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: 12,
                              color: MyColors.darkGray,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Row(
                        children: [
                          const Text(
                            "Q :",
                            style:  TextStyle(
                                fontSize: 12,
                                color: MyColors.darkGray,
                                fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "${eachSelectedItem["quantity"]}",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: 12,
                              color: MyColors.darkGray,
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  final OrderNowController orderNowController = Get.put(OrderNowController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.darkBlue,
        title: const Text("Order Now"),
        titleSpacing: 0,
      ),
      backgroundColor: MyColors.lightGray,
      body: ListView(
        children: [
          displaySelectedItem(),
          const SizedBox(
            height: 30,
          ),
          const Padding(
            padding:  EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Delivery System:",
              style: TextStyle(
                fontSize: 16,
                color: MyColors.darkBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: deliverySystemNameList.map((e) {
                return Obx(() => RadioListTile<String>(
                      value: e,
                      groupValue: orderNowController.deliverySystem,
                      onChanged: (newDeliverySystem) {
                        orderNowController
                            .setDeliverySystem(newDeliverySystem!);
                      },
                      tileColor: MyColors.mediumGray.withOpacity(0.7),
                      dense: true,
                      activeColor: MyColors.darkBlue,
                      title: Text(
                        e,
                        style: const TextStyle(fontSize: 16, color: MyColors.white),
                      ),
                    ));
              }).toList(),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Payment System:",
                  style: TextStyle(
                    fontSize: 16,
                    color: MyColors.darkBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  "Company Account Number / ID: \n Y87Y-HJF9-CVBN-4321",
                  style: TextStyle(
                    fontSize: 14,
                    color: MyColors.mediumGray,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: paymentSystemNameList.map((e) {
                return Obx(() => RadioListTile<String>(
                      value: e,
                      groupValue: orderNowController.paymentSystem,
                      onChanged: (newPaymentSystem) {
                        orderNowController.setPaymentSystem(newPaymentSystem!);
                      },
                      tileColor: MyColors.mediumGray.withOpacity(0.7),
                      dense: true,
                      activeColor: MyColors.darkBlue,
                      title: Text(
                        e,
                        style: const TextStyle(fontSize: 16, color: MyColors.white),
                      ),
                    ));
              }).toList(),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          const Padding(
            padding:  EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Phone Number:",
              style: TextStyle(
                fontSize: 16,
                color: MyColors.darkBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: TextField(
              style: const TextStyle(color: MyColors.darkGray),
              controller: phoneNumber,
              decoration: InputDecoration(
                hintText: "phone number",
                hintStyle: const TextStyle(color: MyColors.mediumGray),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: MyColors.darkBlue, width: 2)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: MyColors.darkGray, width: 2)),
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          const Padding(
            padding:  EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Shipment address:",
              style: TextStyle(
                fontSize: 16,
                color: MyColors.darkBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: TextField(
              style: const TextStyle(color: MyColors.darkGray),
              controller: shipmentAddress,
              decoration: InputDecoration(
                hintText: "Shipment Address",
                hintStyle: const TextStyle(color: MyColors.mediumGray),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: MyColors.darkBlue, width: 2)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: MyColors.darkGray, width: 2)),
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          const Padding(
            padding:  EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Note to Seller:",
              style: TextStyle(
                fontSize: 16,
                color: MyColors.darkBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: TextField(
              style: const TextStyle(color: MyColors.darkGray),
              controller: noteToSeller,
              decoration: InputDecoration(
                hintText: "Add Note",
                hintStyle: const TextStyle(color: MyColors.mediumGray),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: MyColors.darkBlue, width: 2)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: MyColors.darkGray, width: 2)),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Material(
              color: MyColors.darkBlue,
              borderRadius: BorderRadius.circular(30),
              child: InkWell(
                onTap: () {
                  if(phoneNumber.text.isNotEmpty && shipmentAddress.text.isNotEmpty){
                    Get.to(OrderConfirmScreen(
                        selectedCartId:cartIdList,
                        selectedCartListItem:selectedCartListItem,
                        totalAmount:totalAmount,
                        deliverySystem:orderNowController.deliverySystem,
                        paymentSystem:orderNowController.paymentSystem,
                        phoneNumber:phoneNumber.text,
                        shipmentAddress:shipmentAddress.text,
                        note:noteToSeller.text

                    ));
                  }else{
                    Fluttertoast.showToast(msg: "please complete the form");
                  }

                },
                borderRadius: BorderRadius.circular(30),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Text(
                        "\$${totalAmount.toStringAsFixed(2)}",
                        style: const TextStyle(
                            color: MyColors.lightGray,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      const Text(
                        "Pay Now",
                        style: TextStyle(
                            color: MyColors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
