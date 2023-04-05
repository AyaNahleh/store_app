import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shop_app/api_connection/api_connection.dart';
import 'package:shop_app/users/cart/cart_list_screen.dart';
import 'package:shop_app/users/item/item_details_screen.dart';
import 'package:shop_app/users/item/search_items.dart';
import 'package:shop_app/users/model/clothes.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../constants/my_colors.dart';

class HomeFragmentScreen extends StatelessWidget {
  HomeFragmentScreen({Key? key}) : super(key: key);
  final TextEditingController searchController = TextEditingController();

  Future<List<Clothes>> getTrendingClothItems() async {
    List<Clothes> trendingClothItemsList = [];
    try {
      var res = await http.post(Uri.parse(Api.getTrendingMostPopularClothes));
      if (res.statusCode == 200) {
        var responseBody = jsonDecode(res.body);
        if (responseBody["success"] == true) {
          for (var eachRow in (responseBody["clothItemsData"] as List)) {
            trendingClothItemsList.add(Clothes.fromJson(eachRow));
          }
        }
      } else {
        Fluttertoast.showToast(msg: "error");
      }
    } catch (error) {
      throw("$error");
    }
    return trendingClothItemsList;
  }

  Future<List<Clothes>> getAllClothItems() async {
    List<Clothes> allClothItemsList = [];
    try {
      var res = await http.post(Uri.parse(Api.getAllClothes));
      if (res.statusCode == 200) {
        var responseBody = jsonDecode(res.body);
        if (responseBody["success"] == true) {
          for (var eachRow in (responseBody["clothItemsData"] as List)) {
            allClothItemsList.add(Clothes.fromJson(eachRow));
          }
        }
      } else {
        Fluttertoast.showToast(msg: "error");
      }
    } catch (error) {
      throw("$error");
    }
    return allClothItemsList;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 16,
          ),
          showSearchBarWidget(),
          const SizedBox(
            height: 26,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Trending",
              style: TextStyle(
                  color: MyColors.darkBlue,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ),
          trendingMostPopularClothItemWidget(context),
          const SizedBox(
            height: 24,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "New Collections",
              style: TextStyle(
                  color:  MyColors.darkBlue,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ),
          allItemWidget(context)
        ],
      ),
    );
  }

  Widget showSearchBarWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
      ),
      child: TextField(
        style: const TextStyle(color: MyColors.white),
        controller: searchController,
        decoration: InputDecoration(
          prefixIcon: IconButton(
            onPressed: () {
              Get.to(SearchItems(typedKeyWords:searchController.text));
            },
            icon: const Icon(
              Icons.search,
              color: MyColors.darkBlue,
            ),
          ),
          hintText: "Search here...",
          hintStyle: const TextStyle(color: MyColors.gray, fontSize: 12),
          suffixIcon: IconButton(
            onPressed: () {
              Get.to(const CartListScreen());
            },
            icon: const Icon(
              Icons.shopping_cart,
              color: MyColors.darkBlue,
            ),
          ),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: MyColors.darkBlue)),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: MyColors.darkBlue)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
      ),
    );
  }

  Widget trendingMostPopularClothItemWidget(context) {
    return FutureBuilder(
      future: getTrendingClothItems(),
      builder: (context, AsyncSnapshot<List<Clothes>> dataSnapShot) {
        if (dataSnapShot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (dataSnapShot.data == null) {
          return const Center(
            child: Text("No Trending Item Found"),
          );
        }
        if (dataSnapShot.data!.isNotEmpty) {
          return SizedBox(
            height: 250,
            child: ListView.builder(
                itemCount: dataSnapShot.data!.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  Clothes eachClothItemData = dataSnapShot.data![index];
                  return GestureDetector(
                    onTap: () {
                      Get.to(ItemDetailsScreen(itemInfo:eachClothItemData ));
                    },
                    child: Container(
                      width: 200,
                      margin: EdgeInsets.fromLTRB(index == 0 ? 16 : 8, 10,
                          index == dataSnapShot.data!.length - 1 ? 16 : 8, 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: MyColors.white,
                          boxShadow: const [
                            BoxShadow(
                                offset: Offset(0, 3),
                                blurRadius: 6,
                                color: MyColors.gray)
                          ]),
                      child: Column(
                        children: [
                          //image
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(22),
                                topRight: Radius.circular(22)),
                            child: FadeInImage(
                                height: 150,
                                width: 200,
                                fit: BoxFit.cover,
                                placeholder:
                                    const AssetImage("assets/place_holder.png"),
                                image: NetworkImage(eachClothItemData.image!),
                                imageErrorBuilder:
                                    (context, error, stackTrackError) {
                                  return const Center(
                                    child: Icon(Icons.broken_image_outlined),
                                  );
                                }),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        eachClothItemData.name!,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: MyColors.darkGray,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      eachClothItemData.price!.toString(),
                                      style: const TextStyle(
                                          color: MyColors.darkBlue,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    RatingBar.builder(
                                      initialRating: eachClothItemData.rating!,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemBuilder: (context, c) => const Icon(
                                        Icons.star,
                                        color: MyColors.amber,
                                      ),
                                      onRatingUpdate: (updateRating) {},
                                      ignoreGestures: true,
                                      unratedColor: MyColors.gray,
                                      itemSize: 20,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      eachClothItemData.rating.toString(),
                                      style:
                                          const TextStyle(color: MyColors.mediumGray),
                                    )
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }),
          );
        } else {
          return const Center(
            child: Text("Empty, No Data"),
          );
        }
      },
    );
  }

  Widget allItemWidget(context) {
    return FutureBuilder(
        future: getAllClothItems(),
        builder: (context, AsyncSnapshot<List<Clothes>> dataSnapShot) {
          if (dataSnapShot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (dataSnapShot.data == null) {
            return const Center(
              child: Text("No Item Found"),
            );
          }
          if (dataSnapShot.data!.isNotEmpty) {
            return ListView.builder(
                itemCount: dataSnapShot.data!.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  Clothes eachClothItemRecord = dataSnapShot.data![index];
                  return GestureDetector(
                    onTap: () {
                      Get.to(ItemDetailsScreen(itemInfo:eachClothItemRecord ));

                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(16, index == 0 ? 16 : 8, 16,
                          index == dataSnapShot.data!.length - 1 ? 16 : 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color:MyColors.white,
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
                                          eachClothItemRecord.name!,
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
                                          "\$${eachClothItemRecord.price!}",
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
                                    eachClothItemRecord.tags!.toString().replaceAll("[", "").replaceAll("]", ""),
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
                                image: NetworkImage(eachClothItemRecord.image!),
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
