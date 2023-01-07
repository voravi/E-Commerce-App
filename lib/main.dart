import 'package:e_commerce_app/views/cart_page.dart';
import 'package:e_commerce_app/views/home_screen/page/home_screen.dart';
import 'package:e_commerce_app/views/product_detail_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

import '/utils/appRoutes.dart';
import '/utils/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'providers/product_controller.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    Get.put(ProductController());

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: Theme.of(context).colorScheme.copyWith(
          primary: Colors.black87,
        ),
        fontFamily: "Poppins",
        primaryColorLight: Colors.white,
        primaryColorDark: Colors.black87,
      ),
      darkTheme: ThemeData(
          colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: Colors.white,
          ),
          fontFamily: "Poppins",
        primaryColorLight: Colors.black87,
        primaryColorDark: Colors.white
      ),
      title: "E-commerce App",
      //home: HomePage(),
      initialRoute: "/",
      getPages: [
        GetPage(name: "/", page: () => HomePage()),
        GetPage(name: "/detailPage", page: () => DetailPage()),
        GetPage(name: "/cartPage", page: () => CartPage()),
      ],

    );
  }
}
