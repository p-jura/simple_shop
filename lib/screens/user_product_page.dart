import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../providers/products_provider.dart';
import '../widgets/user_product_itme.dart';
import '../screens/editing_product_screen.dart';

class UserProductPage extends StatelessWidget {
  static const routName = '/user-product';

  const UserProductPage({Key? key}) : super(key: key);

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fethAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    //final productsData = Provider.of<Products>(context);
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<Products>(
                      builder: (context, productsData, _) => Padding(
                        padding: const EdgeInsets.all(10),
                        child: ListView.builder(
                          itemCount: productsData.items.length,
                          itemBuilder: (_, count) => Column(
                            children: [
                              UserProductItem(
                                  productsData.items[count].title,
                                  productsData.items[count].imageUrl,
                                  productsData.items[count].id!),
                              const Divider(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
