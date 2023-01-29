import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem(
      {required this.id,
      required this.title,
      required this.quantity,
      required this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Cart(this.authToken, this._items);

  Map<String, CartItem> get items {
    return _items;
  }
  final String authToken;


  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  Future<void> addItem(String productId, double price, String title) async{
    if (_items.containsKey(productId)) {
      int cartProdNewQuantity = _items.values.firstWhere((element) => element.id == productId).quantity +1;
      final url =
          'https://spatial-logic-357716-default-rtdb.firebaseio.com/cart/$productId.json?auth=$authToken';
      await http.patch(Uri.parse(url), body: json.encode({
        'quantity': cartProdNewQuantity ,
      }),);
      _items.update(
          productId,
          (existingCardItem) => CartItem(
              id: existingCardItem.id,
              title: existingCardItem.title,
              quantity: existingCardItem.quantity + 1,
              price: existingCardItem.price));
    } else {
      final url =
          'https://spatial-logic-357716-default-rtdb.firebaseio.com/cart/$productId.json?auth=$authToken';
      await http.post(Uri.parse(url), body: json.encode({
        'productId':productId,
        'title': title,
        'quantity': 1,
        'price': price,
      }),);
      _items.putIfAbsent(
          productId,
          () => CartItem(
              id: productId,
              title: title,
              quantity: 1,
              price: price));
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantity > 1) {
      _items.update(
          productId,
          (existingCartItme) => CartItem(
              id: existingCartItme.id,
              title: existingCartItme.title,
              quantity: existingCartItme.quantity - 1,
              price: existingCartItme.price));
    }else{
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
