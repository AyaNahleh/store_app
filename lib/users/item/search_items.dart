import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shop_app/users/model/clothes.dart';
import 'package:http/http.dart' as http;
import '../../api_connection/api_connection.dart';
import '../cart/cart_list_screen.dart';
import 'item_details_screen.dart';

class SearchItems extends StatefulWidget {
  const SearchItems({Key? key, this.typedKeyWords}) : super(key: key);
  final String? typedKeyWords;
  @override
  State<SearchItems> createState() => _SearchItemsState();
}

class _SearchItemsState extends State<SearchItems> {
  TextEditingController searchController = TextEditingController();

  Future<List<Clothes>>readSearchRecordsFound()async{

    List<Clothes> clothesSearchList=[];

    if(searchController.text !=""){
      try {
        var res = await http.post(Uri.parse(Api.searchItem), body: {
          "typedKeyWords": searchController.text,
        });

        if (res.statusCode == 200) {
          var responseBody = jsonDecode(res.body);
          if (responseBody['success']) {
            (responseBody['itemFoundRecord'] as List).forEach((element) {
              clothesSearchList.add(Clothes.fromJson(element));
            });
          }
        } else {
          Fluttertoast.showToast(msg: "something wrong");
        }
      } catch (e) {
        print(e.toString());
      }

    }
    return clothesSearchList;

  }

  @override
  void initState() {
    searchController.text=widget.typedKeyWords!;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.white24,
        title: showSearchBarWidget(),
        titleSpacing: 0,
        leading: IconButton(
          onPressed: (){
            Get.back();
          },
          icon: Icon(Icons.arrow_back,color: Colors.purpleAccent,),
        ),
      ),
      body: searchItemWidget(context),
    );
  }

  Widget showSearchBarWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
      ),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        controller: searchController,
        decoration: InputDecoration(
          prefixIcon: IconButton(
            onPressed: () {
              setState(() {

              });
            },
            icon: const Icon(
              Icons.search,
              color: Colors.purple,
            ),
          ),
          hintText: "Search here...",
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
          suffixIcon: IconButton(
            onPressed: () {
              searchController.clear();
              setState(() {

              });
            },
            icon: const Icon(
              Icons.close,
              color: Colors.purpleAccent,
            ),
          ),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: Colors.purpleAccent)),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: Colors.purpleAccent)),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
      ),
    );
  }

  Widget searchItemWidget(context) {
    return FutureBuilder(
        future: readSearchRecordsFound(),
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
                          color: Colors.black,
                          boxShadow: const [
                            BoxShadow(
                                offset: Offset(0, 0),
                                blurRadius: 6,
                                color: Colors.grey)
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
                                              color: Colors.grey,
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
                                              color: Colors.purpleAccent,
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
                                        fontSize: 18,
                                        color: Colors.grey,
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
