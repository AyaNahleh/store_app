import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shop_app/users/fragments/favorites_fragment_screen.dart';
import 'package:shop_app/users/fragments/home_fragment_screen.dart';
import 'package:shop_app/users/fragments/order_fragment_screen.dart';
import 'package:shop_app/users/fragments/profile_fragment_screen.dart';
import 'package:shop_app/users/userPreferences/current_user.dart';

import '../../constants/my_colors.dart';

class DashboardOfFragments extends StatelessWidget {
  final CurrentUser _rememberCurrentUser = Get.put(CurrentUser());

  final List<Widget> _fragmentScreen = [
     HomeFragmentScreen(),
     FavoritesFragmentScreen(),
     OrderFragmentScreen(),
     ProfileFragmentScreen(),
  ];

  final List _navigationButtons = [
    {
      "active_icon": Icons.home,
      "non_active_icon": Icons.home_outlined,
      "label": "Home"
    },
    {
      "active_icon": Icons.favorite,
      "non_active_icon": Icons.favorite_border,
      "label": "Favorite"
    },
    {
      "active_icon": FontAwesomeIcons.boxOpen,
      "non_active_icon": FontAwesomeIcons.box,
      "label": "Orders"
    },
    {
      "active_icon": Icons.person,
      "non_active_icon": Icons.person_outline,
      "label": "Profile"
    }
  ];

 final RxInt _indexNumber = 0.obs;

  DashboardOfFragments({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: CurrentUser(),
      initState: (currentState) {
        _rememberCurrentUser.getUserInfo();
      },
      builder: (controller) {
        return Scaffold(
          backgroundColor: MyColors.lightGray,
          body: SafeArea(
            child: Obx(
                ()=> _fragmentScreen[_indexNumber.value]
            ),
          ),
          bottomNavigationBar: Obx(
            () => BottomNavigationBar(
              currentIndex: _indexNumber.value,
              onTap: (value) {
                _indexNumber.value = value;
              },
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedItemColor: MyColors.darkBlue,
              unselectedItemColor: MyColors.darkGray,
              items: List.generate(4, (index) {
                var navBtn = _navigationButtons[index];
                return BottomNavigationBarItem(
                    backgroundColor: MyColors.lightGray,
                    icon: Icon(navBtn["non_active_icon"]),
                  activeIcon: Icon(navBtn["active_icon"]),
                  label: navBtn["label"]
                );
              }),
            ),
          ),
        );
      },
    );
  }
}
