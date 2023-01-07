import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:e_commerce_app/modals/product.dart';
import 'package:e_commerce_app/providers/product_controller.dart';
import 'package:e_commerce_app/providers/product_firebase_helper.dart';
import 'package:e_commerce_app/views/add_product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'cart_page.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  String q = "1";
  ProductController productController = Get.find();

  @override
  Widget build(BuildContext context) {

    Uint8List? decodedImage;
    Product product = ModalRoute.of(context)!.settings.arguments as Product;
    // log("${int.parse(product['quantity'])}",name: "See What happenes");
    q = product.quantity.toString();
    if (product.image != null) {
      decodedImage = base64Decode(product.image);
    } else {
      decodedImage == null;
    }

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 320,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey.withOpacity(0.7),
                  child: Image.memory(
                    decodedImage!,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 30,
                  left: 0,
                  right: 0,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: Icon(
                          Icons.arrow_back_ios_rounded,
                          color: Theme.of(context).primaryColorLight,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          CupertinoIcons.suit_heart,
                          color: Theme.of(context).primaryColorLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text(
                        "\$ ${product.price}",
                        style: TextStyle(
                          color: Theme.of(context).primaryColorDark,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                      Spacer(),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star,
                            size: 20,
                            color: Colors.amber,
                          ),
                          Icon(
                            Icons.star,
                            size: 20,
                            color: Colors.amber,
                          ),
                          Icon(
                            Icons.star,
                            size: 20,
                            color: Colors.amber,
                          ),
                          Icon(
                            Icons.star,
                            size: 20,
                            color: Colors.amber,
                          ),
                          Icon(
                            Icons.star_border,
                            size: 20,
                            color: Colors.amber,
                          )
                        ],
                      ),
                    ],
                  ),
                  Divider(),
                  Text(
                    "Description",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Theme.of(context).primaryColorDark),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour values.",
                    style: TextStyle(
                      color: Colors.grey.withOpacity(0.6),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).primaryColorDark,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: IconButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onPressed: () async {
                              int dum = int.parse(q);
                              dum++;
                              q = dum.toString();
                              await ProductFirebaseHelper.productFirebaseHelper.addQuantity(data: product, times: q);
                              setState(() {});
                            },
                            icon: Icon(
                              Icons.add,
                              color: Theme.of(context).primaryColorDark,
                            ),
                          ),
                        ),
                      ),
                      Text("      $q      ",style: TextStyle(color: Theme.of(context).primaryColorDark),),
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).primaryColorDark,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: IconButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onPressed: () async {
                              int dum = int.parse(q);
                              dum--;
                              q = dum.toString();
                              await ProductFirebaseHelper.productFirebaseHelper.removeQuantity(data: product, times: q);
                              setState(() {});
                            },
                            icon: Icon(
                              Icons.remove,
                              color: Theme.of(context).primaryColorDark,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      InkWell(
                        splashColor: Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(15),
                        onTap: () async {
                          productController.addProduct(product: product);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 13),
                              duration: Duration(seconds: 2),
                              backgroundColor: Theme.of(context).primaryColorDark,
                              content: Row(
                                children: [
                                  Text("Product Added To Cart",style: TextStyle(color: Theme.of(context).primaryColorLight),),
                                  Spacer(),
                                  InkWell(
                                    onTap: (){
                                      Get.to(CartPage());
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                      decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColorLight,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text("Show",style: TextStyle(color: Theme.of(context).primaryColorDark),),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        child: Ink(
                          height: 60,
                          width: MediaQuery.of(context).size.width * 0.47,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColorDark,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width * 0.47,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Add To Cart",
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColorLight,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 15,),
                      InkWell(
                        splashColor: Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(15),
                        onTap: () async {
                          await Get.to(AddProductScreen(),arguments: product);
                        },
                        child: Ink(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColorDark,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Icon(Icons.update,color: Theme.of(context).primaryColorLight,),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 15,),
                      InkWell(
                        splashColor: Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(15),
                        onTap: () async {
                          showDialog(context: context, builder: (context) {
                            return AlertDialog(
                              title: const Text("Delete Product"),
                              content: Text(
                                "Are you sure to delete this product permanently",
                              ),
                              actions: [
                                OutlinedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Cancel"),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.redAccent,
                                  ),
                                  onPressed: () async {
                                    ProductFirebaseHelper.productFirebaseHelper.deleteData(deleteId: product.id.toString());
                                    Get.back();
                                    Get.back();
                                  },
                                  child: const Text("Ok"),
                                ),
                              ],
                            );
                          },);
                        },
                        child: Ink(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColorDark,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Icon(Icons.delete_sweep_outlined,color: Theme.of(context).primaryColorLight,),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
