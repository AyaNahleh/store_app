import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shop_app/users/model/clothes.dart';
import 'package:shop_app/users/model/favorite.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/users/userPreferences/current_user.dart';
import '../../api_connection/api_connection.dart';
import '../../constants/my_colors.dart';
import '../item/item_details_screen.dart';


class FavoritesFragmentScreen extends StatelessWidget {
   FavoritesFragmentScreen({Key? key}) : super(key: key);
  final currentOnlineUser=Get.put(CurrentUser());

  Future<List<Favorite>> getCurrentUserFavoriteList() async {
    List<Favorite> favoriteListOfCurrentUser = [];

    try {
      var res = await http.post(Uri.parse(Api.readFavorite), body: {
        "user_id": currentOnlineUser.user.userId.toString(),
      });

      if (res.statusCode == 200) {
        var responseBody = jsonDecode(res.body);
        if (responseBody['success']) {
          for (var element in (responseBody['currentUserFavoriteData'] as List)) {
            favoriteListOfCurrentUser.add(Favorite.fromJson(element));
          }
        }
      } else {
        Fluttertoast.showToast(msg: "something wrong");
      }
    } catch (e) {
      print(e.toString());
    }

    return favoriteListOfCurrentUser;

  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         const Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 8, 8),
            child: Text(
              "My Favorite :",
              style: TextStyle(
                color: MyColors.darkBlue,
                fontSize: 30,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 24, 8, 8),
            child: Text(
              "Order these best clothes for yourself now",
              style: TextStyle(
                  color: MyColors.mediumGray,
                  fontSize: 16,
                  fontWeight: FontWeight.w300
              ),
            ),
          ),
          const SizedBox(width: 24,),
          favoriteItemWidget(context),

        ],
      ),
    );
  }

   Widget favoriteItemWidget(context) {
     return FutureBuilder(
         future: getCurrentUserFavoriteList(),
         builder: (context, AsyncSnapshot<List<Favorite>> dataSnapShot) {
           if (dataSnapShot.connectionState == ConnectionState.waiting) {
             return const Center(
               child: CircularProgressIndicator(),
             );
           }
           if (dataSnapShot.data == null) {
             return const Center(
               child: Text("No favorite Item Found",style: TextStyle(color: MyColors.darkGray),),
             );
           }
           if (dataSnapShot.data!.isNotEmpty) {
             return ListView.builder(
                 itemCount: dataSnapShot.data!.length,
                 shrinkWrap: true,
                 physics: const NeverScrollableScrollPhysics(),
                 scrollDirection: Axis.vertical,
                 itemBuilder: (context, index) {
                   Favorite eachFavoriteItemRecord = dataSnapShot.data![index];
                   Clothes clickedItem=Clothes(
                     itemId: eachFavoriteItemRecord.itemId,
                     colors: eachFavoriteItemRecord.colors,
                     image: eachFavoriteItemRecord.image,
                     name: eachFavoriteItemRecord.name,
                     price: eachFavoriteItemRecord.price,
                     rating: eachFavoriteItemRecord.rating,
                     sizes: eachFavoriteItemRecord.sizes,
                     description: eachFavoriteItemRecord.description,
                     tags: eachFavoriteItemRecord.tags

                   );
                   return GestureDetector(
                     onTap: () {
                      Get.to(ItemDetailsScreen(itemInfo:clickedItem ));

                     },
                     child: Container(
                       margin: EdgeInsets.fromLTRB(16, index == 0 ? 16 : 8, 16,
                           index == dataSnapShot.data!.length - 1 ? 16 : 8),
                       decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(20),
                           color: MyColors.white,
                           boxShadow: const [
                             BoxShadow(
                                 offset: Offset(0, 0),
                                 blurRadius: 6,
                                 color: MyColors.gray)
                           ]),
                       child: Row(
                         children: [

                           Expanded(
                             child: Padding(
                               padding: const EdgeInsets.only(left: 15),
                               child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Row(
                                     children: [
                                       Expanded(
                                         child: Text(
                                           eachFavoriteItemRecord.name!,
                                           overflow: TextOverflow.ellipsis,
                                           maxLines: 2,
                                           style: const TextStyle(
                                               fontSize: 18,
                                               color: MyColors.darkGray,
                                               fontWeight: FontWeight.bold),
                                         ),
                                       ),
                                       Padding(
                                         padding: const EdgeInsets.only(left: 12.0,right: 12),
                                         child: Text(
                                           "\$${eachFavoriteItemRecord.price!}",
                                           overflow: TextOverflow.ellipsis,
                                           maxLines: 2,
                                           style: const TextStyle(
                                               fontSize: 18,
                                               color: MyColors.darkBlue,
                                               fontWeight: FontWeight.bold),
                                         ),
                                       ),
                                     ],
                                   ),
                                   const SizedBox(
                                     height: 16,
                                   ),
                                   Text(
                                     eachFavoriteItemRecord.tags!.toString().replaceAll("[", "").replaceAll("]", ""),
                                     overflow: TextOverflow.ellipsis,
                                     maxLines: 2,
                                     style: const TextStyle(
                                         fontSize: 14,
                                         color: MyColors.mediumGray,
                                         fontWeight: FontWeight.bold),
                                   ),
                                 ],
                               ),
                             ),
                           ),
                           ClipRRect(
                             borderRadius: const BorderRadius.only(
                                 bottomRight: Radius.circular(20),
                                 topRight: Radius.circular(20)),
                             child: FadeInImage(
                                 height: 130,
                                 width: 130,
                                 fit: BoxFit.cover,
                                 placeholder:
                                 const AssetImage("assets/place_holder.png"),
                                 image: NetworkImage(eachFavoriteItemRecord.image!),
                                 imageErrorBuilder:
                                     (context, error, stackTrackError) {
                                   return const Center(
                                     child: Icon(Icons.broken_image_outlined),
                                   );
                                 }),
                           ),
                         ],
                       ),
                     ),
                   );
                 });
           } else {
             return const Center(
               child: Text("Empty, No Data"),
             );
           }
         });
   }
}