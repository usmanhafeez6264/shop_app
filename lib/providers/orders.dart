import 'package:flutter/cupertino.dart';
import 'package:shop_app/providers/product.dart';
import './cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Order {
  final String id;
  final double price;
  final List<CartItem> products;
  DateTime dateTime;
  Order(
      {required this.id,
      required this.price,
      required this.products,
      required this.dateTime});
}

class Orders with ChangeNotifier {
  List<Order> _order = [];

  List<Order> get orders {
    return [..._order];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double price) async {
    var url = Uri.parse(
        'https://shop-app-ad0a6-default-rtdb.firebaseio.com/orders/.json');
    final response = http.post(url,
        body: json.encode({
          'price': price,
          'datetime': DateTime.now().toIso8601String(),
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'price': cp.price,
                    'quantity': cp.quantity,
                  })
              .toList(),
        }));

    _order.insert(
      0,
      Order(
          id: DateTime.now().toString(),
          price: price,
          products: cartProducts,
          dateTime: DateTime.now()),
    );
    notifyListeners();
  }
}
