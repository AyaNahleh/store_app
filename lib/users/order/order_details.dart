import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/api_connection/api_connection.dart';
import 'package:http/http.dart' as http;
import '../../constants/my_colors.dart';
import '../model/order.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({Key? key, required this.clickedOrderInfo})
      : super(key: key);
  final Order clickedOrderInfo;

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final RxString _status = "new".obs;
  String get status => _status.value;

  updateStatus(String received) {
    _status.value = received;
  }

  showDialogForConfirm() async {
    if (widget.clickedOrderInfo.status == "new") {
      var res = await Get.dialog(AlertDialog(
        backgroundColor: MyColors.white,
        title: const Text(
          "Confirmation",
          style: TextStyle(color: MyColors.darkBlue),
        ),
        content: const Text(
          "Have you received your parcel?",
          style: TextStyle(color: MyColors.darkGray),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text(
                  "No",
                  style: TextStyle(color: MyColors.red),
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.back(result:"yes");
                },
                child: const Text(
                  "Yes",
                  style: TextStyle(color: MyColors.green),
                ),
              ),
            ],
          )
        ],
      ));
      if(res=="yes"){
        updateStatusValue();

      }
    }
  }
  updateStatusValue()async{
    try{
      var res=await http.post(Uri.parse(Api.updateStatus),
      body: {
        "order_id":widget.clickedOrderInfo.orderId.toString()
      }
      );
      if(res.statusCode==200){
        var response=jsonDecode(res.body);
        if(response["success"]){
          updateStatus("arrived");
        }
      }
    }catch(e){
      throw(e.toString());
    }
  }
  
  @override
  void initState() {
    updateStatus(widget.clickedOrderInfo.status!.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.lightGray,
      appBar: AppBar(
        backgroundColor: MyColors.darkBlue,
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
            child: InkWell(
              onTap: () {
                if(status=="new"){
                  showDialogForConfirm();
                }
              },
              borderRadius: BorderRadius.circular(30),
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 8,
                    ),
                    Obx(() => status == "new"
                        ? const Icon(
                            Icons.help_center_sharp,
                            color: MyColors.red,
                          )
                        : const Icon(
                            Icons.check_circle_outline,
                            color: MyColors.green,
                          )),
                  ],
                ),
              ),
            ),
          ),
        ],
        title: Text(
          DateFormat("dd MMMM, yyyy")
              .format(widget.clickedOrderInfo.dateTime!),
          style: const TextStyle(fontSize: 14),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              displayOrderItem(),
              const SizedBox(
                height: 16,
              ),
              showTitle("Phone Number :"),
              const SizedBox(
                height: 8,
              ),
              showContentText(widget.clickedOrderInfo.phoneNumber!),
              const SizedBox(
                height: 16,
              ),
              showTitle("Shipment Address :"),
              const SizedBox(
                height: 8,
              ),
              showContentText(widget.clickedOrderInfo.shipmentAddress!),
              const SizedBox(
                height: 16,
              ),
              showTitle("Delivery System :"),
              const SizedBox(
                height: 8,
              ),
              showContentText(widget.clickedOrderInfo.deliverySystem!),
              const SizedBox(
                height: 16,
              ),
              showTitle("Payment System :"),
              const SizedBox(
                height: 8,
              ),
              showContentText(widget.clickedOrderInfo.paymentSystem!),
              const SizedBox(
                height: 16,
              ),
              showTitle("Note :"),
              const SizedBox(
                height: 8,
              ),
              showContentText(widget.clickedOrderInfo.note!),
              const SizedBox(
                height: 16,
              ),
              showTitle("Total Amount :"),
              const SizedBox(
                height: 8,
              ),
              showContentText(widget.clickedOrderInfo.totalAmount.toString()),
              const SizedBox(
                height: 26,
              ),
              showTitle("Proof of Payment:"),
              const SizedBox(
                height: 8,
              ),
              FadeInImage(
                  width: MediaQuery.of(context).size.width * 0.8,
                  fit: BoxFit.fitWidth,
                  placeholder: const AssetImage("assets/place_holder.png"),
                  image: NetworkImage(
                      Api.hostImages + widget.clickedOrderInfo.image!),
                  imageErrorBuilder: (context, error, stackTrackError) {
                    return const Center(
                      child: Icon(Icons.broken_image_outlined),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget showTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
          fontWeight: FontWeight.bold, fontSize: 20, color: MyColors.darkBlue),
    );
  }

  Widget showContentText(String content) {
    return Text(
      content,
      style: const TextStyle(fontSize: 14, color: MyColors.darkGray),
    );
  }

  displayOrderItem() {
    List<String> clickedOrderInfo =
        widget.clickedOrderInfo.selectedItem!.split("||");
    return Column(
      children: List.generate(clickedOrderInfo.length, (index) {
        Map<String, dynamic> itemInfo = jsonDecode(clickedOrderInfo[index]);
        return Container(
          margin: EdgeInsets.fromLTRB(16, index == 0 ? 16 : 8, 16,
              index == clickedOrderInfo.length - 1 ? 16 : 8),
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
                    image: NetworkImage(itemInfo["image"]),
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
                            itemInfo["name"],
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
                            itemInfo["size"]
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
                            itemInfo["color"]
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
                            "\$${itemInfo["totalAmount"]}",
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
                            "${itemInfo["quantity"]}",
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
}
