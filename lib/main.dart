import 'package:chopy/providers/auth.dart';
import 'package:chopy/providers/cart.dart';
import 'package:chopy/providers/orders.dart';
import 'package:chopy/screens/cart_screen.dart';
import 'package:chopy/screens/edit_product_screen.dart';
import 'package:chopy/screens/orders_screen.dart';
import 'package:chopy/screens/user_products_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chopy/screens/product_detail_screen.dart';
import 'package:chopy/screens/products_overview.dart';
import 'package:chopy/providers/products.dart';
import './screens/auth_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            create: (context) => Products('', [],),
            update: (context, auth, previousProducts) => Products(
              auth.token.toString(),
              previousProducts == null ? [] : previousProducts.items,
            ),
          ),
          ChangeNotifierProxyProvider<Auth,Cart>(
            create: (context) => Cart('', {},),
            update: (ctx, auth, previousCart) => Cart(
              auth.token.toString(),
              previousCart == null ? {} : previousCart.items,),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            create: (context)=> Orders('', []),
            update: (context, auth, previousOrders)=> Orders(
                auth.token.toString(),
                previousOrders==null? []: previousOrders.orders,
            ),
          ),
        ],
        child: Consumer<Auth>(
          builder: (context, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
                  .copyWith(secondary: Colors.deepOrange),
              fontFamily: 'Lato',
            ),
            home: auth.isAuth == true ? ProductsOverviewScreen() : AuthScreen(),
            routes: {
              ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
              CartScreen.routeName: (context) => CartScreen(),
              OrdersScreen.routeName: (context) => OrdersScreen(),
              UserProductsScreen.routeName: (context) => UserProductsScreen(),
              EditProductScreen.routeName: (context) => EditProductScreen(),
            },
          ),
        ));
  }
}
