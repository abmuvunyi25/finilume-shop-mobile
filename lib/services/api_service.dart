import 'package:dio/dio.dart';
import '../models/product.dart';
import '../models/listing.dart';
import '../models/merchant.dart';
import '../models/cart_item.dart';

class ApiService {
  static const String baseUrl = 'https://finilume-shop-backend.onrender.com';
  final Dio _dio = Dio();

  ApiService() {
    _dio.options.baseUrl = baseUrl;
  }

  // Products
  Future<List<Product>> getProducts() async {
    final res = await _dio.get('/products');
    return (res.data as List).map((x) => Product.fromJson(x)).toList();
  }

  Future<Product> getProduct(String id) async {
    final res = await _dio.get('/products/$id');
    return Product.fromJson(res.data);
  }

  // Cart
  Future<CartItem> addToCart(String listingId, int quantity) async {
    final res = await _dio.post('/cart', data: {
      'listingId': listingId,
      'quantity': quantity,
    });
    return CartItem.fromJson(res.data);
  }

  Future<List<CartItem>> getCart() async {
    final res = await _dio.get('/cart');
    return (res.data as List).map((x) => CartItem.fromJson(x)).toList();
  }

  Future<Map<String, dynamic>> checkout() async {
    final res = await _dio.post('/checkout');
    return res.data;
  }
}