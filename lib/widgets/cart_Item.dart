// ignore_for_file: deprecated_member_use, duplicate_ignore, file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItemList extends StatelessWidget {
  final String cartItemId;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  const CartItemList(
      {Key? key, required this.cartItemId,
      required this.title,
      required this.productId,
      required this.price,
      required this.quantity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text(
              'Are You sure?',
            ),
            content:
                const Text('Do You whant to remove the item frome the card'),
            actions: [
              // ignore: deprecated_member_use
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: const Text('No'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        );
      },
      key: ValueKey(cartItemId),
      background: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        color: Theme.of(context).colorScheme.error,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              radius: 30,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: FittedBox(
                  child: Text(' $price zł'),
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total: ${price * quantity} zł'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
