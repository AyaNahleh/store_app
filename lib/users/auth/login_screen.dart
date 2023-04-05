import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shop_app/admin/admin_login.dart';
import 'package:shop_app/users/auth/signup_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/users/fragments/dashboard_of_fragments.dart';
import 'package:shop_app/users/userPreferences/user_preferences.dart';

import '../../api_connection/api_connection.dart';
import '../../constants/my_colors.dart';
import '../model/user.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var formKey = GlobalKey<FormState>();
  var email = TextEditingController();
  var password = TextEditingController();
  var isObscure = true.obs;

  loginUserNow() async {
    try {
      var response = await http.post(
        Uri.parse(Api.login),
        body: {
          "user_email": email.text.trim(),
          "user_password": password.text.trim(),
        },
      );
      if (response.statusCode == 200) {
        var resBodyForLogin = jsonDecode(response.body);
        if (resBodyForLogin['success']) {
          Fluttertoast.showToast(
              backgroundColor: MyColors.darkBlue,
              msg: "you are logged-in Successfully");
          User info = User.fromJson(resBodyForLogin['userData']);

          await RememberUserPrefs.storeUserInfo(info);

          Get.to(() => DashboardOfFragments());
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
      backgroundColor: MyColors.lightGray,
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
                  child: Image.asset("assets/login.jpg"),
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
                                    hintStyle:
                                        const TextStyle(color: MyColors.mediumGray),
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
                                      hintStyle:
                                          const TextStyle(color: MyColors.mediumGray),
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
                                //Color(0xFF598BED)
                                //Color(0xFF6D747A)
                                const SizedBox(
                                  height: 18,
                                ),
                                Material(
                                  color: MyColors.darkBlue,
                                  borderRadius: BorderRadius.circular(30),
                                  child: InkWell(
                                    onTap: () {
                                      if (formKey.currentState!.validate()) {
                                        loginUserNow();
                                      }
                                    },
                                    borderRadius: BorderRadius.circular(30),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 20),
                                      child: Text(
                                        "Login",
                                        style: TextStyle(
                                            color: MyColors.white,
                                            fontSize: 16),
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
                              const Text(
                                "Don't have an account?",
                                style: TextStyle(color: MyColors.darkGray),
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.to(() => const SignUpScreen());
                                },
                                child: const Text(
                                  "Sign up",
                                  style: TextStyle(color: MyColors.darkBlue),
                                ),
                              )
                            ],
                          ),
                          //admin panel
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Are you an Admin?",
                                style: TextStyle(color: MyColors.darkGray),
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.to(const AdminLoginScreen());
                                },
                                child: const Text(
                                  "Click here",
                                  style: TextStyle(color: MyColors.darkBlue),
                                ),
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
