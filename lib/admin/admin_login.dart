import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shop_app/admin/admin_upload_items.dart';
import 'package:shop_app/users/auth/login_screen.dart';
import 'package:http/http.dart' as http;
import '../../api_connection/api_connection.dart';
import '../constants/my_colors.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({Key? key}) : super(key: key);

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  var formKey = GlobalKey<FormState>();
  var email = TextEditingController();
  var password = TextEditingController();
  var isObscure = true.obs;

  loginAdminNow() async {
    try {
      var response = await http.post(
        Uri.parse(Api.adminLogin),
        body: {
          "admin_email": email.text.trim(),
          "admin_password": password.text.trim(),
        },
      );

      if (response.statusCode == 200) {
        var resBodyForLogin = jsonDecode(response.body);
        if (resBodyForLogin['success']) {
          Fluttertoast.showToast(
            backgroundColor: MyColors.darkBlue,
              msg: "Dear Admin, you are logged-in Successfully");

          Get.to(() => const AdminUploadScreen());
        } else {
          Fluttertoast.showToast(
              msg:
                  "Incorrect Credentials. \nPlease write correct password or email and Try Again");
        }
      }
    } catch (e) {
      throw ("error$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, cons) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: cons.maxHeight,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                //log in
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 285,
                  child: Image.asset("assets/admin.jpg"),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: Container(
                    decoration: const BoxDecoration(
                        color: MyColors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10,
                            color: MyColors.gray,
                            offset: Offset(0, 0),
                          ),
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(30, 30, 30, 8),
                      child: Column(
                        children: [
                          Form(
                            key: formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: email,
                                  validator: (val) =>
                                      val == "" ? "Please write email" : null,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.email,
                                      color: MyColors.darkBlue,
                                    ),
                                    hintText: "Email",
                                    hintStyle: const TextStyle(
                                        color: MyColors.mediumGray),
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
                                Obx(
                                  () => TextFormField(
                                    controller: password,
                                    obscureText: isObscure.value,
                                    validator: (val) => val == ""
                                        ? "Please write password"
                                        : null,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                        Icons.vpn_key_sharp,
                                        color: MyColors.darkBlue,
                                      ),
                                      hintText: "Password",
                                      hintStyle: const TextStyle(
                                          color: MyColors.mediumGray),
                                      suffixIcon: Obx(() => GestureDetector(
                                            onTap: () {
                                              isObscure.value =
                                                  !isObscure.value;
                                            },
                                            child: Icon(
                                              isObscure.value
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              color: MyColors.darkBlue,
                                            ),
                                          )),

                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          borderSide: const BorderSide(
                                            color: MyColors.mediumGray,
                                          )),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          borderSide: const BorderSide(
                                            color: MyColors.darkGray,
                                          )),

                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 14, vertical: 6),
                                    ),
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
                                        loginAdminNow();
                                      }
                                    },
                                    borderRadius: BorderRadius.circular(30),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 20),
                                      child: Text(
                                        "Login",
                                        style: TextStyle(
                                            color: MyColors.white, fontSize: 16),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          //Sign up
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("I am not Admin",style: TextStyle(color: MyColors.darkGray),),
                              TextButton(
                                onPressed: () {
                                  Get.to(() => const LoginScreen());
                                },
                                child: const Text("Click Here",style: TextStyle(color: MyColors.darkBlue),),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
