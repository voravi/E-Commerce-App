import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:e_commerce_app/modals/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/product_firebase_helper.dart';
import '../utils/style_utiles.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  TextEditingController productNameController = TextEditingController();
  TextEditingController productPriceController = TextEditingController();
  TextEditingController productIdController = TextEditingController();
  TextEditingController productQuantityController = TextEditingController();

  int initialIndex = 0;
  Uint8List? image;
  String encodedImage = "";
  int dummy = 0;

  @override
  Widget build(BuildContext context) {
    Product? product = ModalRoute.of(context)!.settings.arguments as Product?;
    log(product.toString());
    if (dummy == 0 && product != null) {
      dummy++;
      productIdController.text = product.id.toString();
      productNameController.text = product.name;
      productPriceController.text = product.price.toString();
      productQuantityController.text = product.quantity.toString();
      image = base64Decode(product.image);
      encodedImage = base64Encode(image!);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Theme.of(context).primaryColorLight,
          ),
        ),
        title: Text(
          (product == null) ? "Add Product" : "Update",
          style: TextStyle(
            color: Theme.of(context).primaryColorLight,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Theme(
              data: Theme.of(context),
              child: Stepper(
                type: StepperType.vertical,
                physics: const ClampingScrollPhysics(),
                currentStep: initialIndex,
                onStepTapped: (val) {
                  setState(() {
                    initialIndex = val;
                  });
                },
                steps: [
                  Step(
                    title: Text(
                      "Product Id",
                      style: headTextStyle,
                    ),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 4,
                        ),
                        TextFields(
                          controller: productIdController,
                          hintText: "Enter ID",
                          lableText: "Id",
                          textInputType: TextInputType.number,
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                    isActive: (initialIndex >= 0) ? true : false,
                  ),
                  Step(
                    title: Text(
                      "Image Picture",
                      style: headTextStyle,
                    ),
                    content: Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 4,
                          ),
                          InkWell(
                            onTap: () async {
                              final ImagePicker _picker = ImagePicker();
                              XFile? img = await _picker.pickImage(source: ImageSource.gallery);

                              if (img != null) {
                                File compressedImage = await FlutterNativeImage.compressImage(img.path);
                                image = await compressedImage.readAsBytes();
                                encodedImage = base64Encode(image!);
                              }
                              setState(() {});
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: 50,
                              child: Center(
                                child: image == null
                                    ? const Text(
                                        "ADD IMAGE",
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                                      )
                                    : Container(
                                        height: 100,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(50),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.7),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Image.memory(
                                              image!,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    isActive: (initialIndex >= 1) ? true : false,
                  ),
                  Step(
                    title: Text(
                      "Product Name",
                      style: headTextStyle,
                    ),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 4,
                        ),
                        TextFields(
                          hintText: "Enter Name",
                          lableText: "Name",
                          controller: productNameController,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                    isActive: (initialIndex >= 2) ? true : false,
                  ),
                  Step(
                    title: Text(
                      "Product Price",
                      style: headTextStyle,
                    ),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 4,
                        ),
                        TextFields(hintText: "Enter Price", lableText: "Price", controller: productPriceController),
                        const SizedBox(height: 20),
                      ],
                    ),
                    isActive: (initialIndex >= 3) ? true : false,
                  ),
                  Step(
                    title: Text(
                      "Quantity",
                      style: headTextStyle,
                    ),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 4,
                        ),
                        TextFields(controller: productQuantityController, hintText: "Enter Quantity", lableText: "Quantity"),
                        const SizedBox(height: 20),
                      ],
                    ),
                    isActive: (initialIndex >= 4) ? true : false,
                  ),
                ],
                onStepContinue: () {
                  setState(() {
                    if (initialIndex < 4) {
                      initialIndex++;
                    }
                  });
                },
                onStepCancel: () {
                  setState(() {
                    if (initialIndex > 0) {
                      initialIndex--;
                    }
                  });
                },
                controlsBuilder: (context, controlDetails) {
                  return Row(
                    children: [
                      if (initialIndex < 4) ...[
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColorDark,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 10,
                            ),
                          ),
                          onPressed: controlDetails.onStepContinue,
                          child: Text(
                            "Next",
                            style: TextStyle(
                              color: Theme.of(context).primaryColorLight,
                            ),
                          ),
                        ),
                      ] else ...[
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColorDark,
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                          ),
                          onPressed: () async {
                            log(productIdController.text, name: "Product id");
                            log(productNameController.text, name: "Product name");
                            log(productPriceController.text, name: "Price name");
                            log(productQuantityController.text, name: "Quantity name");
                            log(image!.elementSizeInBytes.toString(), name: "Image");

                            if(product == null) {
                              Product pro = Product(
                                id: int.parse(productIdController.text),
                                name: productNameController.text,
                                price: double.parse(productPriceController.text),
                                image: encodedImage,
                                quantity: int.parse(productQuantityController.text),
                                isLike: false,
                                dummyPrice: double.parse(
                                  productPriceController.text,
                                ),
                              );

                              await ProductFirebaseHelper.productFirebaseHelper.insertData(product: pro);
                              // products.add(product);
                              Get.back();

                            } else {

                              Product pro2 = Product(
                                id: int.parse(productIdController.text),
                                name: productNameController.text,
                                price: double.parse(productPriceController.text),
                                image: encodedImage,
                                quantity: int.parse(productQuantityController.text),
                                isLike: product.isLike,
                                dummyPrice: double.parse(
                                  productPriceController.text,
                                ),
                              );

                              await ProductFirebaseHelper.productFirebaseHelper.updateData(product: pro2);

                              Get.offAllNamed("/");
                            }


                          },
                          child: Text(
                            "Save",
                            style: TextStyle(
                              color: Theme.of(context).primaryColorLight,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(
                        width: 20,
                      ),
                      if (initialIndex > 0) ...[
                        OutlinedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 10,
                            ),
                          ),
                          onPressed: controlDetails.onStepCancel,
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              color: Theme.of(context).primaryColorDark,
                            ),
                          ),
                        ),
                      ],
                    ],
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

// ignore: must_be_immutable
class TextFields extends StatelessWidget {
  TextFields({Key? key, required this.hintText, this.controller, this.lableText, this.textInputType, this.maxLines}) : super(key: key);

  String? hintText;
  String? lableText;
  TextEditingController? controller;
  TextInputType? textInputType;
  int? maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      textInputAction: TextInputAction.next,
      maxLines: maxLines,
      keyboardType: textInputType,
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: lableText,
        hintStyle: TextStyle(
          color: Colors.grey.shade400,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.grey.shade400,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.grey.shade400,
            width: 2,
          ),
        ),
      ),
    );
  }
}
