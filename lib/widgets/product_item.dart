import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_management/providers/cart.dart';
import '../screens/product_detail_screen.dart';
import '../providers/product_model.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context, listen: false);
    final _authToken = Provider.of<Auth>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        header: Container(
          alignment: Alignment.center,
          child: Text(
            '${_product.price}',
            style: Theme.of(context).textTheme.headline6,
          ),
          color: Colors.black54,
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) =>
                    ProductDetailedScreen(_product.title, _product.id),
              ),
            );
          },
          child: Hero(
            tag: _product.id!,
            child: FadeInImage(
              placeholder: const AssetImage('assets/product-placeholder.png'),
              image: NetworkImage(_product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: ((cts, value, doesntMatter) => IconButton(
                  onPressed: () async {
                    await _product
                        .toggleFavoriteStatus(
                            _authToken.token!, _authToken.userId)
                        .catchError((error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Favorite was not changed',
                            textAlign: TextAlign.center,
                          ),
                          duration: Duration(
                            seconds: 3,
                          ),
                        ),
                      );
                    });
                  },
                  icon: Icon(
                      _product.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Theme.of(context).colorScheme.secondary),
                )),
          ),
          title: Text(
            _product.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6,
          ),
          trailing: IconButton(
            onPressed: () {
              cart.addItem(_product.id!, _product.price, _product.title);

              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Item added to cart'),
                  duration: const Duration(seconds: 5),
                  action: SnackBarAction(
                      label: 'Undu',
                      onPressed: () {
                        cart.removeSingleItem(_product.id!);
                      }),
                ),
              );
            },
            icon: Icon(Icons.shopping_cart,
                color: Theme.of(context).colorScheme.secondary),
          ),
        ),
      ),
    );
  }
}
