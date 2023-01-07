import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../modals/product.dart';
import '../utils/globals.dart';

class ProductController extends GetxController {
  RxList<Product> addedProduct = <Product>[].obs;

  get totalPrice {
    double price = 0.0;
    for (Product product in addedProduct) {
      price = (price + (product.price * product.quantity));
    }
    return price;
  }

  get totalProducts {
    int products = 0;
    for (Product product in addedProduct) {
      products = products + product.quantity;
    }
    return products;
  }

  void addProduct({required Product product}) {
    int flag = 0;
    for (Product addProduct in addedProduct) {
      if (addProduct.id == product.id) {
        product.quantity = product.quantity + 1;
        addProduct.dummyPrice = addProduct.price * product.quantity;
        flag = 1;
      }
    }
    if (flag == 0) {
      addedProduct.add(product);
    }
  }

  void removeProduct({required Product product}) {
    if (product.quantity > 1) {
      product.quantity = product.quantity - 1;
      product.dummyPrice = product.price * product.quantity;
    } else {
      addedProduct.remove(product);
    }
  }

}
