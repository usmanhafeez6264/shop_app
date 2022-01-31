import 'package:flutter/cupertino.dart';
import 'package:shop_app/models/httpexception.dart';
import 'product.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favItems {
    return _items.where((prod) => prod.isFavourite).toList();
  }

  // void isFav() {}
  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchProducts() async {
    final url = Uri.parse(
        'https://project-edde1-default-rtdb.firebaseio.com//products.json');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['image'],
            isFavourite: prodData['isFav']));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product prod) async {
    try {
      var url = Uri.parse(
          'https://project-edde1-default-rtdb.firebaseio.com//products.json');
      final response = await http.post(
        url,
        body: json.encode({
          'title': prod.title,
          'description': prod.description,
          'price': prod.price,
          'image': prod.imageUrl,
          'isFav': prod.isFavourite
        }),
      );
      final newProd = Product(
          id: json.decode(response.body)['name'],
          title: prod.title,
          description: prod.description,
          price: prod.price,
          imageUrl: prod.imageUrl);
      _items.add(newProd);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> deleteProduct(String id) async {
    var url = Uri.parse(
        'https://project-edde1-default-rtdb.firebaseio.com//products/$id.json');

    /// optimistic updating
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Couldn\'t Perform Opertion');
    }
  }
}
