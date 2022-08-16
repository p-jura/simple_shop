import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';

class ProductDetailedScreen extends StatelessWidget {
  final String title;
  final String? id;
  const ProductDetailedScreen(this.title, this.id, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(id!);

    return Scaffold(
      
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                padding: const EdgeInsets.all(8),
                //color: Colors.black.withOpacity(0.5),
                child: Text(
                  loadedProduct.title,
                ),
              ),
              background: Hero(
                tag: loadedProduct.id!,
                child: Image.network(
                  loadedProduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(
                  height: 10,
                ),
                Text(
                  '\$ ${loadedProduct.price}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  width: double.infinity,
                  child: Text(
                    loadedProduct.description,
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
                const SizedBox(height: 600),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
