import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/providers/product_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../modals/product.dart';
import '../providers/product_firebase_helper.dart';

class LikedProductPage extends StatefulWidget {
  const LikedProductPage({Key? key}) : super(key: key);

  @override
  State<LikedProductPage> createState() => _LikedProductPageState();
}

class _LikedProductPageState extends State<LikedProductPage> {
  ProductController productController = Get.find();
  Uint8List? decodedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorDark,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.arrow_back_ios_rounded,
                          size: 20,
                          color: Theme.of(context).primaryColorLight,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 80,
                  ),
                  Text(
                    "Liked Products",
                    style: TextStyle(color: Theme.of(context).primaryColorDark, fontSize: 19),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 19,
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

                    return ListView.builder(
                      itemCount: queryDocumentSnapshot.length,
                      itemBuilder: (context, i) {
                        Map<String, dynamic> data = queryDocumentSnapshot[i].data() as Map<String, dynamic>;

                        if (data["image"] != null) {
                          decodedImage = base64Decode(data["image"]);
                        } else {
                          decodedImage == null;
                        }

                        if (data['isLike'] == true) {
                          return ListTile(
                            leading: Image.memory(
                              decodedImage!,
                              height: 50,
                              width: 50,
                              fit: BoxFit.cover,
                            ),
                            title: Text(
                              data["name"],
                              style: TextStyle(color: Theme.of(context).primaryColorDark, fontSize: 12),
                            ),
                            subtitle: Text(
                              "Price: ${data['price']}",
                              style: TextStyle(color: Colors.grey, fontSize: 10),
                            ),
                            trailing: IconButton(
                              onPressed: () async {
                                Product pr = Product.fromMap(data: data);
                                await ProductFirebaseHelper.productFirebaseHelper.likeProduct(data: pr);
                              },
                              icon: (data['isLike'] == true)
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
                          );
                        } else {
                          return Container();
                        }
                      },
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
