import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:state_management/models/http_exception.dart';

class Product with ChangeNotifier {
  final String? id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.isFavorite = false,
  });

  Future<void> toggleFavoriteStatus(String authToken, String userId) async {
    final currentFavoriteStatus = isFavorite;
    final url = Uri.parse(
        'https://flutter-app-state-management-default-rtdb.europe-west1.firebasedatabase.app/userFavorites/$userId/$id.json?auth=$authToken');
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final response = await http.put(
        url,
        body: json.encode(
           isFavorite,
        ),
      );
      if (response.statusCode >= 400) {
        throw HttpException('Error! Favorite was not changed.');
      }
    } catch (error) {
      isFavorite = currentFavoriteStatus;
      notifyListeners();
      rethrow;
    }
  }
}
