import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_app/users/auth/login_screen.dart';
import 'package:shop_app/users/fragments/dashboard_of_fragments.dart';
import 'package:shop_app/users/userPreferences/user_preferences.dart';
void main() {
  //to avoid empty white screen when its initialize
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Clothes App",
      home:  FutureBuilder(
        future: RememberUserPrefs.readUserInfo(),
        builder: (context, snapshot){
          if(snapshot.data==null) {
            return const LoginScreen();
          }
          else{
            return DashboardOfFragments();
          }
        },
      ),
    );
  }
}

