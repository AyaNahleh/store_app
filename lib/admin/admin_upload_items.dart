import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/admin/admin_get_all_orders.dart';
import 'package:shop_app/api_connection/api_connection.dart';
import 'package:shop_app/users/auth/login_screen.dart';

import '../constants/my_colors.dart';

class AdminUploadScreen extends StatefulWidget {
  const AdminUploadScreen({Key? key}) : super(key: key);

  @override
  State<AdminUploadScreen> createState() => _AdminUploadScreenState();
}

class _AdminUploadScreenState extends State<AdminUploadScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? pickedImageXFile;
  var formKey = GlobalKey<FormState>();
  var name = TextEditingController();
  var rating = TextEditingController();
  var tags = TextEditingController();
  var price = TextEditingController();
  var sizes = TextEditingController();
  var colors = TextEditingController();
  var description = TextEditingController();
  var imageLink = "";

  imageFromCamera() async {
    pickedImageXFile = await _picker.pickImage(source: ImageSource.camera);
    Get.back();
    setState(() {
      pickedImageXFile;
    });
  }

  imageFromGallery() async {
    pickedImageXFile = await _picker.pickImage(source: ImageSource.gallery);
    Get.back();

    setState(() {
      pickedImageXFile;
    });
  }

  showDialogBox() {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            backgroundColor: MyColors.lightGray,
            title: const Text(
              "Upload Photo",
              style: TextStyle(
                  color: MyColors.darkBlue, fontWeight: FontWeight.bold),
            ),
            children: [
              SimpleDialogOption(
                onPressed: () {
                  imageFromCamera();
                },
                child: const Text(
                  "Camera",
                  style: TextStyle(color: MyColors.darkGray),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  imageFromGallery();
                },
                child: const Text(
                  "Gallery",
                  style: TextStyle(color:MyColors.darkGray),
                ),
              ),

            ],
          );
        });
  }

  Widget defaultScreen() {
    return Scaffold(
      backgroundColor: MyColors.lightGray,
        appBar: AppBar(
          backgroundColor: MyColors.darkBlue,
          actions: [
            IconButton(
                onPressed: (){
                  Get.to(const LoginScreen());
                },
                icon: const Icon(Icons.logout),color: MyColors.red,)
          ],
          centerTitle: false,
          title:  GestureDetector(
            onTap: (){
              Get.to(AdminGetAllOrders());
            },
            child:const Icon(
              Icons.article_outlined,color: MyColors.white,
            )
          ),
          automaticallyImplyLeading: false,

        ),
        body:
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             const Padding(
                padding:  EdgeInsets.only(left: 15.0),
                child:  Icon(
                  Icons.add_photo_alternate,
                  color: MyColors.mediumGray,
                  size: 200,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: MyColors.darkBlue)
                ),
                child: InkWell(
                  onTap: () {
                    showDialogBox();
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Text(
                      "Add new Item",
                      style: TextStyle(color: MyColors.darkBlue, fontSize: 16),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  //uploadItemFormScreen

  uploadItemImage() async {
    var requestImgurApi = http.MultipartRequest(
        "POST", Uri.parse("https://api.imgur.com/3/image"));
    String imageName = DateTime.now().millisecondsSinceEpoch.toString();
    requestImgurApi.fields['title'] = imageName;
    requestImgurApi.headers['Authorization'] = "Client-ID " "97601e7195a932f";

    var imageFile = await http.MultipartFile.fromPath(
      'image',
      pickedImageXFile!.path,
      filename: imageName,
    );

    requestImgurApi.files.add(imageFile);
    var responseFromImgurApi = await requestImgurApi.send();
    var responseDataFromImgurApi = await responseFromImgurApi.stream.toBytes();
    var resultFromImgurApi = String.fromCharCodes(responseDataFromImgurApi);

    Map<String, dynamic> jsonResult = json.decode(resultFromImgurApi);
    imageLink = (jsonResult["data"]["link"]).toString();
    String deleteHash = (jsonResult["data"]["deletehash"]).toString();

    saveItemInfoDatabase();
  }

  saveItemInfoDatabase() async {
    List<String> tagsList = tags.text.split(',');
    List<String> sizesList = sizes.text.split(',');
    List<String> colorsList = colors.text.split(',');

    try {
      var response = await http.post(Uri.parse(Api.uploadNewItem), body: {
        'item_id': '1',
        'name': name.text.trim().toString(),
        'rating': rating.text.trim().toString(),
        'tags': tagsList.toString(),
        'price': price.text.trim().toString(),
        'sizes': sizesList.toString(),
        'colors': colorsList.toString(),
        'description': description.text.trim().toString(),
        'image': imageLink.toString()
      });

      if (response.statusCode == 200) {
        var resBodyForUploadItem = jsonDecode(response.body);
        if (resBodyForUploadItem['success'] == true) {
          Fluttertoast.showToast(
            backgroundColor: MyColors.darkBlue,
              msg: "New Item uploaded Successfully");
          setState(() {
            pickedImageXFile = null;
            name.clear();
            rating.clear();
            tags.clear();
            price.clear();
            sizes.clear();
            colors.clear();
            description.clear();
          });
          Get.to(const AdminUploadScreen());
        } else {
          Fluttertoast.showToast(msg: "Error Occurred, Try Again.");
        }
      }
    } catch (error) {
      throw ("error: $error");
    }
  }

  Widget uploadItemFormScreen() {
    return Scaffold(
      backgroundColor: MyColors.lightGray,
      appBar: AppBar(
        backgroundColor: MyColors.darkBlue,
        centerTitle: true,
        title: const Text("Upload Form"),
        automaticallyImplyLeading: false,

        leading: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            setState(() {
              pickedImageXFile = null;
              name.clear();
              rating.clear();
              tags.clear();
              price.clear();
              sizes.clear();
              colors.clear();
              description.clear();
            });
            Get.to(const AdminUploadScreen());
          },
        ),

      ),
      body: ListView(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: FileImage(
                      File(pickedImageXFile!.path),
                    ),
                    fit: BoxFit.cover)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 30, 30, 8),
            child: Column(
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(

                        textInputAction: TextInputAction.next,
                        controller: name,
                        validator: (val) =>
                            val == "" ? "Please write item name" : null,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.title,
                            color: MyColors.darkBlue,
                          ),
                          hintText: "Item Name",
                          hintStyle: const TextStyle(color: MyColors.mediumGray),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: MyColors.mediumGray,
                              )),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: MyColors.darkGray,
                              )),

                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                        ),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: rating,
                        validator: (val) =>
                            val == "" ? "Please give Item rating" : null,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.rate_review,
                            color: MyColors.darkBlue,
                          ),
                          hintText: "Item Rating",
                          hintStyle:const TextStyle(color: MyColors.mediumGray),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: MyColors.mediumGray,
                              )),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: MyColors.darkGray,
                              )),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                        ),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: tags,
                        validator: (val) =>
                            val == "" ? "Please give Item tags" : null,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.tag,
                            color: MyColors.darkBlue,
                          ),
                          hintText: "Item tags",
                          hintStyle:const TextStyle(color: MyColors.mediumGray),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: MyColors.mediumGray,
                              )),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: MyColors.darkGray,
                              )),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                        ),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: price,
                        validator: (val) =>
                            val == "" ? "Please give Item price" : null,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.price_change_outlined,
                            color: MyColors.darkBlue,
                          ),
                          hintText: "Item price",
                          hintStyle:const TextStyle(color: MyColors.mediumGray),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: MyColors.mediumGray,
                              )),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: MyColors.darkGray,
                              )),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                        ),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: sizes,
                        validator: (val) =>
                            val == "" ? "Please give Item sizes" : null,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.picture_in_picture,
                            color: MyColors.darkBlue,
                          ),
                          hintText: "Item sizes",
                          hintStyle:const TextStyle(color: MyColors.mediumGray),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: MyColors.mediumGray,
                              )),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: MyColors.darkGray,
                              )),

                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                        ),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: colors,
                        validator: (val) =>
                            val == "" ? "Please give Item colors" : null,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.color_lens,
                            color: MyColors.darkBlue,
                          ),
                          hintText: "Item colors",
                          hintStyle:const TextStyle(color: MyColors.mediumGray),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: MyColors.mediumGray,
                              )),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: MyColors.darkGray,
                              )),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                        ),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.done,
                        controller: description,
                        validator: (val) =>
                            val == "" ? "Please give Item description" : null,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.description,
                            color: MyColors.darkBlue,
                          ),
                          hintText: "Item Description",
                          hintStyle:const TextStyle(color: MyColors.mediumGray),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: MyColors.mediumGray,
                              )),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: MyColors.darkGray,
                              )),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                        ),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      Material(
                        color: MyColors.darkBlue,
                        borderRadius: BorderRadius.circular(30),
                        child: InkWell(
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              Fluttertoast.showToast(
                                backgroundColor: MyColors.darkBlue,
                                  msg: "Uploading Now...");
                              uploadItemImage();
                            }
                          },
                          borderRadius: BorderRadius.circular(30),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Text(
                              "Upload now",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                //Sign up
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return pickedImageXFile == null ? defaultScreen() : uploadItemFormScreen();
  }
}
