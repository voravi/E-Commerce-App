import 'dart:convert';
import 'dart:typed_data';

import 'package:e_commerce_app/modals/product.dart';
import 'package:e_commerce_app/utils/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../providers/product_controller.dart';

class CartPage extends StatefulWidget {
  CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
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
            Row(
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
                  " Cart Page",
                  style: TextStyle(color: Theme.of(context).primaryColorDark, fontSize: 19),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Obx(
              () => Container(
                height: MediaQuery.of(context).size.height * 0.70,
                // color: Colors.amber,
                width: double.infinity,
                child: ListView.builder(
                  itemCount: productController.addedProduct.length,
                  itemBuilder: (context, i) {
                    if (productController.addedProduct[i].image != null) {
                      decodedImage = base64Decode(productController.addedProduct[i].image);
                    } else {
                      decodedImage == null;
                    }

                    return Obx(
                      () => ListTile(
                        leading: Image.memory(
                          decodedImage!,
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(
                          productController.addedProduct[i].name,
                          style: TextStyle(color: Theme.of(context).primaryColorDark, fontSize: 10),
                        ),
                        subtitle: Text(
                          "Price: ${productController.addedProduct[i].dummyPrice}",
                          style: TextStyle(color: Colors.grey, fontSize: 8),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColorDark,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  //Provider.of<ProductController>(context, listen: false).addProduct(product: productController.addedProduct[i]);
                                  productController.addProduct(product: productController.addedProduct[i]);
                                  setState((){});
                                },
                                icon: Icon(
                                  Icons.add,
                                  color: Theme.of(context).primaryColorLight,
                                ),
                              ),
                            ),
                            Text(
                              "   ${productController.addedProduct[i].quantity}   ",
                              style: TextStyle(
                                color: Theme.of(context).primaryColorDark,
                              ),
                            ),
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColorDark,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  productController.removeProduct(product: productController.addedProduct[i]);
                                  setState(() {});
                                },
                                icon: Icon(
                                  Icons.remove,
                                  color: Theme.of(context).primaryColorLight,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 55),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Products: ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Theme.of(context).primaryColorDark),
                  ),
                  Text(
                    "${productController.totalProducts}",
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 55),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Price: ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Theme.of(context).primaryColorDark),
                  ),
                  Text(
                    "\$${productController.totalPrice}",
                    style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 18),
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
