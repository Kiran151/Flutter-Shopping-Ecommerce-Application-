import 'package:flutter/material.dart';
import 'package:shopy/providers/auth.dart';
import 'package:shopy/providers/cart.dart';
import 'package:shopy/providers/orders.dart';
import 'package:shopy/screens/auth_screen.dart';
import 'package:shopy/screens/cart_screen.dart';
import 'package:shopy/screens/edit_product_screen.dart';
import 'package:shopy/screens/orders_screen.dart';
import 'package:shopy/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:shopy/screens/product_overview_screen.dart';
import 'package:shopy/screens/splash_screen.dart';
import 'package:shopy/screens/user_products_screen.dart';
import './providers/products.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (context) => Products(
            Provider.of<Auth>(context, listen: false).token!,
            Provider.of<Auth>(context, listen: false).userId!,
          ),
          update: (context, auth, previousProducts) => Products(
            auth.token ?? '', auth.userId ?? '',
            // previousProducts! == null ? [] : previousProducts.items
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => Orders(),
        ),
        ChangeNotifierProvider(create: (ctx) => Cart()),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Shopy',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            fontFamily: 'Lato',
          ),
          home: auth.isAuth
              ? const ProductOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (context, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? const SplashScreen()
                          : const AuthScreen()),
          routes: {
            ProductDetailScreen.routeName: (context) =>
                const ProductDetailScreen(),
            CartScreen.routeName: (context) => const CartScreen(),
            OrdersScreen.routeName: (context) => const OrdersScreen(),
            UserProductsScreen.routeName: (context) =>
                const UserProductsScreen(),
            EditProductScreen.routeName: (context) => const EditProductScreen(),
          },
        ),
      ),
    );
  }
}
