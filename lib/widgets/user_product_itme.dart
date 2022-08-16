import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../screens/editing_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String id;

  const UserProductItem(this.title, this.imageUrl, this.id, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var scaffold = ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(color: Colors.black),
      ),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routName, arguments: id);
              },
              icon: const Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              onPressed: () async {
                try {
                  await Provider.of<Products>(context, listen: false)
                      .deleteProduct(id);
                } catch (error) {
                  scaffold.showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Deleting failed!',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
              },
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).errorColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
