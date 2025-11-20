import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../models/listing.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
import '../models/session.dart';

class ApiService {
  static const String baseUrl = 'https://finilume-shop-backend.onrender.com';
  final Dio _dio = Dio();

  ApiService() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
  }

  // ---------------- PRODUCTS ----------------
  Future<List<Product>> getProducts() async {
    final res = await _dio.get('/products');
    final data = res.data;
    final list = (data['items'] as List? ?? []).cast();
    return list.map((x) => Product.fromJson(Map<String, dynamic>.from(x))).toList();
  }

  Future<Product> getProduct(String id) async {
    final res = await _dio.get('/products/$id');
    final data = res.data;
    if (data is Map && data.containsKey('item')) {
      return Product.fromJson(Map<String, dynamic>.from(data['item']));
    }
    return Product.fromJson(Map<String, dynamic>.from(data));
  }

  // ---------------- LISTINGS ----------------
  Future<List<Listing>> getListings(String productId) async {
    final res = await _dio.get('/products/$productId/listings');
    final list = (res.data as List? ?? []).cast();
    return list.map((x) => Listing.fromJson(Map<String, dynamic>.from(x))).toList();
  }

  // ---------------- CART ----------------

  /// Start a new cart session
  Future<String> startSession() async {
    final res = await _dio.post('/cart/start');
    final data = res.data as Map<String, dynamic>;
    final sessionId = data['sessionId']?.toString() ?? '';
    debugPrint('[Api] startSession -> $sessionId');
    return sessionId;
  }

  /// Add item to cart (returns the added CartItem)
Future<CartItem> addToCart(String sessionId, String listingId, int quantity) async {
  if (sessionId.isEmpty) {
    throw StateError('SessionId is empty before addToCart');
  }
  if (listingId.isEmpty) {
    throw StateError('ListingId is empty before addToCart');
  }

  debugPrint('[Api] addToCart -> sessionId=$sessionId listingId=$listingId qty=$quantity');

  // Step 1: Add item to cart
  final res = await _dio.post(
    '/cart/items',
    queryParameters: {'sessionId': sessionId},
    data: {
      'listingId': listingId,
      'quantity': quantity,
    },
  );

  final item = CartItem.fromJson(Map<String, dynamic>.from(res.data));
  debugPrint('[Api] addToCart response status=${res.statusCode} data=${res.data}');

  // Step 2: Hydrate listing details
  try {
    final listingRes = await _dio.get('/listings/$listingId');
    final listing = Listing.fromJson(Map<String, dynamic>.from(listingRes.data));
    return item.copyWith(listing: listing);
  } catch (e) {
    debugPrint('[Api] listing hydration failed: $e');
    return item; // fallback: return item without listing
  }
}


  // ---------------- CHECKOUT ----------------
  Future<Order> checkout({
    required String sessionId,
    required String customerName,
    required String customerPhone,
    required String customerEmail,
    required String shippingAddress,
  }) async {
    if (sessionId.isEmpty) {
      throw StateError('SessionId is empty before checkout');
    }

    final res = await _dio.post(
      '/checkout',
      data: {
        'sessionId': sessionId,
        'customerName': customerName,
        'customerPhone': customerPhone,
        'customerEmail': customerEmail,
        'shippingAddress': shippingAddress,
      },
    );
    return Order.fromJson(Map<String, dynamic>.from(res.data));
  }
}
