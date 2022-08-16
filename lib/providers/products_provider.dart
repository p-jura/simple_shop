// ignore_for_file: prefer_final_fields
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'product_model.dart';
import '../models/http_exception.dart' as exception;

class Products with ChangeNotifier {
  List<Product> _items = [];

  final String authToken;
  final String userId;

  Products(this.authToken, this.userId, this._items);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoritItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Future<void> fethAndSetProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    final url = Uri.parse(
        'https://flutter-app-state-management-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$authToken&$filterString');
    try {
      final responce = await http.get(url);
      final dataExtracted = jsonDecode(responce.body) as Map<String, dynamic>;
      final favUrl = Uri.parse(
          'https://flutter-app-state-management-default-rtdb.europe-west1.firebasedatabase.app/userFavorites/$userId.json?auth=$authToken');
      final favoriteResponse = await http.get(favUrl);
      final favoriteData = json.decode(favoriteResponse.body);
      final List<Product> loadedProducts = [];
      dataExtracted.forEach(
        (prodId, prodData) {
          loadedProducts.add(
            Product(
              id: prodId,
              title: prodData['title'],
              description: prodData['description'],
              imageUrl: prodData['imageUrl'],
              price: prodData['price'],
              isFavorite:
                  favoriteData == null ? false : favoriteData[prodId] ?? false,
            ),
          );
        },
      );
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://flutter-app-state-management-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$authToken');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'creatorId': userId,
          },
        ),
      );
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Product findById(String id) {
    return _items.firstWhere((product) => id == product.id);
  }

  Future<void> editProduct(String id, Product newProduct) async {
    var productIndex = _items.indexWhere((product) => product.id == id);
    final url = Uri.parse(
        'https://flutter-app-state-management-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json?auth=$authToken');
    try {
      // ignore: unused_local_variable
      final response = await http
          .patch(url,
              body: json.encode({
                'title': newProduct.title,
                'description': newProduct.description,
                'price': newProduct.price,
                'imageUrl': newProduct.imageUrl
              }))
          .timeout(const Duration(seconds: 10));
      if (productIndex >= 0) {
        _items[productIndex] = newProduct;

        notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'https://flutter-app-state-management-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json?auth=$authToken');
    final existingProdIndex = _items.indexWhere((product) => product.id == id);
    Product? existingProduct = _items[existingProdIndex];
    _items.removeAt(existingProdIndex);

    final response = await http.delete(url);
    
    notifyListeners();

    if (response.statusCode >= 400) {
      _items.insert(existingProdIndex, existingProduct);
      notifyListeners();

      throw exception.HttpException('Could not delete product.');
    }
    existingProduct = null;
  }
}
