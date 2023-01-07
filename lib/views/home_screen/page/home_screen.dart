import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/modals/product.dart';
import 'package:e_commerce_app/utils/globals.dart';
import 'package:e_commerce_app/views/add_product.dart';
import 'package:e_commerce_app/views/cart_page.dart';
import 'package:e_commerce_app/views/liked_screen.dart';
import 'package:e_commerce_app/views/product_detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../providers/product_firebase_helper.dart';
import '../../../utils/colours.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static String theme = "light";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  Uint8List? decodedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      body: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 25, bottom: 20, left: 20),
                child: Text(
                  "Explore Product",
                  style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    height: 60,
                    width: 220,
                    margin: EdgeInsets.only(left: 20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorDark,
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Icon(
                          Icons.search_rounded,
                          size: 25,
                          color: Theme.of(context).primaryColorLight.withOpacity(0.9),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Apple Product",
                          style: TextStyle(
                            color: Theme.of(context).primaryColorLight.withOpacity(0.9),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(11),
                    onTap: () async {
                      // await ProductFirebaseHelper.productFirebaseHelper.insertData(product: products[2]);
                      Get.to(AddProductScreen());
                    },
                    child: Ink(
                      height: 60,
                      width: 70,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorDark,
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Container(
                        height: 60,
                        width: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: Center(
                          child: Icon(
                            CupertinoIcons.add,
                            size: 30,
                            color: Theme.of(context).primaryColorLight,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.57,
                width: double.infinity,
                child: StreamBuilder<QuerySnapshot>(
                  stream: ProductFirebaseHelper.productFirebaseHelper.fetchData(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text("ERROR: ${snapshot.error}"),
                      );
                    } else if (snapshot.hasData) {
                      QuerySnapshot querySnapshot = snapshot.data!;
                      List<QueryDocumentSnapshot> queryDocumentSnapshot = querySnapshot.docs;

                      return GridView.builder(
                        itemCount: queryDocumentSnapshot.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.65,
                        ),
                        itemBuilder: (context, i) {
                          Map<String, dynamic> data = queryDocumentSnapshot[i].data() as Map<String, dynamic>;

                          if (data["image"] != null) {
                            decodedImage = base64Decode(data["image"]);
                          } else {
                            decodedImage == null;
                          }

                          return GestureDetector(
                            onTap: () {
                              log("Tapped Index at: $i", name: "Why");

                              data['quantity'] = data['quantity'].toString();

                              Product pro = Product.fromMap(data: data);

                              Get.toNamed("detailPage", arguments: pro);
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) => DetailPage(productMap: data),
                              //       ),
                              // );
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.40,
                              width: MediaQuery.of(context).size.width * 0.43,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Theme.of(context).primaryColorLight,
                              ),
                              child: Column(
                                children: [
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        height: 170,
                                        width: MediaQuery.of(context).size.width * 0.43,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0.5),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(20),
                                          child: Image.memory(
                                            decodedImage!,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: InkWell(
                                          onTap: () async {
                                            Product pr = Product.fromMap(data: data);
                                            await ProductFirebaseHelper.productFirebaseHelper.likeProduct(data: pr);
                                            // addToFavList.add()
                                          },
                                          child: Container(
                                            height: 50,
                                            width: 50,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: (data['isLike'] == true)
                                                  ? Icon(
                                                      CupertinoIcons.suit_heart_fill,
                                                      color: Theme.of(context).primaryColorDark,
                                                      size: 30,
                                                    )
                                                  : Icon(
                                                      CupertinoIcons.suit_heart,
                                                      color: Theme.of(context).primaryColorDark,
                                                      size: 30,
                                                    ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 7,
                                  ),
                                  Text(
                                    data["name"],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.w600, color: Theme.of(context).primaryColorDark),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    "\$${data["price"]}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Theme.of(context).primaryColorDark,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 75,
                    width: 270,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorDark,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            Get.to(LikedProductPage());
                          },
                          child: Container(
                            height: 58,
                            width: 58,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColorLight,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.favorite_border_rounded,
                                color: Theme.of(context).primaryColorDark,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (theme == "dark") {
                              Get.changeThemeMode(ThemeMode.light);
                              theme = "light";
                            } else {
                              Get.changeThemeMode(ThemeMode.dark);
                              theme = "dark";
                            }
                          },
                          child: Container(
                            height: 58,
                            width: 58,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColorLight,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.brightness_6_sharp,
                                color: Theme.of(context).primaryColorDark,
                                size: 28,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Get.toNamed("cartPage");
                          },
                          child: Container(
                            height: 58,
                            width: 58,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColorLight,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.shopping_bag_outlined,
                                color: Theme.of(context).primaryColorDark,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*
*
*  GridView.builder(
                  itemCount: products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.6,
                  ),
                  itemBuilder: (context, i) {
                    return InkWell(
                      onTap: (){
                        Get.to(const DetailPage(),arguments: products[i]);
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.40,
                        width: MediaQuery.of(context).size.width * 0.43,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Theme.of(context).primaryColorLight,
                        ),
                        child: Column(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  height: 170,
                                  width: MediaQuery.of(context).size.width * 0.43,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.asset(
                                      "${products[i].image}",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: InkWell(
                                    onTap: () {
                                      // addToFavList.add()
                                    },
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                          child: Icon(
                                            CupertinoIcons.suit_heart,
                                            color: Theme.of(context).primaryColorDark,
                                            size: 30,
                                          )),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            Text(
                              products[i].name,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w600,color: Theme.of(context).primaryColorDark),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              "\$${products[i].price}",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Theme.of(context).primaryColorDark,),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
* */
