import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:shop_app/api_connection/api_connection.dart';
import 'package:shop_app/users/fragments/dashboard_of_fragments.dart';
import 'package:shop_app/users/model/order.dart';
import 'package:shop_app/users/userPreferences/current_user.dart';

import '../../constants/my_colors.dart';
class OrderConfirmScreen extends StatelessWidget {
  final List<int>? selectedCartId;
  final List<Map<String, dynamic>>? selectedCartListItem;
  final double? totalAmount;
  final String? deliverySystem;
  final String? paymentSystem;
  final String? phoneNumber;
  final String? shipmentAddress;
  final String? note;

   OrderConfirmScreen(
      {Key? key,
      this.selectedCartId,
      this.selectedCartListItem,
      this.totalAmount,
      this.deliverySystem,
      this.paymentSystem,
      this.phoneNumber,
      this.shipmentAddress,
      this.note})
      : super(key: key);


  final RxList<int> _imageSelectedByte = <int>[].obs;


  Uint8List get imageSelectedByte => Uint8List.fromList(_imageSelectedByte);
  final RxString _imageSelectedName = "".obs;

  String get imageSelectedName => _imageSelectedName.value;
  final ImagePicker _picker = ImagePicker();

  setSelectedImage(Uint8List selectedImage) {
    _imageSelectedByte.value = selectedImage;
  }

  setSelectedImageName(String selectedImage) {
    _imageSelectedName.value = selectedImage;
  }
  final CurrentUser currentUser=Get.put(CurrentUser());

  chooseImageFromGallery()async{
   final pickedImageXFile = await _picker.pickImage(source: ImageSource.camera);
  if(pickedImageXFile !=null){
    final bytesOfImage=await pickedImageXFile.readAsBytes();
    setSelectedImage(bytesOfImage);
    setSelectedImageName(path.basename(pickedImageXFile.path));
  }
  }
  saveOrderInfo()async{

    String selectedItemString=selectedCartListItem!.map((e) =>jsonEncode(e)).toList().join("||");
    Order order=Order(
      orderId: 1,
      userId: currentUser.user.userId,
      selectedItem: selectedItemString,
      deliverySystem: deliverySystem,
      paymentSystem: paymentSystem,
      note: note,
      totalAmount: totalAmount,
      image: "${DateTime.now().millisecondsSinceEpoch}-$imageSelectedName",
      status: "new",
      dateTime: DateTime.now(),
      shipmentAddress: shipmentAddress,
      phoneNumber: phoneNumber
    );
    try{

      var res=await http.post(Uri.parse(Api.addOrder),
      body: order.toJson(base64Encode(imageSelectedByte)),
      );
      if(res.statusCode==200){
        var response=jsonDecode(res.body);
        if(response["success"]){
          for (var element in selectedCartId!) {
            deleteSelectedItemFormCartList(element);
          }
        }
        else{
          Fluttertoast.showToast(msg: "error");
        }
      }

    }catch(e){
      throw("error");

    }


  }

  deleteSelectedItemFormCartList(int cartID)async{
    try{
      var res=await http.post(Uri.parse(Api.deleteSelectedItem),
          body: {
            "cart_id":cartID.toString()
          });
      if(res.statusCode==200){
        var responseBody=jsonDecode(res.body);
        if(responseBody["success"]){
          Fluttertoast.showToast(msg: "your new order has been placed successfully.");
          Get.to(DashboardOfFragments());
        }
      }else{
        throw("error");
      }

    }catch(e){
      throw(e.toString());
    }


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.lightGray,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Image.asset(
              "assets/transaction.png",
              width: 160,
            ),

            const SizedBox(
              height: 4,
            ),
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                "Please Attach Transaction \n Proof / Screenshot",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: MyColors.mediumGray,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Material(
              elevation: 0,
              color: MyColors.darkBlue,
              borderRadius: BorderRadius.circular(30),
              child: InkWell(
                onTap: () {
                  chooseImageFromGallery();
                },
                borderRadius: BorderRadius.circular(30),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  child: Text(
                    "Select Image",
                    style: TextStyle(color: MyColors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Obx(
              () => ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                    maxHeight: MediaQuery.of(context).size.width * 0.6,
                  ),
                  child: imageSelectedByte.isNotEmpty
                      ? Image.memory(
                          imageSelectedByte,
                          fit: BoxFit.contain,
                        )
                      : const Placeholder(
                          color: MyColors.mediumGray,
                        )),
            ),
            const SizedBox(
              height: 16,
            ),
            Obx(() => Material(
                  elevation: 8,
                  color: imageSelectedByte.isNotEmpty
                      ? MyColors.darkBlue
                      : MyColors.darkGray,
                  borderRadius: BorderRadius.circular(30),
                  child: InkWell(
                    onTap: () {
                      if (imageSelectedByte.isNotEmpty) {
                        saveOrderInfo();
                      } else {
                        Fluttertoast.showToast(
                            msg:
                                "Please Attach proof / screenshot for the transaction");
                      }
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      child: Text(
                        "Confirmed & Proceed",
                        style: TextStyle(color: MyColors.white, fontSize: 16),
                      ),
                    ),
                  ),
                )),

          ],
        ),
      ),
    );
  }
}
