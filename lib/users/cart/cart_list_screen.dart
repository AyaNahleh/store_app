import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/api_connection/api_connection.dart';
import 'package:shop_app/users/controllers/cart_list_controller.dart';
import 'package:shop_app/users/model/cart.dart';
import 'package:shop_app/users/model/clothes.dart';
import 'package:shop_app/users/userPreferences/current_user.dart';

import '../../constants/my_colors.dart';
import '../item/item_details_screen.dart';
import '../order/order_now_screen.dart';

class CartListScreen extends StatefulWidget {
  const CartListScreen({Key? key}) : super(key: key);

  @override
  State<CartListScreen> createState() => _CartListScreenState();
}

class _CartListScreenState extends State<CartListScreen> {
  final currentOnlineUser = Get.put(CurrentUser());
  final cartListController = Get.put(CartListController());

  getCurrentUserCartList() async {
    List<Cart> cartListOfCurrentUser = [];

    try {
      var res = await http.post(Uri.parse(Api.getCartList), body: {
        "currentOnlineUserID": currentOnlineUser.user.userId.toString(),
      });

      if (res.statusCode == 200) {
        var responseBody = jsonDecode(res.body);
        if (responseBody['success']) {
          for (var element in (responseBody['currentUserCartData'] as List)) {
            cartListOfCurrentUser.add(Cart.fromJson(element));
          }
        } else {
          Fluttertoast.showToast(msg: "you Cart is empty");
        }

        cartListController.setList(cartListOfCurrentUser);
      } else {
        Fluttertoast.showToast(msg: "something wrong");
      }
    } catch (e) {
      throw (e.toString());
    }

    calculateTotalAmount();
  }

  calculateTotalAmount() {
    cartListController.setTotal(0);
    if (cartListController.selectedItem.isNotEmpty) {
      for (var itemCart in cartListController.cartList) {
        if (cartListController.selectedItem.contains(itemCart.cartId)) {
          double totalAmount =
              (itemCart.price!) * (double.parse(itemCart.quantity.toString()));

          cartListController.setTotal(cartListController.total + totalAmount);
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUserCartList();
  }

  deleteSelectedItemFormCartList(int cartID) async {
    try {
      var res = await http.post(Uri.parse(Api.deleteSelectedItem),
          body: {"cart_id": cartID.toString()});
      if (res.statusCode == 200) {
        var responseBody = jsonDecode(res.body);
        if (responseBody["success"]) {
          getCurrentUserCartList();
        }
      } else {
        throw ("error".toString());
      }
    } catch (e) {
      throw (e.toString());
    }
  }

  updateQuantity(int cartID, int quantity) async {
    try {
      var res = await http.post(Uri.parse(Api.updateItemInCartList), body: {
        "cart_id": cartID.toString(),
        "quantity": quantity.toString(),
      });
      if (res.statusCode == 200) {
        var responseBody = jsonDecode(res.body);
        if (responseBody["success"]) {
          getCurrentUserCartList();
        }
      } else {
        throw ("error");
      }
    } catch (e) {
      throw (e.toString());
    }
  }

  List<Map<String, dynamic>> getSelectedCartListItems() {
    List<Map<String, dynamic>> selectedCartList = [];

    if (cartListController.selectedItem.isNotEmpty) {
      for (var element in cartListController.cartList) {
        if (cartListController.selectedItem.contains(element.cartId)) {
          Map<String, dynamic> itemInfo = {
            "item_id": element.itemId,
            "name": element.name,
            "image": element.image,
            "color": element.color,
            "size": element.size,
            "quantity": element.quantity,
            "totalAmount": element.price! * element.quantity!,
            "price": element.price!
          };
          selectedCartList.add(itemInfo);
        }
      }
    }
    return selectedCartList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Cart",
        ),
        backgroundColor: MyColors.darkBlue,
        actions: [
          Obx(
            () => IconButton(
              onPressed: () {
                cartListController.setIsSelectedAllItem();
                cartListController.clearAllSelectedItem();
                if (cartListController.isSelectedAll) {
                  for (var element in cartListController.cartList) {
                    cartListController.addSelectedItem(element.cartId!);
                  }
                }
                calculateTotalAmount();
              },
              icon: Icon(
                  cartListController.isSelectedAll
                      ? Icons.check_box
                      : Icons.check_box_outline_blank,
                  color: MyColors.white),
            ),
          ),
          GetBuilder(
              init: CartListController(),
              builder: (c) {
                if (cartListController.selectedItem.isNotEmpty) {
                  return IconButton(
                    onPressed: () async {
                      var responseFromDialogBox = await Get.dialog(AlertDialog(
                        backgroundColor: MyColors.lightGray,
                        title: const Text(
                          "Delete",
                          style: TextStyle(color: MyColors.darkBlue),
                        ),
                        content: const Text(
                          "Are you sure to delete item from your cart",
                          style: TextStyle(color: MyColors.darkGray),
                        ),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: const Text(
                                  "No",
                                  style: TextStyle(
                                    color: MyColors.red,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.back(result: "yesDelete");
                                },
                                child: const Text(
                                  "Yes",
                                  style: TextStyle(
                                    color: MyColors.green,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ));
                      if (responseFromDialogBox == "yesDelete") {
                        for (var element in cartListController.selectedItem) {
                          deleteSelectedItemFormCartList(element);
                        }
                      }
                      calculateTotalAmount();
                    },
                    icon: const Icon(
                      Icons.delete_sweep,
                      color: MyColors.red,
                      size: 30,
                    ),
                  );
                } else {
                  return Container();
                }
              })
        ],
      ),
      backgroundColor: MyColors.lightGray,
      body: Obx(
        () => cartListController.cartList.isNotEmpty
            ? ListView.builder(
                itemCount: cartListController.cartList.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  Cart cartModel = cartListController.cartList[index];
                  Clothes clothesModel = Clothes(
                    itemId: cartModel.itemId,
                    colors: cartModel.colors,
                    image: cartModel.image,
                    name: cartModel.name,
                    price: cartModel.price,
                    rating: cartModel.rating,
                    sizes: cartModel.sizes,
                    description: cartModel.description,
                    tags: cartModel.tags,
                  );
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        GetBuilder(
                            init: CartListController(),
                            builder: (c) {
                              return IconButton(
                                  onPressed: () {
                                    if (cartListController.selectedItem
                                        .contains(cartModel.cartId)) {
                                      cartListController.deleteSelectedItem(
                                          cartModel.cartId!);
                                    } else {
                                      cartListController
                                          .addSelectedItem(cartModel.cartId!);
                                    }
                                    calculateTotalAmount();
                                  },
                                  icon: Icon(
                                    cartListController.selectedItem
                                            .contains(cartModel.cartId)
                                        ? Icons.check_box
                                        : Icons.check_box_outline_blank,
                                    color: MyColors.darkGray,
                                  ));
                            }),
                        Expanded(
                            child: GestureDetector(
                          onTap: () {
                            Get.to(ItemDetailsScreen(itemInfo: clothesModel));
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(
                                0,
                                index == 0 ? 16 : 8,
                                16,
                                index == cartListController.cartList.length - 1
                                    ? 16
                                    : 8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: MyColors.white,
                                boxShadow: const [
                                  BoxShadow(
                                      offset: Offset(0, 0),
                                      blurRadius: 6,
                                      color: MyColors.mediumGray)
                                ]),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        clothesModel.name.toString(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            color: MyColors.darkGray,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            "Color:",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                            color: MyColors.darkGray),
                                          ),
                                          Text(
                                            cartModel.color!.replaceAll("[", "").replaceAll("]", ""),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: MyColors.mediumGray),
                                          ),

                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            "Size:",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style:  TextStyle(
                                                color: MyColors.darkGray),
                                          ),
                                          Text(
                                            cartModel.size!.replaceAll("[", "").replaceAll("]", ""),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: MyColors.mediumGray),
                                          ),

                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                         const Text(
                                            "Price: ",
                                            style:  TextStyle(
                                             color: MyColors.darkGray),
                                          ),
                                          Text(
                                            "\$${clothesModel.price}",
                                            style: const TextStyle(
                                                color: MyColors.darkBlue,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              if (cartModel.quantity! - 1 >=
                                                  1) {
                                                updateQuantity(
                                                    cartModel.cartId!,
                                                    cartModel.quantity! - 1);
                                              }
                                            },
                                            icon: const Icon(
                                              Icons.remove_circle_outline,
                                              color: MyColors.mediumGray,
                                              size: 30,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            cartModel.quantity.toString(),
                                            style: const TextStyle(
                                                color: MyColors.darkBlue,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                updateQuantity(
                                                    cartModel.cartId!,
                                                    cartModel.quantity! + 1);
                                              },
                                              icon: const Icon(
                                                Icons.add_circle_outline,
                                                color: MyColors.mediumGray,
                                                size: 30,
                                              )),
                                        ],
                                      )
                                    ],
                                  ),
                                )),
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                      bottomRight: Radius.circular(22),
                                      topRight: Radius.circular(22)),
                                  child: FadeInImage(
                                      height: 190,
                                      width: 150,
                                      fit: BoxFit.cover,
                                      placeholder: const AssetImage(
                                          "assets/place_holder.png"),
                                      image: NetworkImage(cartModel.image!),
                                      imageErrorBuilder:
                                          (context, error, stackTrackError) {
                                        return const Center(
                                          child:
                                              Icon(Icons.broken_image_outlined),
                                        );
                                      }),
                                ),
                              ],
                            ),
                          ),
                        )),
                      ],
                    ),
                  );
                },
              )
            : const Center(
                child: Text("cart is empty"),
              ),
      ),
      bottomNavigationBar: GetBuilder(
        init: CartListController(),
        builder: (c) {
          return Container(
            decoration: const BoxDecoration(color: MyColors.darkBlue, boxShadow: [
              BoxShadow(
                  offset: Offset(0, -3), color: MyColors.mediumGray, blurRadius: 4)
            ]),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Text(
                  "Total:",
                  style: TextStyle(
                      fontSize: 14,
                      color: MyColors.lightGray,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 4,
                ),
                Obx(
                  () => Text(
                    "\$ ${cartListController.total.toStringAsFixed(2)}",
                    maxLines: 1,
                    style: const TextStyle(
                        color: MyColors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const Spacer(),
                Material(
                  color: cartListController.selectedItem.isNotEmpty
                      ? MyColors.white
                      : MyColors.lightGray.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(30),
                  child: InkWell(
                    onTap: () {
                      cartListController.selectedItem.isNotEmpty
                          ? Get.to(OrderNowScreen(
                              selectedCartListItem: getSelectedCartListItems(),
                              totalAmount: cartListController.total,
                              cartIdList: cartListController.selectedItem,
                            ))
                          : null;
                    },
                    child:  Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Text(
                        "Order Now",
                        style: TextStyle(
                           color: cartListController.selectedItem.isNotEmpty
                                ? MyColors.darkBlue
                                : MyColors.white,
                            fontSize: 14),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
