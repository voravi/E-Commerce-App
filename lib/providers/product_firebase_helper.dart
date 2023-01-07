import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_app/modals/product.dart';

class ProductFirebaseHelper {
  ProductFirebaseHelper._();

  static final ProductFirebaseHelper productFirebaseHelper = ProductFirebaseHelper._();

  static final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  CollectionReference products = firebaseFirestore.collection("products");

  insertData({required Product product}) async {
    await products.doc("${product.id}").set({
      "id": product.id,
      "name": product.name,
      "quantity": product.quantity,
      "price": product.price,
      "dummyPrice": product.dummyPrice,
      "image": product.image,
      "isLike": product.isLike,
    });
  }

  updateData({required Product product}) async {
    await products.doc("${product.id}").update(
        {
          "id": product.id,
          "name": product.name,
          "quantity": product.quantity,
          "price": product.price,
          "image": product.image,
        }
    );
  }


  Stream<QuerySnapshot> fetchData(){
      Stream<QuerySnapshot> stream = products.snapshots();
      return stream;
  }

  addQuantity({required Product data,required String times}) async {
    await products.doc("${data.id}").update({
      "quantity" : times
    });
    data.quantity = int.parse(times);
  }

  removeQuantity({required Product data,required String times}) async {
    await products.doc("${data.id}").update({
      "quantity" : times
    });
    data.quantity = int.parse(times);
  }

  likeProduct({required Product data}) async {

    if(data.isLike == false) {
      await products.doc("${data.id}").update({
        "isLike" : true
      });
    } else {
      await products.doc("${data.id}").update({
        "isLike" : false
      });
    }

  }


  Future<void> deleteData({required String deleteId}) async {
    await products.doc(deleteId).delete();
  }



}
