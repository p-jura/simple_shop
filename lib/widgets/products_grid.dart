import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../widgets/product_item.dart';

class ProductGrid extends StatelessWidget {
  final bool _showOnlyFavorites;

  const ProductGrid(this._showOnlyFavorites, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);

    final product =
        _showOnlyFavorites ? productsData.favoritItems : productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: product.length,
      itemBuilder: (ctx, index) {
        return ChangeNotifierProvider.value(
          value: product[index],
          child: const ProductItem(),
        );
      },
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
