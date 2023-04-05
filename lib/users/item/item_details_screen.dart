import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shop_app/users/cart/cart_list_screen.dart';
import 'package:shop_app/users/controllers/item_details_controller.dart';
import 'package:shop_app/users/model/clothes.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/users/userPreferences/current_user.dart';

import '../../api_connection/api_connection.dart';
import '../../constants/my_colors.dart';

class ItemDetailsScreen extends StatefulWidget {
  final Clothes? itemInfo;

  const ItemDetailsScreen({Key? key, this.itemInfo}) : super(key: key);

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  final itemDetailsController = Get.put(ItemDetailsControllers());
  final currentOnlineUser = Get.put(CurrentUser());

  addItemToCart() async {
    try {
      var response = await http.post(
        Uri.parse(Api.addToCart),
        body: {
          "user_id": currentOnlineUser.user.userId.toString(),
          "item_id": widget.itemInfo!.itemId.toString(),
          "quantity": itemDetailsController.quantity.toString(),
          "color": widget.itemInfo!.colors![itemDetailsController.color],
          "size": widget.itemInfo!.sizes![itemDetailsController.size],
        },
      );
      if (response.statusCode == 200) {
        var resBody = jsonDecode(response.body);
        if (resBody['success']) {
          Fluttertoast.showToast(
            backgroundColor: MyColors.darkBlue,
              msg: "Item saved to Cart Successfully");
        } else {
          Fluttertoast.showToast(msg: "error Occur, try Again");
        }
      }
    } catch (error) {
      throw(error.toString());
    }
  }
  //favoriteFound

  validateFavoriteList()async{

    try {
      var response = await http.post(
        Uri.parse(Api.validateFavorite),
        body: {
          "user_id": currentOnlineUser.user.userId.toString(),
          "item_id": widget.itemInfo!.itemId.toString(),
        },
      );
      if (response.statusCode == 200) {
        var resBody = jsonDecode(response.body);
        if (resBody['favoriteFound']) {
          Fluttertoast.showToast(
            backgroundColor: MyColors.darkBlue,
              msg: "item is in favorite List");
          itemDetailsController.setIsFavoriteItem(true);
        } else {
          itemDetailsController.setIsFavoriteItem(false);

        }
      }
    } catch (error) {
      throw(error.toString());
    }

  }

  addItemToFavoriteList()async{

    try {
      var response = await http.post(
        Uri.parse(Api.addFavorite),
        body: {
          "user_id": currentOnlineUser.user.userId.toString(),
          "item_id": widget.itemInfo!.itemId.toString(),
        },
      );
      if (response.statusCode == 200) {
        var resBody = jsonDecode(response.body);
        if (resBody['success']) {

          Fluttertoast.showToast(
            backgroundColor: MyColors.darkBlue,
              msg: "item saved to favorite list ");
          validateFavoriteList();
        } else {
          Fluttertoast.showToast(msg: "error Occur, try Again");
        }
      }
    } catch (error) {
      throw(error.toString());
    }

  }

  deleteItemFromFavoriteList()async{

    try {
      var response = await http.post(
        Uri.parse(Api.deleteFavorite),
        body: {
          "user_id": currentOnlineUser.user.userId.toString(),
          "item_id": widget.itemInfo!.itemId.toString(),
        },
      );
      if (response.statusCode == 200) {
        var resBody = jsonDecode(response.body);
        if (resBody['success']) {
          Fluttertoast.showToast(
            backgroundColor: MyColors.darkBlue,
              msg: "item deleted from favorite list ");
          validateFavoriteList();
        } else {
          Fluttertoast.showToast(msg: "error Occur, try Again");
        }
      }
    } catch (error) {
      throw(error.toString());
    }

  }

  @override
  void initState() {
    validateFavoriteList();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.lightGray,
      body: Stack(
        children: [
          FadeInImage(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
              placeholder: const AssetImage("assets/place_holder.png"),
              image: NetworkImage(widget.itemInfo!.image!),
              imageErrorBuilder: (context, error, stackTrackError) {
                return const Center(
                  child: Icon(Icons.broken_image_outlined),
                );
              }),
          Align(
            alignment: Alignment.bottomCenter,
            child: itemInfoWidget(),
          ),
          Positioned(
              top: MediaQuery.of(context).padding.top,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.transparent,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: MyColors.darkBlue,
                      ),
                    ),
                   const Spacer(),
                    Obx(
                      () => IconButton(
                        onPressed: () {
                          if(itemDetailsController.isFavorite){

                            deleteItemFromFavoriteList();

                          }else{
                            addItemToFavoriteList();

                          }
                        },
                        icon: Icon(itemDetailsController.isFavorite
                            ? Icons.bookmark
                            : Icons.bookmark_border_outlined,color: MyColors.darkBlue,),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Get.to(const CartListScreen());
                      },
                      icon: const Icon(
                        Icons.shopping_cart,
                        color: MyColors.darkBlue,
                      ),
                    ),

                  ],
                ),
              )),
        ],
      ),
    );
  }

  itemInfoWidget() {
    return Container(
      height: MediaQuery.of(Get.context!).size.height * 0.6,
      width: MediaQuery.of(Get.context!).size.width,
      decoration: const BoxDecoration(
        color: MyColors.lightGray,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
              offset: Offset(0, -3), blurRadius: 4, color:MyColors.darkBlue),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 18,
            ),
            Center(
              child: Container(
                height: 8,
                width: 140,
                decoration: BoxDecoration(
                    color: MyColors.darkBlue,
                    borderRadius: BorderRadius.circular(30)),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              widget.itemInfo!.name!,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: const TextStyle(
                  fontSize: 24,
                  color: MyColors.darkBlue,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          RatingBar.builder(
                            initialRating: widget.itemInfo!.rating!,
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
                            widget.itemInfo!.rating.toString(),
                            style: const TextStyle(color: MyColors.darkBlue),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.itemInfo!.tags!
                            .toString()
                            .replaceAll("[", "")
                            .replaceAll("]", ""),
                        overflow: TextOverflow.ellipsis,
                        style:
                            const TextStyle(fontSize: 16, color: MyColors.gray),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        "\$${widget.itemInfo!.price!}",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 16,
                            color: MyColors.darkBlue,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Obx(() => Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            itemDetailsController.setQuantityItem(
                                itemDetailsController.quantity + 1);
                          },
                          icon: const Icon(
                            Icons.add_circle_outline,
                            color: MyColors.darkGray,
                          ),
                        ),
                        Text(
                          itemDetailsController.quantity.toString(),
                          style: const TextStyle(
                              fontSize: 20,
                              color: MyColors.darkBlue,
                              fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          onPressed: () {
                            if (itemDetailsController.quantity - 1 >= 1) {
                              itemDetailsController.setQuantityItem(
                                  itemDetailsController.quantity - 1);
                            }
                          },
                          icon: const Icon(
                            Icons.remove_circle_outline,
                            color: MyColors.darkGray,
                          ),
                        ),
                      ],
                    )),
              ],
            ),
            const Text(
              "Size:",
              style: TextStyle(
                  fontSize: 18,
                  color: MyColors.darkBlue,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
            ),
            Wrap(
                runSpacing: 8,
                spacing: 8,
                children:
                    List.generate(widget.itemInfo!.sizes!.length, (index) {
                  return Obx(() => GestureDetector(
                        onTap: () {
                          itemDetailsController.setSizeItem(index);
                        },
                        child: Container(
                          height: 35,
                          width: 60,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 2,
                                  color: itemDetailsController.size == index
                                      ? MyColors.darkBlue
                                      : MyColors.darkGray),
                              color: MyColors.white ),
                          alignment: Alignment.center,
                          child: Text(
                            widget.itemInfo!.sizes![index]
                                .replaceAll("[", "")
                                .replaceAll("]", ""),
                            style: const TextStyle(
                                fontSize: 12, color: MyColors.darkGray),
                          ),
                        ),
                      ));
                })),
            const Text(
              "Color:",
              style: TextStyle(
                  fontSize: 18,
                  color: MyColors.darkBlue,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
            ),
            Wrap(
                runSpacing: 8,
                spacing: 8,
                children:
                    List.generate(widget.itemInfo!.colors!.length, (index) {
                  return Obx(() => GestureDetector(
                        onTap: () {
                          itemDetailsController.setColorItem(index);
                        },
                        child: Container(
                          height: 35,
                          width: 60,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 2,
                                  color: itemDetailsController.color == index
                                      ? MyColors.darkBlue
                                      : MyColors.darkGray),
                              color: MyColors.white),
                          alignment: Alignment.center,
                          child: Text(
                            widget.itemInfo!.colors![index]
                                .replaceAll("[", "")
                                .replaceAll("]", ""),
                            style: const TextStyle(
                                fontSize: 12, color: MyColors.darkGray),
                          ),
                        ),
                      ));
                })),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Description:",
              style: TextStyle(
                  fontSize: 18,
                  color: MyColors.darkBlue,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              widget.itemInfo!.description!,
              textAlign: TextAlign.justify,
              style: const TextStyle(
                color: MyColors.darkGray,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Material(
              elevation: 4,
              color: MyColors.darkBlue,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: () {
                  addItemToCart();
                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  child: const Text(
                    "Add to Cart",
                    style: TextStyle(color: MyColors.white, fontSize: 20),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
