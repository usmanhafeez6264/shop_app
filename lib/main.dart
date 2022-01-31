import 'package:flutter/material.dart';
import 'package:shop_app/screens/product_overview_screen.dart';
import '../providers/cart.dart';
import '../screens/cart_screen.dart';
import '../screens/user_products.dart';
import './screens/product_detail_screen.dart';
import './providers/products.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart';
import '../screens/order_screen.dart';
import './screens/add_new_product.dart';
import './screens/auth.dart';
import './providers/auth_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (ctx) => AuthProvider(),
        ),
        ChangeNotifierProvider<Products>(
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Orders(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
        builder: (ctx, auth, _) => MaterialApp(
              title: 'My Shop',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: auth.isAuth ? ProductOverviewScreen() : Auth(),
              routes: {
                ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
                CartScreen.routeName: (ctx) => CartScreen(),
                OrderScreen.routeName: (ctx) => OrderScreen(),
                UserProducts.routeName: (ctx) => UserProducts(),
                AddNewProduct.routeName: (ctx) => AddNewProduct(),
              },
            ));
  }
}



// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return ProductOverviewScreen();
//   }
// }
