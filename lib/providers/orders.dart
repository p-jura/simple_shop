import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {required this.id,
      required this.amount,
      required this.dateTime,
      required this.products});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  final String _authToken;
  final String userId;

  Orders(this._authToken, this.userId, this._orders);

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.parse(
        'https://flutter-app-state-management-default-rtdb.europe-west1.firebasedatabase.app/orders/$userId.json?auth=$_authToken');
    final dataTimeNow = DateTime.now();
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'products': [
              ...cartProducts.map((product) {
                return {
                  'id': product.id,
                  'title': product.title,
                  'quantity': product.quantity,
                  'price': product.price
                };
              }).toList()
            ],
            'dateTime': dataTimeNow.toIso8601String(),
            'amount': total,
          },
        ),
      );
      _orders.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            amount: total,
            dateTime: dataTimeNow,
            products: cartProducts),
      );
      notifyListeners();
    } catch (_) {
      rethrow;
    }
  }

  Future<void> getAndSetOrders() async {
    final url = Uri.parse(
        'https://flutter-app-state-management-default-rtdb.europe-west1.firebasedatabase.app/orders/$userId.json?auth=$_authToken');

    final response = await http.get(url);

    try {
      final fetchedOrders = json.decode(response.body) as Map<String, dynamic>;
      final List<OrderItem> listOfOrders = [];

      fetchedOrders.forEach((orderId, orderItem) {
        listOfOrders.add(
          OrderItem(
            id: orderId,
            amount: orderItem['amount'],
            dateTime: DateTime.parse(orderItem['dateTime']),
            products: (orderItem['products'] as List<dynamic>).map((cartItem) {
              return CartItem(
                  id: cartItem['id'],
                  title: cartItem['title'],
                  price: cartItem['price'],
                  quantity: cartItem['quantity']);
            }).toList(),
          ),
        );
      });
      _orders = listOfOrders.reversed.toList();
      notifyListeners();
    } catch (_) {}
  }
}
