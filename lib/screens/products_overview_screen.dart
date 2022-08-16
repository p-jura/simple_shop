// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_management/screens/cart_screen.dart';

import '../providers/products_provider.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import '../widgets/products_grid.dart';
import '../widgets/app_drawer.dart';

enum FilterOptions {
  Favorite,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _isLoading = true;
      Provider.of<Products>(context, listen: false)
          .fethAndSetProducts()
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text(
          'MyShop',
        ),
        actions: [
          PopupMenuButton(
            onSelected: (values) {
              setState(() {
                if (values == FilterOptions.Favorite) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOptions.Favorite,
              ),
              const PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
            ],
            icon: const Icon(
              Icons.more_vert,
            ),
          ),
          Consumer<Cart>(
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, CartScreen.routName);
              },
              icon: const Icon(
                Icons.shopping_cart,
              ),
            ),
            builder: (c, cartData, myChild) => Badge(
              value: cartData.itemCount.toString(),
              child: myChild!,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(_showOnlyFavorites),
    );
  }
}
