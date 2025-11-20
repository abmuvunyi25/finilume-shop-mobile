import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/api_service.dart';
import 'state/cart_provider.dart';
import 'state/order_provider.dart';
import 'themes/app_theme.dart';
import 'routes/app_routes.dart';
import 'screens/home_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/checkout_screen.dart';

void main() {
  runApp(const FinilumeApp());
}

class FinilumeApp extends StatelessWidget {
  const FinilumeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => ApiService()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProxyProvider<ApiService, OrderProvider>(
          create: (context) => OrderProvider(context.read<ApiService>()),
          update: (context, api, previous) => OrderProvider(api),
        ),
      ],
      child: MaterialApp(
        title: 'Finilume Shop',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const MainScreen(),
        debugShowCheckedModeBanner: false,
        routes: {
          '/checkout': (_) => const CheckoutScreen(),
          '/cart': (_) => const CartScreen(),
          '/orders': (_) => const OrdersScreen(),
        },
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  bool _initialized = false;

  final List<Widget> _screens = const [
    HomeScreen(),
    CartScreen(),
    OrdersScreen(),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _bootstrapCartSession();
      _initialized = true;
    }
  }

  /// Start a cart session once at app bootstrap
  Future<void> _bootstrapCartSession() async {
    final api = context.read<ApiService>();
    final cartProvider = context.read<CartProvider>();

    try {
      final newSessionId = await api.startSession();
      cartProvider.initializeSession(newSessionId);
      debugPrint("Cart session bootstrapped: $newSessionId");
    } catch (e) {
      debugPrint("Failed to bootstrap cart session: $e");
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                const Icon(Icons.shopping_cart),
                if (cart.itemCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                      child: Text(
                        '${cart.itemCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Cart',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
        ],
      ),
    );
  }
}
