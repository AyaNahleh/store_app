import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_app/users/auth/login_screen.dart';
import 'package:shop_app/users/userPreferences/current_user.dart';
import 'package:shop_app/users/userPreferences/user_preferences.dart';

import '../../constants/my_colors.dart';

class ProfileFragmentScreen extends StatelessWidget {
  final CurrentUser _currentUser=Get.put(CurrentUser());

  signOutUser()async{
   var resultResponse= await Get.dialog(
      AlertDialog(
        backgroundColor: MyColors.white,
        title: const Text(
          "Logout",
          style: TextStyle(
          color:  MyColors.darkBlue,
            fontSize: 18,
            fontWeight: FontWeight.bold
          ),
        ),
        content: const Text(
          "Are you sure?\n you want to logout from app?",style: TextStyle(color: MyColors.darkGray),
        ),
        actions: [
         Row(
           mainAxisAlignment: MainAxisAlignment.spaceAround,
           children: [
             TextButton(
                 onPressed: (){
                   Get.back();
                 },
                 child: const Text("No",style: TextStyle(color: MyColors.red),)),
             TextButton(
                 onPressed: (){
                   Get.back(result: "loggedOut");
                 },
                 child: const Text("Yes",style: TextStyle(color: MyColors.green),)),
           ],
         )

        ],
      )
    );
   if(resultResponse=="loggedOut"){
     //delete user data from device
     RememberUserPrefs.removeUserInfo().then((value) {
       Get.off(const LoginScreen());
     });
   }


  }

  ProfileFragmentScreen({super.key});

  Widget userInfoItemProfile(IconData iconData, String userData) {
    return Container(
      decoration: BoxDecoration(
          boxShadow: const[
            BoxShadow(
              blurRadius: 10,
              color: MyColors.gray,
              offset: Offset(0, 0),
            ),
          ],
        borderRadius: BorderRadius.circular(12),
        color: MyColors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(
            iconData,
            size: 30,
            color: MyColors.darkBlue,
          ),
          const SizedBox(
            width: 16,
          ),
          Text(
            userData,
            style: const TextStyle(fontSize: 15,color: MyColors.darkGray),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(32),
      children: [
        Center(
          child: Image.asset(
            "assets/woman.png",
            width: 240,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        userInfoItemProfile(Icons.person, _currentUser.user.userName),
        const SizedBox(
          height: 20,
        ),
        userInfoItemProfile(Icons.email, _currentUser.user.userEmail),
        const SizedBox(
          height: 20,
        ),
        Center(
          child: Material(
            color: MyColors.red,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              onTap: (){
                signOutUser();

              },
              borderRadius: BorderRadius.circular(32),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30,vertical: 12),
                child: Text(
                  "Sign Out",
                  style: TextStyle(
                    color: MyColors.white,
                    fontSize: 16
                  ),
                ),
              ),

            ),
          ),
        )


      ],
    );
  }
}
