import 'package:get/get.dart';

class Product {
  int id;
  String name;
  double price;
  String image;
  int quantity;
  bool isLike;
  double dummyPrice;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.quantity,
    required this.isLike,
    required this.dummyPrice,
  });

  factory Product.fromMap({required Map data}) {
    return Product(
      id: data["id"],
      name: data["name"],
      price: data["price"],
      image: data["image"],
      quantity: int.parse(data["quantity"]),
      dummyPrice: data["dummyPrice"],
      isLike: data["isLike"],
    );
  }
}