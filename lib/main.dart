import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/auth.dart';
import './screens/editing_product_screen.dart';
import './screens/order_screen.dart';
import './providers/orders.dart';
import './screens/cart_screen.dart';
import './screens/products_overview_screen.dart';
import './providers/products_provider.dart';
import './providers/cart.dart';
import './screens/user_product_page.dart';
import './screens/auth_screen.dart';
import './screens/splash_screen.dart';
import './helpers/custom_route.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (_, auth, previous) =>
              Products(auth.token ?? '', auth.userId, previous!.items),
          create: (_) => Products('', '', []),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (_, auth, previous) =>
              Orders(auth.token ?? '', auth.userId, previous!.orders),
          create: (_) => Orders('', '', []),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, authData, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MyShop',
          theme: ThemeData(
              colorScheme: const ColorScheme.light(
                primary: Color.fromARGB(255, 8, 149, 255),
                secondary: Color.fromARGB(255, 156, 5, 232),
                onPrimary: Colors.white,
                onSecondary: Color.fromARGB(255, 255, 55, 100),
              ),
              appBarTheme: const AppBarTheme(
                titleTextStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Color.fromARGB(255, 255, 255, 255)),
              ),
              textTheme: const TextTheme(
                headline5: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: Colors.white),
                headline6: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
                headline4: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.purple),
              ),
              pageTransitionsTheme: PageTransitionsTheme(builders: {
                TargetPlatform.android: CustomPageTransitionBuilder(),
                TargetPlatform.iOS: CustomPageTransitionBuilder()
              })),
          home: authData.isAuth
              ? const ProductOverviewScreen()
              : FutureBuilder(
                  future: authData.tryAutoLogIn(),
                  builder: (ctx, authResoultsnapshot) =>
                      authResoultsnapshot.connectionState ==
                              ConnectionState.waiting
                          ? const SplashScreen()
                          : const AuthScreen()),
          routes: {
            CartScreen.routName: (ctx) => const CartScreen(),
            OrderScreen.routName: (ctx) => const OrderScreen(),
            UserProductPage.routName: (ctx) => const UserProductPage(),
            EditProductScreen.routName: (ctx) => const EditProductScreen(),
          },
        ),
      ),
    );
  }
}
