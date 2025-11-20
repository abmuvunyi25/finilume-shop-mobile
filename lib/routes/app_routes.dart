// lib/routes/app_routes.dart

import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/product_detail_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/checkout_screen.dart';
import '../screens/orders_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String productDetail = '/product';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String orders = '/orders';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case productDetail:
        final productId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => ProductDetailScreen(productId: productId),
        );

      case cart:
        return MaterialPageRoute(builder: (_) => const CartScreen());

      case checkout:
        return MaterialPageRoute(builder: (_) => const CheckoutScreen());

      case orders:
        return MaterialPageRoute(builder: (_) => const OrdersScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text("Page not found")),
          ),
        );
    }
  }
}
